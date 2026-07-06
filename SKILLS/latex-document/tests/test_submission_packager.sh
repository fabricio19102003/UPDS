#!/usr/bin/env bash
# test_submission_packager.sh - Test submission package workflow

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
INIT_SCRIPT="${SKILL_DIR}/scripts/init_document_project.sh"
PACKAGE_SCRIPT="${SKILL_DIR}/scripts/package_submission.sh"
TEMP_DIR="$(mktemp -d)"
PROJECT_DIR="${TEMP_DIR}/paper"

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_file() {
  [[ -f "$1" ]] || fail "missing file: $1"
}

assert_dir() {
  [[ -d "$1" ]] || fail "missing directory: $1"
}

bash "$INIT_SCRIPT" "$PROJECT_DIR" --title "Submission Paper" --author "Test Author" --organization "Test Org" >"$TEMP_DIR/init_submission.out"
mkdir -p "$PROJECT_DIR/outputs" "$PROJECT_DIR/figures" "$PROJECT_DIR/data"
printf 'fake pdf\n' > "$PROJECT_DIR/outputs/main.pdf"
printf 'figure\n' > "$PROJECT_DIR/figures/figure-a.txt"
printf 'data\n' > "$PROJECT_DIR/data/table.csv"

printf 'preview\n' > "$PROJECT_DIR/outputs/preview-1.png"
bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --name final-paper --archive >"$TEMP_DIR/package_submission.out"

PACKAGE_DIR="$PROJECT_DIR/outputs/submission-package"
assert_dir "$PACKAGE_DIR"
assert_file "$PACKAGE_DIR/final/final-paper.pdf"
assert_file "$PACKAGE_DIR/source/main.tex"
assert_file "$PACKAGE_DIR/source/document.yaml"
assert_file "$PACKAGE_DIR/source/bibliography.bib"
assert_file "$PACKAGE_DIR/source/content/01-introduction.tex"
assert_file "$PACKAGE_DIR/figures/figure-a.txt"
assert_file "$PACKAGE_DIR/data/table.csv"
assert_file "$PACKAGE_DIR/manifest.txt"
assert_file "$PACKAGE_DIR/submission-checklist.md"

grep -q "PDF included: true" "$PACKAGE_DIR/manifest.txt" || fail "manifest did not record PDF"
grep -q "final/final-paper.pdf" "$PACKAGE_DIR/submission-checklist.md" || fail "checklist did not reference final PDF"

if command -v zip >/dev/null 2>&1; then
  assert_file "$PROJECT_DIR/outputs/submission-package.zip"
  if command -v unzip >/dev/null 2>&1; then
    unzip -l "$PROJECT_DIR/outputs/submission-package.zip" | grep -q 'submission-package/final/final-paper.pdf' || fail "archive missing final PDF"
    unzip -l "$PROJECT_DIR/outputs/submission-package.zip" | grep -q 'submission-package/source/main.tex' || fail "archive missing source main.tex"
  fi
fi

if ln -s "$TEMP_DIR" "$PROJECT_DIR/outputs/outside-link" 2>/dev/null; then
  if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$PROJECT_DIR/outputs/symlink-test" >"$TEMP_DIR/package_symlink.out" 2>"$TEMP_DIR/package_symlink.err"; then
    fail "packager should refuse symlinks under outputs"
  fi
  rm -f "$PROJECT_DIR/outputs/outside-link"
fi

if ln -s "$TEMP_DIR/external-main.tex" "$PROJECT_DIR/main-symlink.tex" 2>/dev/null; then
  mv "$PROJECT_DIR/main.tex" "$PROJECT_DIR/main-real.tex"
  mv "$PROJECT_DIR/main-symlink.tex" "$PROJECT_DIR/main.tex"
  if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$PROJECT_DIR/outputs/root-symlink-test" >"$TEMP_DIR/package_root_symlink.out" 2>"$TEMP_DIR/package_root_symlink.err"; then
    fail "packager should refuse root source symlinks"
  fi
  rm -f "$PROJECT_DIR/main.tex"
  mv "$PROJECT_DIR/main-real.tex" "$PROJECT_DIR/main.tex"
fi

