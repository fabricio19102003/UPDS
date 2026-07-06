# Mermaid Export and Quality Reference

## Backend selection

Prefer local `mmdc` when available because it supports SVG, PNG, PDF, local themes, and offline rendering. Confirm it can actually render; `mmdc --version` alone is not enough because Puppeteer may still be missing Chrome.

```bash
mmdc --version
mmdc -i diagram.mmd -o /tmp/mermaid-check.png -w 1600 --backgroundColor white
```

If local rendering fails because `mmdc`, Puppeteer, or Chrome is missing, use Kroki for SVG/PNG. Always fail on HTTP errors and check the output is non-empty:

```bash
curl --fail-with-body -sS -X POST \
  -H "Content-Type: text/plain" \
  --data-binary @diagram.mmd \
  https://kroki.io/mermaid/svg \
  -o diagram.svg
test -s diagram.svg

curl --fail-with-body -sS -X POST \
  -H "Content-Type: text/plain" \
  --data-binary @diagram.mmd \
  https://kroki.io/mermaid/png \
  -o diagram.png
test -s diagram.png
```

Kroki does not export Mermaid PDF; use local `mmdc` for PDF.

Prefer `flowchart` for architecture diagrams unless the active Mermaid backend
supports `architecture-beta`; that syntax is newer and less portable.

## Document defaults

| Target | Preferred output | Notes |
| --- | --- | --- |
| Markdown / docs sites | SVG | Scales cleanly and keeps file size low |
| GitHub README | SVG or PNG | PNG can be safer for previews and social cards |
| PDF / slides | SVG or PNG | Use 2048px PNG when SVG is unsupported |
| Email / office docs | PNG | Most compatible |

Recommended exports:

```bash
mmdc -i diagram.mmd -o diagram.svg
mmdc -i diagram.mmd -o diagram.png -w 2048 --backgroundColor white
```

## Readability fixes

| Problem | Preferred fix |
| --- | --- |
| Too wide | Change `flowchart LR` to `flowchart TD`, or split sections |
| Too tall | Change `flowchart TD` to `flowchart LR`, or group with `subgraph` |
| Dense architecture | Use layered subgraphs by system boundary |
| Clipped/long label | Shorten text or use `<br/>` line breaks |
| Sequence order confusing | Declare participants explicitly in desired order |
| Edge spaghetti | Reorder declarations and group related nodes |
| Special chars break parse | Use quoted labels: `A["POST /login: {email}"]` |
| Low contrast | Use white background for PNG or adjust `classDef` |

## Embed snippets

Markdown:

```markdown
![Authentication flow](docs/diagrams/auth-flow.svg)
```

HTML with accessible text:

```html
<img src="docs/diagrams/auth-flow.svg" alt="Authentication flow sequence diagram">
```

LaTeX when SVG is not supported directly:

```tex
\includegraphics[width=\linewidth]{docs/diagrams/auth-flow.png}
```
