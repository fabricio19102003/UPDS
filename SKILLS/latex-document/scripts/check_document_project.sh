#!/usr/bin/env bash
# check_document_project.sh - Validate a latex-document project scaffold

set -euo pipefail

usage() {
  cat <<'EOF'
check_document_project.sh - Validate a LaTeX document project scaffold

Usage:
  check_document_project.sh <project-dir> [OPTIONS]

Options:
  --json        Emit machine-readable JSON summary
  -h, --help    Show this help

Checks:
  required files/directories, main.tex include targets, content .tex syntax,
  obvious absolute paths, missing bibliography when referenced.
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATE_SCRIPT="${SCRIPT_DIR}/validate_latex.py"
PROJECT_DIR=""
JSON=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON=true; shift ;;
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
ERRORS=()
WARNINGS=()

require_file() {
  [[ -f "$PROJECT_DIR/$1" ]] || ERRORS+=("missing file: $1")
}

require_dir() {
  [[ -d "$PROJECT_DIR/$1" ]] || ERRORS+=("missing directory: $1")
}

require_file "document.yaml"
require_file "main.tex"
require_dir "content"
require_dir "figures"
require_dir "data"
require_dir "outputs"
require_dir "build"

if [[ -f "$PROJECT_DIR/main.tex" ]]; then
  while IFS= read -r include; do
    [[ -z "$include" ]] && continue
    include_path="$include"
    [[ "$include_path" == *.tex ]] || include_path="${include_path}.tex"
    [[ -f "$PROJECT_DIR/${include_path}" ]] || ERRORS+=("missing include target: ${include_path}")
  done < <(grep -vE '^[[:space:]]*%' "$PROJECT_DIR/main.tex" | grep -oE '\\input\{[^}]+\}' | sed -E 's/\\input\{([^}]+)\}/\1/')

  if grep -qE '\\bibliography\{bibliography\}|\\addbibresource\{bibliography\.bib\}' "$PROJECT_DIR/main.tex"; then
    [[ -f "$PROJECT_DIR/bibliography.bib" ]] || ERRORS+=("main.tex references bibliography but bibliography.bib is missing")
  fi

  if grep -qE '([A-Za-z]:\\|/Users/|/home/|/tmp/)' "$PROJECT_DIR/main.tex"; then
    WARNINGS+=("main.tex may contain absolute paths")
  fi
fi

if compgen -G "$PROJECT_DIR/content/*.tex" > /dev/null; then
  if [[ -f "$VALIDATE_SCRIPT" ]]; then
    validate_out="$(mktemp)"
    validate_err="$(mktemp)"
    if ! python3 "$VALIDATE_SCRIPT" "$PROJECT_DIR"/content/*.tex >"$validate_out" 2>"$validate_err"; then
      validate_msg="$(cat "$validate_err" "$validate_out" | tr '\n' ' ')"
      ERRORS+=("content validation failed: ${validate_msg}")
    fi
    rm -f "$validate_out" "$validate_err"
  fi
else
  WARNINGS+=("content directory has no .tex files")
fi

if [[ -f "$PROJECT_DIR/document.yaml" ]]; then
  for key in title author profile paths outputs; do
    grep -qE "^${key}:" "$PROJECT_DIR/document.yaml" || WARNINGS+=("document.yaml missing key: $key")
  done

  if python3 - "$PROJECT_DIR/document.yaml" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
try:
    import yaml  # type: ignore
except Exception:
    raise SystemExit(0)

yaml.safe_load(path.read_text(encoding="utf-8"))
PY
  then
    :
  else
    ERRORS+=("document.yaml is not valid YAML")
  fi
fi

if [[ "$JSON" == true ]]; then
  python3 - "$PROJECT_DIR" "${#ERRORS[@]}" "${#WARNINGS[@]}" <<'PY'
import json
import sys
print(json.dumps({
    "project": sys.argv[1],
    "errors": int(sys.argv[2]),
    "warnings": int(sys.argv[3]),
}, indent=2))
PY
else
  echo "Project: $PROJECT_DIR"
  echo "Errors: ${#ERRORS[@]}"
  for e in "${ERRORS[@]}"; do echo "  ERROR: $e"; done
  echo "Warnings: ${#WARNINGS[@]}"
  for w in "${WARNINGS[@]}"; do echo "  WARN: $w"; done
fi

[[ ${#ERRORS[@]} -eq 0 ]]
