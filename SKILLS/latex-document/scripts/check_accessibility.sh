#!/usr/bin/env bash
# check_accessibility.sh - Source-first accessibility and PDF handoff checks

set -euo pipefail

usage() {
  cat <<'EOF'
check_accessibility.sh - Check LaTeX document accessibility readiness

Usage:
  check_accessibility.sh <project-dir|main.tex|document.pdf> [OPTIONS]

Options:
  --json       Emit machine-readable JSON summary
  --strict     Treat warnings as failures
  -h, --help   Show this help

Checks:
  LaTeX metadata, hyperref/PDF-A setup, figure/table captions, image alt-text hints,
  raw URLs, PDF header, optional PDF metadata, and optional encryption status.
EOF
}

TARGET=""
JSON=false
STRICT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON=true; shift ;;
    --strict) STRICT=true; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Error: Unknown option $1" >&2; exit 1 ;;
    *) TARGET="$1"; shift ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  echo "Error: target is required" >&2
  usage >&2
  exit 1
fi

ERRORS=()
WARNINGS=()
INFO=()
PROJECT_DIR=""
MAIN_TEX=""
PDF_FILE=""
DOCUMENT_YAML=""

add_error() { ERRORS+=("$1"); }
add_warning() { WARNINGS+=("$1"); }
add_info() { INFO+=("$1"); }

json_array() {
  python3 - "$@" <<'PY'
import json
import sys
print(json.dumps(list(sys.argv[1:])))
PY
}

resolve_target() {
  if [[ -d "$TARGET" ]]; then
    PROJECT_DIR="$(cd "$TARGET" && pwd)"
    DOCUMENT_YAML="${PROJECT_DIR}/document.yaml"
    MAIN_TEX="${PROJECT_DIR}/main.tex"
    PDF_FILE="${PROJECT_DIR}/outputs/main.pdf"
    [[ -f "$PDF_FILE" ]] || PDF_FILE="${PROJECT_DIR}/main.pdf"
  elif [[ -f "$TARGET" && "$TARGET" == *.tex ]]; then
    MAIN_TEX="$(cd "$(dirname "$TARGET")" && pwd)/$(basename "$TARGET")"
    PROJECT_DIR="$(dirname "$MAIN_TEX")"
    DOCUMENT_YAML="${PROJECT_DIR}/document.yaml"
    PDF_FILE="${MAIN_TEX%.tex}.pdf"
  elif [[ -f "$TARGET" && "$TARGET" == *.pdf ]]; then
    PDF_FILE="$(cd "$(dirname "$TARGET")" && pwd)/$(basename "$TARGET")"
    PROJECT_DIR="$(dirname "$PDF_FILE")"
  else
    add_error "target must be a project directory, .tex file, or .pdf file: $TARGET"
  fi
}

strip_comments() {
  local file="$1"
  sed 's/%.*//;/^[[:space:]]*$/d' "$file" 2>/dev/null || true
}