if ln -s "$TEMP_DIR/external-figure.txt" "$PROJECT_DIR/figures/external-figure.txt" 2>/dev/null; then
  if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$PROJECT_DIR/outputs/input-symlink-test" >"$TEMP_DIR/package_input_symlink.out" 2>"$TEMP_DIR/package_input_symlink.err"; then
    fail "packager should refuse symlinks in included directories"
  fi
  rm -f "$PROJECT_DIR/figures/external-figure.txt"
fi

CUSTOM_PACKAGE="$PROJECT_DIR/outputs/handoff"
bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$CUSTOM_PACKAGE" --include-outputs --quiet
assert_file "$CUSTOM_PACKAGE/final/paper.pdf"
assert_file "$CUSTOM_PACKAGE/outputs/preview-1.png"
[[ ! -e "$CUSTOM_PACKAGE/outputs/handoff" ]] || fail "custom package recursively copied itself"

if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --name "../../../escape" >"$TEMP_DIR/package_bad_name.out" 2>"$TEMP_DIR/package_bad_name.err"; then
  fail "packager should refuse unsafe package names"
fi
[[ ! -e "$PROJECT_DIR/escape.pdf" ]] || fail "unsafe package name should not write outside final directory"

if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$PROJECT_DIR" >"$TEMP_DIR/package_unsafe.out" 2>"$TEMP_DIR/package_unsafe.err"; then
  fail "packager should refuse project root as output dir"
fi

if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$PROJECT_DIR/figures" >"$TEMP_DIR/package_unsafe_figures.out" 2>"$TEMP_DIR/package_unsafe_figures.err"; then
  fail "packager should refuse project asset directories as output dir"
fi

if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$PROJECT_DIR/figures/package" >"$TEMP_DIR/package_nested_asset.out" 2>"$TEMP_DIR/package_nested_asset.err"; then
  fail "packager should refuse nested asset directories as output dir"
fi
[[ ! -e "$PROJECT_DIR/figures/package" ]] || fail "unsafe nested asset output dir should not be created"

TRAVERSAL_UNSAFE="$PROJECT_DIR/outputs/../figures/package"
if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$TRAVERSAL_UNSAFE" >"$TEMP_DIR/package_traversal.out" 2>"$TEMP_DIR/package_traversal.err"; then
  fail "packager should refuse traversal out of outputs"
fi
[[ ! -e "$PROJECT_DIR/figures/package" ]] || fail "traversal output dir should not be created"

OUTSIDE_UNSAFE="${TEMP_DIR}/outside/new-parent/package"
if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$OUTSIDE_UNSAFE" >"$TEMP_DIR/package_outside.out" 2>"$TEMP_DIR/package_outside.err"; then
  fail "packager should refuse output dirs outside project outputs"
fi
[[ ! -e "${TEMP_DIR}/outside" ]] || fail "unsafe outside output parent should not be created"

if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$PROJECT_DIR/outputs" >"$TEMP_DIR/package_outputs_root.out" 2>"$TEMP_DIR/package_outputs_root.err"; then
  fail "packager should refuse outputs root as output dir"
fi

mkdir -p "$PROJECT_DIR/outputs/existing-not-package"
printf 'keep\n' > "$PROJECT_DIR/outputs/existing-not-package/file.txt"
if bash "$PACKAGE_SCRIPT" "$PROJECT_DIR" --output-dir "$PROJECT_DIR/outputs/existing-not-package" >"$TEMP_DIR/package_existing.out" 2>"$TEMP_DIR/package_existing.err"; then
  fail "packager should refuse existing non-package output dir"
fi
assert_file "$PROJECT_DIR/outputs/existing-not-package/file.txt"

MISSING_PDF_PROJECT="${TEMP_DIR}/missing-pdf"
bash "$INIT_SCRIPT" "$MISSING_PDF_PROJECT" >"$TEMP_DIR/init_missing_pdf.out"
if bash "$PACKAGE_SCRIPT" "$MISSING_PDF_PROJECT" >"$TEMP_DIR/package_missing_pdf.out" 2>"$TEMP_DIR/package_missing_pdf.err"; then
  fail "packager should fail without PDF by default"
fi
bash "$PACKAGE_SCRIPT" "$MISSING_PDF_PROJECT" --allow-missing-pdf --quiet
assert_file "$MISSING_PDF_PROJECT/outputs/submission-package/manifest.txt"

echo "Submission packager tests passed"
