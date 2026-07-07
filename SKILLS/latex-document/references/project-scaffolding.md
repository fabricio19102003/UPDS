# Document Project Scaffolding

Use project scaffolding when the user asks for a reusable document workspace, a report/thesis/book that will evolve over time, or a reproducible build layout.

## Commands

Create a project:

```bash
bash <skill_path>/scripts/init_document_project.sh ./my-report \
  --title "Quarterly Report" \
  --author "Author Name" \
  --organization "Organization"
```

Check project structure:

```bash
bash <skill_path>/scripts/check_document_project.sh ./my-report
```

Build PDF and PNG previews:

```bash
bash <skill_path>/scripts/build_document_project.sh ./my-report --preview
```

Build with Tectonic only for simple scaffold variants that do not require bibliography, index, or glossary passes:

```bash
bash <skill_path>/scripts/build_document_project.sh ./my-report --use-tectonic
```

The default scaffold includes `\bibliography{bibliography}`, so use the default backend or `--use-latexmk` unless that bibliography dependency is removed.

## Generated layout

```text
my-report/
├── document.yaml
├── main.tex
├── bibliography.bib
├── content/
│   ├── 01-introduction.tex
│   ├── 02-body.tex
│   └── 03-conclusion.tex
├── figures/
├── data/
├── outputs/
└── build/
```

## Runtime rules

- Keep user-authored content in `content/`.
- Keep generated or imported visuals in `figures/`.
- Keep CSV/JSON/source data in `data/`.
- Treat `document.yaml` as project metadata and output intent.
- Use `outputs/` only for generated PDFs and previews.
- Avoid absolute paths in `main.tex` so the project remains portable.
- Run `check_document_project.sh` before build or handoff.

## When not to scaffold

Do not create a project scaffold for one-off letters, tiny invoices, or a single quick PDF unless the user wants a reusable workspace.
