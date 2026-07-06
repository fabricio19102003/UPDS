#!/usr/bin/env bash
# build_document_project.sh - Build a latex-document project scaffold

set -euo pipefail

usage() {
  cat <<'EOF'
build_document_project.sh - Build a LaTeX document project scaffold

Usage:
  build_document_project.sh <project-dir> [OPTIONS]

Options:
  --preview             Generate PNG previews
  --preview-dir DIR     Preview output directory (default: <project>/outputs)
  --engine ENGINE       Force pdflatex, xelatex, or lualatex
  --scale PIXELS        Max dimension for PNG previews
  --use-latexmk         Use latexmk backend
  --pdfa                Produce PDF/A output
  --auto-fix            Use compile_latex.sh auto-fix mode
  --quiet               Suppress non-error output
  --verbose             Show detailed compiler output
  -h, --help            Show this help
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPILE_SCRIPT="${SCRIPT_DIR}/compile_latex.sh"
CHECK_SCRIPT="${SCRIPT_DIR}/check_document_project.sh"

PROJECT_DIR=""
PREVIEW=false
PREVIEW_DIR=""
PASSTHROUGH=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --preview) PREVIEW=true; shift ;;
    --preview-dir) PREVIEW_DIR="$2"; shift 2 ;;
    --engine|--scale) PASSTHROUGH+=("$1" "$2"); shift 2 ;;
    --use-latexmk|--pdfa|--auto-fix|--quiet|--verbose) PASSTHROUGH+=("$1"); shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Error: Unknown option $1" >&2; exit 1 ;;
    *) PROJECT_DIR="$1"; shift ;;
  esac
done

if [[ -z "$PROJECT_DIR" ]]; then
  echo "Error: project directory is required" >&2
  usage >&2
  exit 1
fi

PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
MAIN_TEX="${PROJECT_DIR}/main.tex"
OUTPUTS_DIR="${PROJECT_DIR}/outputs"

bash "$CHECK_SCRIPT" "$PROJECT_DIR"

mkdir -p "$OUTPUTS_DIR"

ARGS=("$MAIN_TEX" "${PASSTHROUGH[@]}")
if [[ "$PREVIEW" == true ]]; then
  ARGS+=("--preview")
  if [[ -z "$PREVIEW_DIR" ]]; then
    PREVIEW_DIR="$OUTPUTS_DIR"
  fi
  ARGS+=("--preview-dir" "$PREVIEW_DIR")
fi

bash "$COMPILE_SCRIPT" "${ARGS[@]}"

PDF_PATH="${PROJECT_DIR}/main.pdf"
if [[ -f "$PDF_PATH" ]]; then
  cp "$PDF_PATH" "${OUTPUTS_DIR}/main.pdf"
  echo "PDF: ${OUTPUTS_DIR}/main.pdf"
fi

if [[ "$PREVIEW" == true ]]; then
  echo "Previews: $PREVIEW_DIR"
fi
