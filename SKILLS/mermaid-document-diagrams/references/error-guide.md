<!-- markdownlint-disable MD013 -->

# Mermaid Error Guide

Use this guide after validation fails. Fix the source cause; do not randomly rewrite the diagram.

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `Parse error` near a label | Special characters or punctuation in unquoted text | Quote the label: `A["POST /login: {email}"]` |
| Sequence arrow fails | Flowchart arrow used in `sequenceDiagram` | Use `->>` for calls and `-->>` for responses |
| Participants appear in odd order | Mermaid inferred participants from first use | Declare all `participant` lines first |
| Subgraph title fails | Spaces or punctuation in raw title | Use `subgraph "Readable title"` |
| Very small PNG | Default viewport too narrow | Export with `--width 2048` or larger |
| Valid source fails with Chrome error | Puppeteer/Chrome missing for `mmdc` | Install Chrome headless or use Kroki fallback |
| Kroki returns HTTP error | Unsupported syntax or server-side Mermaid mismatch | Validate locally or simplify newer syntax |
| `architecture-beta` fails | Backend Mermaid version is too old | Use `flowchart` with subgraphs instead |

## Repair order

1. Read the exact error line and column.
2. Fix only the smallest Mermaid syntax issue.
3. Re-run validation.
4. If validation passes but the image is unreadable, apply layout fixes.
5. Stop after two automatic visual repair rounds and ask the user.
