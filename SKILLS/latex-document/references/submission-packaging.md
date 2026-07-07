# Submission Packaging

Use submission packaging when a document is ready for review, course submission, client delivery, archive, or journal/conference handoff.

The packager creates a portable folder with the final PDF, source files, bibliography, figures/data, a manifest, and a human checklist.

## Command

```bash
bash <skill_path>/scripts/package_submission.sh ./my-report --archive
```

Common options:

```bash
# Use a custom package name
bash <skill_path>/scripts/package_submission.sh ./my-report --name final-report

# Continue even if the final PDF has not been built yet
bash <skill_path>/scripts/package_submission.sh ./my-report --allow-missing-pdf

# Include previews and other generated deliverables from outputs/
bash <skill_path>/scripts/package_submission.sh ./my-report --include-outputs

# Include build logs/auxiliary files only when explicitly needed
bash <skill_path>/scripts/package_submission.sh ./my-report --include-build
```

## Package layout

```text
submission-package/
├── final/
│   └── <package-name>.pdf
├── source/
│   ├── document.yaml
│   ├── main.tex
│   ├── bibliography.bib
│   └── content/
├── figures/
├── data/
├── manifest.txt
└── submission-checklist.md
```

When `--archive` is used and `zip` is installed, the script also creates:

```text
outputs/submission-package.zip
```

## Runtime rules

- Run `check_document_project.sh` before packaging; the packager does this automatically.
- Keep `--output-dir` inside the project `outputs/` folder (`outputs/<package-dir>`). The script refuses output paths outside `outputs/`, refuses `outputs/` itself, and refuses to replace an existing non-package directory.
- Keep `--name` filesystem-safe: letters, numbers, dot, underscore, and hyphen only. Path separators, spaces, `.` and `..` are refused.
- Do not use symlinks for packaged inputs: `document.yaml`, `main.tex`, `bibliography.bib`, final PDFs, or files inside `outputs/`, `content/`, `figures/`, `data/`, and `build/`. The packager refuses them so archives contain explicit files only.
- Build first with `build_document_project.sh` unless using `--allow-missing-pdf` for a source-only handoff.
- Keep `build/` out of submission packages unless the recipient explicitly asks for logs or auxiliary files.
- Use `--include-outputs` only when previews, rendered images, or alternate deliverables should be reviewed.
- Review `submission-checklist.md` before sending the package.

## Recommended handoff workflow

```bash
bash <skill_path>/scripts/check_document_project.sh ./my-report
bash <skill_path>/scripts/build_document_project.sh ./my-report --preview
bash <skill_path>/scripts/package_submission.sh ./my-report --name final-report --archive
```

Then inspect:

```text
./my-report/outputs/submission-package/manifest.txt
./my-report/outputs/submission-package/submission-checklist.md
./my-report/outputs/submission-package.zip
```

## What the checklist catches

The generated checklist is intentionally human-facing. It reminds the author/reviewer to confirm:

- final PDF opens correctly;
- title, author, organization, and date are correct;
- figures/tables are present and referenced;
- bibliography entries and citation keys resolve;
- no absolute local paths remain;
- source files are included;
- target venue/course/client instructions were checked.
