# Document Project Scaffold

This folder is a reproducible LaTeX document project.

## Build

```bash
bash <skill_path>/scripts/build_document_project.sh . --preview
```

## Check

```bash
bash <skill_path>/scripts/check_document_project.sh .
```

## Layout

- `document.yaml` — project metadata and output intent.
- `main.tex` — root LaTeX file.
- `content/` — section files included by `main.tex`.
- `figures/` — generated or imported figures.
- `data/` — CSV/JSON/source data for tables and charts.
- `outputs/` — generated PDFs and previews.
- `build/` — temporary build artifacts.