declare -A SOURCE_SEEN=()
gather_latex_source_graph() {
  local tex_path="$1"
  [[ -f "$tex_path" ]] || return 0
  tex_path="$(cd "$(dirname "$tex_path")" && pwd)/$(basename "$tex_path")"
  [[ -n "${SOURCE_SEEN[$tex_path]:-}" ]] && return 0
  SOURCE_SEEN[$tex_path]=1

  local text tex_dir include_path include_file
  text="$(strip_comments "$tex_path")"
  printf '%s\n' "$text"
  tex_dir="$(dirname "$tex_path")"
  while IFS= read -r include_path; do
    [[ -z "$include_path" ]] && continue
    include_file="$include_path"
    [[ "$include_file" == *.tex ]] || include_file="${include_file}.tex"
    [[ "$include_file" = /* ]] || include_file="${tex_dir}/${include_file}"
    gather_latex_source_graph "$include_file"
  done < <(echo "$text" | grep -oE '\\(input|include)[[:space:]]*\{[^}]+\}' | sed -E 's/\\(input|include)[[:space:]]*\{([^}]+)\}/\2/')
}

check_metadata() {
  local source_text="$1"
  local has_title=false
  local has_author=false

  if [[ -f "$DOCUMENT_YAML" ]]; then
    grep -qE '^title:[[:space:]]*"?.+"?' "$DOCUMENT_YAML" && has_title=true
    grep -qE '^author:[[:space:]]*"?.+"?' "$DOCUMENT_YAML" && has_author=true
  fi

  if [[ -n "$PROJECT_DIR" ]]; then
    while IFS= read -r -d '' xmp_file; do
      grep -qE '\\Title\{[^}]+\}' "$xmp_file" && has_title=true
      grep -qE '\\Author\{[^}]+\}' "$xmp_file" && has_author=true
    done < <(find "$PROJECT_DIR" -maxdepth 1 -type f -name '*.xmpdata' -print0 2>/dev/null)
  fi

  echo "$source_text" | grep -qE '\\title\{' && has_title=true
  echo "$source_text" | grep -qE '\\author\{' && has_author=true
  echo "$source_text" | grep -qE 'pdftitle[[:space:]]*=' && has_title=true
  echo "$source_text" | grep -qE 'pdfauthor[[:space:]]*=' && has_author=true

  [[ "$has_title" == true ]] || add_warning "missing document title metadata"
  [[ "$has_author" == true ]] || add_warning "missing document author metadata"
}

check_latex_source() {
  [[ -n "$MAIN_TEX" ]] || return 0
  if [[ ! -f "$MAIN_TEX" ]]; then
    add_error "main LaTeX file not found: $MAIN_TEX"
    return 0
  fi

  local source_text
  SOURCE_SEEN=()
  source_text="$(gather_latex_source_graph "$MAIN_TEX")"

  check_metadata "$source_text"

  if echo "$source_text" | grep -qE '\\usepackage(\[[^]]*\])?\{pdfx\}'; then
    add_info "PDF/A package detected: pdfx"
  elif echo "$source_text" | grep -qE '\\usepackage(\[[^]]*\])?\{hyperref\}'; then
    add_info "hyperref detected"
    add_warning "PDF/A package not detected; use build --pdfa or pdfx for archival submissions"
  else
    add_warning "neither hyperref nor pdfx detected; links and PDF metadata may be inaccessible"
  fi

  local img_count
  img_count=$(echo "$source_text" | grep -cE '\\includegraphics(\[[^]]*\])?\{' || true)
  if [[ "$img_count" -gt 0 ]]; then
    local alt_hint_count
    alt_hint_count=$(echo "$source_text" | grep -cE '\\(caption|Description|AltText|pdftooltip)\{' || true)
    if [[ "$alt_hint_count" -lt "$img_count" ]]; then
      add_warning "images found without enough caption/description/alt-text hints (${alt_hint_count}/${img_count})"
    fi
  fi

  local figure_blocks table_blocks caption_blocks
  figure_blocks=$(echo "$source_text" | grep -cE '\\begin\{figure\}' || true)
  table_blocks=$(echo "$source_text" | grep -cE '\\begin\{table\}' || true)
  caption_blocks=$(echo "$source_text" | grep -cE '\\caption\{' || true)
  if [[ "$figure_blocks" -gt 0 && "$caption_blocks" -lt "$figure_blocks" ]]; then
    add_warning "some figure environments may be missing captions"
  fi
  if [[ "$table_blocks" -gt 0 && "$caption_blocks" -lt $((figure_blocks + table_blocks)) ]]; then
    add_warning "some table environments may be missing captions"
  fi

  local url_scan_text
  url_scan_text="$(echo "$source_text" | sed -E 's/\\url\{https?:\/\/[^}]+\}//g; s/\\href\{https?:\/\/[^}]+\}\{[^}]*\}//g')"
  if echo "$url_scan_text" | grep -qE 'https?://[^}[:space:]]+'; then
    add_warning "raw URLs detected; wrap links with \\url{} or \\href{}"
  fi
}

check_pdf_file() {
  [[ -n "$PDF_FILE" && -f "$PDF_FILE" ]] || return 0

  if [[ "$(head -c 5 "$PDF_FILE" 2>/dev/null || true)" != "%PDF-" ]]; then
    add_error "PDF does not start with a valid %PDF- header: $PDF_FILE"
    return 0
  fi
  add_info "PDF header is valid"

  if command -v pdfinfo >/dev/null 2>&1 && command -v timeout >/dev/null 2>&1; then
    local pdfinfo_out pdfinfo_status
    pdfinfo_status=0
    pdfinfo_out="$(timeout 5 pdfinfo "$PDF_FILE" 2>/dev/null)" || pdfinfo_status=$?
    if [[ $pdfinfo_status -eq 124 ]]; then
      add_warning "pdfinfo timed out; skipped PDF metadata probe"
    elif [[ $pdfinfo_status -ne 0 ]]; then
      add_warning "pdfinfo could not read PDF metadata"
    else
      echo "$pdfinfo_out" | grep -qE '^Title:[[:space:]]+.' || add_warning "PDF metadata title missing"
      echo "$pdfinfo_out" | grep -qE '^Author:[[:space:]]+.' || add_warning "PDF metadata author missing"
    fi
  else
    add_info "pdfinfo or timeout not available; skipped PDF metadata probe"
  fi

  if command -v qpdf >/dev/null 2>&1; then
    local qpdf_out qpdf_status
    qpdf_status=0
    if command -v timeout >/dev/null 2>&1; then
      qpdf_out="$(timeout 5 qpdf --show-encryption "$PDF_FILE" 2>/dev/null)" || qpdf_status=$?
    else
      qpdf_out="$(qpdf --show-encryption "$PDF_FILE" 2>/dev/null)" || qpdf_status=$?
    fi
    if [[ $qpdf_status -eq 124 ]]; then
      add_warning "qpdf timed out; skipped encryption probe"
    elif [[ $qpdf_status -eq 0 ]]; then
      if echo "$qpdf_out" | grep -qi 'not encrypted'; then
        :
      elif echo "$qpdf_out" | grep -qiE 'encrypted|^R =|^P ='; then
        add_error "PDF appears encrypted; accessible/archive submissions should not require passwords"
      fi
    else
      add_warning "qpdf could not inspect encryption status"
    fi
  else
    add_info "qpdf not available; skipped encryption probe"
  fi
}

resolve_target
check_latex_source
check_pdf_file

if [[ "$JSON" == true ]]; then
  python3 - \
    "${#ERRORS[@]}" "${#WARNINGS[@]}" "${#INFO[@]}" \
    "$(json_array "${ERRORS[@]}")" \
    "$(json_array "${WARNINGS[@]}")" \
    "$(json_array "${INFO[@]}")" <<'PY'
import json
import sys
print(json.dumps({
    "errors": int(sys.argv[1]),
    "warnings": int(sys.argv[2]),
    "info_count": int(sys.argv[3]),
    "error_messages": json.loads(sys.argv[4]),
    "warning_messages": json.loads(sys.argv[5]),
    "info": json.loads(sys.argv[6]),
}, indent=2))
PY
else
  echo "Accessibility check"
  echo "Errors: ${#ERRORS[@]}"
  for e in "${ERRORS[@]}"; do echo "  ERROR: $e"; done
  echo "Warnings: ${#WARNINGS[@]}"
  for w in "${WARNINGS[@]}"; do echo "  WARN: $w"; done
  echo "Info: ${#INFO[@]}"
  for i in "${INFO[@]}"; do echo "  INFO: $i"; done
fi

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  exit 1
fi
if [[ "$STRICT" == true && ${#WARNINGS[@]} -gt 0 ]]; then
  exit 1
fi
exit 0
