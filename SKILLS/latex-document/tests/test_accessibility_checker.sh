#!/usr/bin/env bash
# test_accessibility_checker.sh - Test accessibility checker workflow

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CHECK_SCRIPT="${SKILL_DIR}/scripts/check_accessibility.sh"
TEMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

ACCESSIBLE_TEX="${TEMP_DIR}/accessible.tex"
cat > "$ACCESSIBLE_TEX" <<'EOF'
\documentclass{article}
\usepackage[a-2b]{pdfx}
\usepackage{graphicx}
\title{Accessible Report}
\author{Test Author}
\begin{document}
\maketitle
\section{Introduction}
\begin{figure}
\includegraphics{figure.png}
\caption{Architecture diagram. Description: a simple labeled flow.}
\end{figure}
See \url{https://example.com}.
\end{document}
EOF

bash "$CHECK_SCRIPT" "$ACCESSIBLE_TEX" --strict >"$TEMP_DIR/accessible.out"
bash "$CHECK_SCRIPT" "$ACCESSIBLE_TEX" --json >"$TEMP_DIR/accessible.json"
grep -q '"errors": 0' "$TEMP_DIR/accessible.json" || fail "accessible tex should have zero errors"

HYPERSETUP_TEX="${TEMP_DIR}/hypersetup-metadata.tex"
cat > "$HYPERSETUP_TEX" <<'EOF'
\documentclass{article}
\usepackage{hyperref}
\hypersetup{pdftitle={Metadata Title}, pdfauthor={Metadata Author}}
\begin{document}
Metadata only.
\end{document}
EOF
bash "$CHECK_SCRIPT" "$HYPERSETUP_TEX" >"$TEMP_DIR/hypersetup.out"
! grep -q "missing document title" "$TEMP_DIR/hypersetup.out" || fail "pdftitle metadata should satisfy title"
! grep -q "missing document author" "$TEMP_DIR/hypersetup.out" || fail "pdfauthor metadata should satisfy author"

XMP_DIR="${TEMP_DIR}/xmp-project"
mkdir -p "$XMP_DIR"
cat > "$XMP_DIR/main.tex" <<'EOF'
\documentclass{article}
\usepackage[a-2b]{pdfx}
\begin{document}
XMP metadata.
\end{document}
EOF
cat > "$XMP_DIR/main.xmpdata" <<'EOF'
\Title{XMP Title}
\Author{XMP Author}
EOF
bash "$CHECK_SCRIPT" "$XMP_DIR/main.tex" --strict >"$TEMP_DIR/xmp.out" || fail "xmpdata metadata should satisfy strict mode"

MIXED_URL_TEX="${TEMP_DIR}/mixed-url.tex"
cat > "$MIXED_URL_TEX" <<'EOF'
\documentclass{article}
\usepackage[a-2b]{pdfx}
\title{Mixed URL}
\author{Test Author}
\begin{document}
See \url{https://wrapped.example} and https://raw.example.
\end{document}
EOF
bash "$CHECK_SCRIPT" "$MIXED_URL_TEX" >"$TEMP_DIR/mixed-url.out"
grep -q "raw URLs" "$TEMP_DIR/mixed-url.out" || fail "mixed same-line raw URL not detected"

INACCESSIBLE_TEX="${TEMP_DIR}/inaccessible.tex"
cat > "$INACCESSIBLE_TEX" <<'EOF'
\documentclass{article}
\usepackage{graphicx}
\begin{document}
\includegraphics{figure.png}
Visit https://example.com directly.
\end{document}
EOF

bash "$CHECK_SCRIPT" "$INACCESSIBLE_TEX" >"$TEMP_DIR/inaccessible.out"
if bash "$CHECK_SCRIPT" "$INACCESSIBLE_TEX" --strict >"$TEMP_DIR/inaccessible_strict.out" 2>"$TEMP_DIR/inaccessible_strict.err"; then
  fail "strict mode should fail when warnings exist"
fi
grep -q "missing document title" "$TEMP_DIR/inaccessible.out" || fail "missing title warning not reported"
grep -q "neither hyperref nor pdfx" "$TEMP_DIR/inaccessible.out" || fail "missing hyperref/pdfx warning not reported"
grep -q "raw URLs" "$TEMP_DIR/inaccessible.out" || fail "raw URL warning not reported"

PROJECT_DIR="${TEMP_DIR}/project"
mkdir -p "$PROJECT_DIR/outputs" "$PROJECT_DIR/content"
cat > "$PROJECT_DIR/document.yaml" <<'EOF'
title: "Project Report"
author: "Test Author"
EOF
cat > "$PROJECT_DIR/main.tex" <<'EOF'
\documentclass{article}
\usepackage{hyperref}
\begin{document}
\input {content/body}
\end{document}
EOF
cat > "$PROJECT_DIR/content/body.tex" <<'EOF'
Project body with https://example.com raw URL in included content.
EOF
printf 'not a pdf\n' > "$PROJECT_DIR/outputs/main.pdf"
if bash "$CHECK_SCRIPT" "$PROJECT_DIR" >"$TEMP_DIR/project.out" 2>"$TEMP_DIR/project.err"; then
  fail "invalid PDF header should fail"
fi
grep -q "valid %PDF- header" "$TEMP_DIR/project.out" || fail "invalid PDF header not reported"
grep -q "raw URLs" "$TEMP_DIR/project.out" || fail "included content raw URL not detected"

FAKE_BIN="${TEMP_DIR}/fake-bin"
mkdir -p "$FAKE_BIN"
cat > "$FAKE_BIN/qpdf" <<'EOF'
#!/usr/bin/env bash
echo "File is not encrypted"
EOF
chmod +x "$FAKE_BIN/qpdf"
PDF_ONLY="${TEMP_DIR}/standalone.pdf"
printf '%%PDF- fake\n' > "$PDF_ONLY"
PATH="$FAKE_BIN:$PATH" bash "$CHECK_SCRIPT" "$PDF_ONLY" --json >"$TEMP_DIR/pdf.json"
grep -q '"errors": 0' "$TEMP_DIR/pdf.json" || fail "valid unencrypted PDF header should pass"

echo "Accessibility checker tests passed"
