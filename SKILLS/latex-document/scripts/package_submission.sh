#!/usr/bin/env bash
# package_submission.sh - Create a review/submission package for a LaTeX document project

set -euo pipefail

usage() {
  cat <<'EOF'
package_submission.sh - Create a portable submission package

Usage:
  package_submission.sh <project-dir> [OPTIONS]

Options:
  --output-dir DIR       Package directory (default: <project>/outputs/submission-package)
  --name NAME            Package name used for archive/checklist headings (default: project directory name)
  --include-build        Include build/ directory when present (default: false)
  --include-outputs      Include outputs/ previews and auxiliary deliverables (default: false; PDF is always copied when found)
  --archive              Create a .zip archive next to the package directory when zip is available
  --allow-missing-pdf    Do not fail when no final PDF exists
  --quiet                Suppress non-error output
  -h, --help             Show this help

Creates:
  package directory with source/, figures/, data/, final/, manifest.txt, and submission-checklist.md
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK_SCRIPT="${SCRIPT_DIR}/check_document_project.sh"

PROJECT_DIR=""
OUTPUT_DIR=""
PACKAGE_NAME=""
INCLUDE_BUILD=false
INCLUDE_OUTPUTS=false
ARCHIVE=false
ALLOW_MISSING_PDF=false
QUIET=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    --name) PACKAGE_NAME="$2"; shift 2 ;;
    --include-build) INCLUDE_BUILD=true; shift ;;
    --include-outputs) INCLUDE_OUTPUTS=true; shift ;;
    --archive) ARCHIVE=true; shift ;;
    --allow-missing-pdf) ALLOW_MISSING_PDF=true; shift ;;
    --quiet) QUIET=true; shift ;;
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

PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd -P)"
PROJECT_BASE="$(basename "$PROJECT_DIR")"
PACKAGE_NAME="${PACKAGE_NAME:-$PROJECT_BASE}"
if [[ ! "$PACKAGE_NAME" =~ ^[A-Za-z0-9._-]+$ || "$PACKAGE_NAME" == "." || "$PACKAGE_NAME" == ".." ]]; then
  echo "Error: --name must be a safe filename using only letters, numbers, dot, underscore, and hyphen" >&2
  exit 1
fi

OUTPUT_DIR="${OUTPUT_DIR:-${PROJECT_DIR}/outputs/submission-package}"
case "$OUTPUT_DIR" in
  /*|[A-Za-z]:*) ;;
  *) OUTPUT_DIR="$(pwd)/$OUTPUT_DIR" ;;
esac
OUTPUT_DIR="${OUTPUT_DIR%/}"
case "$OUTPUT_DIR" in
  */../*|*/..)
    echo "Error: --output-dir must not contain '..' path traversal" >&2
    exit 1
    ;;
esac

if [[ "$OUTPUT_DIR" == "$PROJECT_DIR/outputs" ]]; then
  echo "Error: unsafe --output-dir would replace the outputs/ directory" >&2
  exit 1
fi

case "$OUTPUT_DIR" in
  "$PROJECT_DIR/outputs/"*)
    ;;
  *)
    echo "Error: --output-dir must be inside the project outputs/ directory: $PROJECT_DIR/outputs/<package-dir>" >&2
    exit 1
    ;;
esac

if [[ -e "$OUTPUT_DIR" && ! -f "$OUTPUT_DIR/manifest.txt" ]]; then
  echo "Error: refusing to replace existing non-package directory: $OUTPUT_DIR" >&2
  exit 1
fi

for root_input in "$PROJECT_DIR/document.yaml" "$PROJECT_DIR/main.tex" "$PROJECT_DIR/bibliography.bib" "$PROJECT_DIR/main.pdf" "$PROJECT_DIR/outputs/main.pdf"; do
  if [[ -L "$root_input" ]]; then
    echo "Error: submission inputs must not be symlinks: $root_input" >&2
    exit 1
  fi
done

if [[ -L "$PROJECT_DIR/outputs" ]] || find "$PROJECT_DIR/outputs" -type l -print -quit | grep -q .; then
  echo "Error: outputs/ must not contain symlinks for submission packaging" >&2
  exit 1
fi

for included_path in "$PROJECT_DIR/content" "$PROJECT_DIR/figures" "$PROJECT_DIR/data" "$PROJECT_DIR/build"; do
  if [[ -e "$included_path" ]] && find "$included_path" -type l -print -quit | grep -q .; then
    echo "Error: submission inputs must not contain symlinks: $included_path" >&2
    exit 1
  fi
done

bash "$CHECK_SCRIPT" "$PROJECT_DIR" >/dev/null

pdf_found=false
pdf_source=""
for pdf in "$PROJECT_DIR/outputs/main.pdf" "$PROJECT_DIR/main.pdf"; do
  if [[ -f "$pdf" ]]; then
    pdf_source="$pdf"
    pdf_found=true
    break
  fi
done

if [[ "$pdf_found" != true && "$ALLOW_MISSING_PDF" != true ]]; then
  echo "Error: final PDF not found. Build first or pass --allow-missing-pdf." >&2
  exit 1
fi

