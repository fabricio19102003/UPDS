#!/usr/bin/env bash
# init_document_project.sh - Create a reproducible LaTeX document project scaffold

set -euo pipefail

usage() {
  cat <<'EOF'
init_document_project.sh - Create a LaTeX document project scaffold

Usage:
  init_document_project.sh <project-dir> [OPTIONS]

Options:
  --title TEXT          Document title (default: New Document)
  --author TEXT         Document author (default: Author Name)
  --organization TEXT   Organization name (default: Organization)
  --profile NAME        Document profile label (default: report)
  --force               Allow non-empty target only when scaffold paths do not collide
  -h, --help            Show this help

Creates:
  document.yaml, main.tex, content/, figures/, data/, outputs/, build/
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCAFFOLD_DIR="${SKILL_DIR}/assets/scaffolds/document-project"

PROJECT_DIR=""
TITLE="New Document"
AUTHOR="Author Name"
ORGANIZATION="Organization"
PROFILE="report"
FORCE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --author) AUTHOR="$2"; shift 2 ;;
    --organization) ORGANIZATION="$2"; shift 2 ;;
    --profile) PROFILE="$2"; shift 2 ;;
    --force) FORCE=true; shift ;;
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

if [[ ! -d "$SCAFFOLD_DIR" ]]; then
  echo "Error: scaffold not found: $SCAFFOLD_DIR" >&2
  exit 1
fi

mkdir -p "$PROJECT_DIR"

if find "$PROJECT_DIR" -mindepth 1 -maxdepth 1 | grep -q .; then
  if [[ "$FORCE" != true ]]; then
    echo "Error: target directory is not empty: $PROJECT_DIR" >&2
    echo "Use --force only when scaffold files do not collide with existing files." >&2
    exit 1
  fi

  while IFS= read -r -d '' scaffold_path; do
    rel_path="${scaffold_path#${SCAFFOLD_DIR}/}"
    if [[ -e "${PROJECT_DIR}/${rel_path}" ]]; then
      echo "Error: refusing to overwrite existing path: ${PROJECT_DIR}/${rel_path}" >&2
      exit 1
    fi
  done < <(find "$SCAFFOLD_DIR" -mindepth 1 -print0)
fi

cp -R "${SCAFFOLD_DIR}/." "$PROJECT_DIR/"

python3 - "$PROJECT_DIR" "$TITLE" "$AUTHOR" "$ORGANIZATION" "$PROFILE" <<'PY'
from pathlib import Path
import json
import re
import sys

root = Path(sys.argv[1])
title, author, org, profile = sys.argv[2:6]

LATEX_REPLACEMENTS = {
    "\\": r"\textbackslash{}",
    "&": r"\&",
    "%": r"\%",
    "$": r"\$",
    "#": r"\#",
    "_": r"\_",
    "{": r"\{",
    "}": r"\}",
    "~": r"\textasciitilde{}",
    "^": r"\textasciicircum{}",
}


def latex_escape(value: str) -> str:
    return "".join(LATEX_REPLACEMENTS.get(ch, ch) for ch in value)


def yaml_quote(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)

# YAML: JSON strings are valid YAML scalars and safely handle quotes/backslashes.
yaml_path = root / "document.yaml"
yaml_text = yaml_path.read_text(encoding="utf-8")
yaml_text = re.sub(r'^title: .*$', f'title: {yaml_quote(title)}', yaml_text, flags=re.M)
yaml_text = re.sub(r'^author: .*$', f'author: {yaml_quote(author)}', yaml_text, flags=re.M)
yaml_text = re.sub(r'^organization: .*$', f'organization: {yaml_quote(org)}', yaml_text, flags=re.M)
yaml_text = re.sub(r'^profile: .*$', f'profile: {yaml_quote(profile)}', yaml_text, flags=re.M)
yaml_path.write_text(yaml_text, encoding="utf-8")

# LaTeX: escape user-provided metadata before inserting into title fields.
tex_path = root / "main.tex"
tex_text = tex_path.read_text(encoding="utf-8")
tex_text = tex_text.replace("New Document", latex_escape(title))
tex_text = tex_text.replace("Optional subtitle", "")
tex_text = tex_text.replace("Author Name", latex_escape(author))
tex_text = tex_text.replace("Organization", latex_escape(org))
tex_path.write_text(tex_text, encoding="utf-8")
PY

cat <<EOF
Created document project: $PROJECT_DIR

Next steps:
  bash "${SCRIPT_DIR}/check_document_project.sh" "$PROJECT_DIR"
  bash "${SCRIPT_DIR}/build_document_project.sh" "$PROJECT_DIR" --preview
EOF
