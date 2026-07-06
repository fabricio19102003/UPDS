#!/usr/bin/env bash
# test_project_scaffolding.sh - Test document project scaffold tools

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
INIT_SCRIPT="${SKILL_DIR}/scripts/init_document_project.sh"
CHECK_SCRIPT="${SKILL_DIR}/scripts/check_document_project.sh"
TEMP_DIR="$(mktemp -d)"
PROJECT_DIR="${TEMP_DIR}/sample-report"

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

bash "$INIT_SCRIPT" "$PROJECT_DIR" \
  --title 'Sample R&D "Q1" Report' \
  --author "Test Author & Co" \
  --organization "Test_Org #1"

assert_file "$PROJECT_DIR/document.yaml"
assert_file "$PROJECT_DIR/main.tex"
assert_file "$PROJECT_DIR/bibliography.bib"
assert_file "$PROJECT_DIR/content/01-introduction.tex"
assert_file "$PROJECT_DIR/content/02-body.tex"
assert_file "$PROJECT_DIR/content/03-conclusion.tex"
assert_dir "$PROJECT_DIR/figures"
assert_dir "$PROJECT_DIR/data"
assert_dir "$PROJECT_DIR/outputs"
assert_dir "$PROJECT_DIR/build"

grep -q 'Sample R&D' "$PROJECT_DIR/document.yaml" || fail "title not written to document.yaml"
grep -q 'Sample R\\&D "Q1" Report' "$PROJECT_DIR/main.tex" || fail "title not escaped in main.tex"
grep -q 'Test Author \\& Co' "$PROJECT_DIR/main.tex" || fail "author not escaped in main.tex"
grep -q 'Test\\_Org \\#1' "$PROJECT_DIR/main.tex" || fail "organization not escaped in main.tex"

printf '\n%% \\input{content/missing-commented}\n' >> "$PROJECT_DIR/main.tex"
bash "$CHECK_SCRIPT" "$PROJECT_DIR"
bash "$CHECK_SCRIPT" "$PROJECT_DIR" --json | grep -q '"errors": 0' || fail "json check did not report zero errors"

if bash "$INIT_SCRIPT" "$PROJECT_DIR" >/tmp/init_again.out 2>/tmp/init_again.err; then
  fail "init should refuse non-empty directory without --force"
fi

if bash "$INIT_SCRIPT" "$PROJECT_DIR" --force >/tmp/init_force.out 2>/tmp/init_force.err; then
  fail "init --force should refuse colliding scaffold paths"
fi

MERGE_DIR="${TEMP_DIR}/merge-target"
mkdir -p "$MERGE_DIR/existing"
touch "$MERGE_DIR/existing/file.txt"
bash "$INIT_SCRIPT" "$MERGE_DIR" --force >/tmp/init_merge.out
assert_file "$MERGE_DIR/document.yaml"
assert_file "$MERGE_DIR/existing/file.txt"

DIR_COLLISION="${TEMP_DIR}/dir-collision"
mkdir -p "$DIR_COLLISION"
touch "$DIR_COLLISION/content"
if bash "$INIT_SCRIPT" "$DIR_COLLISION" --force >/tmp/init_dir_collision.out 2>/tmp/init_dir_collision.err; then
  fail "init --force should refuse file/directory scaffold collisions"
fi

rm "$PROJECT_DIR/content/02-body.tex"
if bash "$CHECK_SCRIPT" "$PROJECT_DIR" >/tmp/check_broken.out 2>/tmp/check_broken.err; then
  fail "check should fail when included content is missing"
fi

echo "Project scaffolding tests passed"