STAGING_DIR="${OUTPUT_DIR}.staging.$$"
BACKUP_DIR="${OUTPUT_DIR}.backup.$$"
rm -rf "$STAGING_DIR" "$BACKUP_DIR"
mkdir -p "$STAGING_DIR/source" "$STAGING_DIR/final"

cleanup_staging() {
  rm -rf "$STAGING_DIR"
  if [[ -d "$BACKUP_DIR" && ! -e "$OUTPUT_DIR" ]]; then
    mv "$BACKUP_DIR" "$OUTPUT_DIR" || true
  fi
}
trap cleanup_staging EXIT

copy_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -e "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp -R "$src" "$dst"
  fi
}

copy_if_exists "$PROJECT_DIR/document.yaml" "$STAGING_DIR/source/document.yaml"
copy_if_exists "$PROJECT_DIR/main.tex" "$STAGING_DIR/source/main.tex"
copy_if_exists "$PROJECT_DIR/bibliography.bib" "$STAGING_DIR/source/bibliography.bib"
copy_if_exists "$PROJECT_DIR/content" "$STAGING_DIR/source/content"
copy_if_exists "$PROJECT_DIR/figures" "$STAGING_DIR/figures"
copy_if_exists "$PROJECT_DIR/data" "$STAGING_DIR/data"

if [[ "$pdf_found" == true ]]; then
  cp "$pdf_source" "$STAGING_DIR/final/${PACKAGE_NAME}.pdf"
fi

if [[ "$INCLUDE_BUILD" == true && -d "$PROJECT_DIR/build" ]]; then
  copy_if_exists "$PROJECT_DIR/build" "$STAGING_DIR/build"
fi

if [[ "$INCLUDE_OUTPUTS" == true && -d "$PROJECT_DIR/outputs" ]]; then
  mkdir -p "$STAGING_DIR/outputs"
  while IFS= read -r -d '' output_item; do
    item_abs="$(cd "$(dirname "$output_item")" && pwd)/$(basename "$output_item")"
    case "$item_abs" in
      "$OUTPUT_DIR"|"$OUTPUT_DIR"/*|"$STAGING_DIR"|"$STAGING_DIR"/*|"${OUTPUT_DIR}.zip")
        continue
        ;;
    esac
    cp -R "$output_item" "$STAGING_DIR/outputs/"
  done < <(find "$PROJECT_DIR/outputs" -mindepth 1 -maxdepth 1 -print0)
fi

MANIFEST="$STAGING_DIR/manifest.txt"
{
  echo "Submission package: $PACKAGE_NAME"
  echo "Project: $PROJECT_DIR"
  echo "Created: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "PDF included: $pdf_found"
  echo "Include build: $INCLUDE_BUILD"
  echo "Include outputs: $INCLUDE_OUTPUTS"
  echo ""
  echo "Files:"
  (cd "$STAGING_DIR" && find . -type f | sort)
} > "$MANIFEST"

CHECKLIST="$STAGING_DIR/submission-checklist.md"
cat > "$CHECKLIST" <<EOF
# Submission Checklist: ${PACKAGE_NAME}

- [ ] Final PDF opens correctly: \`final/${PACKAGE_NAME}.pdf\`
- [ ] Title, author, organization, and date are correct
- [ ] All figures/tables are present and referenced
- [ ] Bibliography entries compile and citation keys resolve
- [ ] No absolute local paths remain in \`source/main.tex\`
- [ ] Required source files are included under \`source/\`
- [ ] Submission instructions from the target venue/course/client were checked
- [ ] Package manifest reviewed: \`manifest.txt\`
EOF

if [[ -e "$OUTPUT_DIR" ]]; then
  mv "$OUTPUT_DIR" "$BACKUP_DIR"
fi
if mv "$STAGING_DIR" "$OUTPUT_DIR"; then
  rm -rf "$BACKUP_DIR"
  trap - EXIT
else
  if [[ -d "$BACKUP_DIR" && ! -e "$OUTPUT_DIR" ]]; then
    mv "$BACKUP_DIR" "$OUTPUT_DIR" || true
  fi
  exit 1
fi

MANIFEST="$OUTPUT_DIR/manifest.txt"
CHECKLIST="$OUTPUT_DIR/submission-checklist.md"
ARCHIVE_PATH=""
if [[ "$ARCHIVE" == true ]]; then
  if command -v zip >/dev/null 2>&1; then
    ARCHIVE_PATH="${OUTPUT_DIR}.zip"
    TEMP_ARCHIVE="${ARCHIVE_PATH}.tmp.$$"
    rm -f "$TEMP_ARCHIVE"
    (cd "$(dirname "$OUTPUT_DIR")" && zip -qr "$(basename "$TEMP_ARCHIVE")" "$(basename "$OUTPUT_DIR")")
    mv "$TEMP_ARCHIVE" "$ARCHIVE_PATH"
  else
    echo "Warning: zip not found; archive skipped" >&2
  fi
fi

if [[ "$QUIET" != true ]]; then
  echo "Package: $OUTPUT_DIR"
  echo "Manifest: $MANIFEST"
  echo "Checklist: $CHECKLIST"
  if [[ -n "$ARCHIVE_PATH" ]]; then
    echo "Archive: $ARCHIVE_PATH"
  fi
fi
