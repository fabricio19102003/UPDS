---
name: mermaid-document-diagrams
description: "Trigger: Mermaid diagrams, export diagram as SVG or PNG, architecture diagram, flowchart, sequence diagram, state machine, ER diagram, diagrams for docs. Generate validated Mermaid source and render document-ready SVG/PNG assets."
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## Activation Contract

Use this skill when the user wants Mermaid diagrams for Markdown, READMEs, reports, specs, slides, or other documents, especially when they need `.mmd` source plus SVG/PNG output.

Do not use it for pixel-perfect drawings, freehand sketches, branded icon-heavy canvases, or strict UML notation; route those to draw.io/Excalidraw/PlantUML-style tooling instead.

## Hard Rules

- Keep the `.mmd` source as the source of truth and commit/store it next to rendered assets.
- Validate before every export; never hand back an untested SVG/PNG.
- Prefer local `mmdc` for quality/offline work; fall back to Kroki when Node/Chrome/Puppeteer is unavailable.
- For documents, produce SVG by default and PNG when the target cannot embed SVG or needs previews.
- Use readable labels, explicit participants, quoted labels with special characters, and subgraphs for dense systems.
- Preserve user terminology; simplify visual density, not domain meaning.

## Decision Gates

| Situation | Action |
| --- | --- |
| User provides Mermaid code | Save it as `.mmd`, validate, then export |
| User provides natural language | Pick the smallest fitting diagram type, write `.mmd`, validate, export |
| Architecture/system with 3+ components | Prefer `flowchart`; use `architecture-beta` only after backend compatibility is confirmed |
| API/message flow | Use `sequenceDiagram` with declared participants |
| Database/domain model | Use `erDiagram` or `classDiagram` |
| State/lifecycle | Use `stateDiagram-v2` |
| Large or cramped render | Change direction, split into subgraphs, shorten labels, re-export |
| Local export fails due Chrome/Puppeteer | Treat as environment failure; use Kroki, do not rewrite valid Mermaid |

## Execution Steps

1. Ask for missing target document, output directory, desired formats, and theme only when those choices affect the result.
2. Create a stable basename such as `docs/diagrams/auth-flow.mmd`.
3. Draft from `assets/templates/` or the references below.
4. Validate locally when possible:

   ```bash
   mmdc -i diagram.mmd -o /tmp/mermaid-validate.png -w 1600 --backgroundColor white
   ```

5. Export with the available backend. Local `mmdc` path:

   ```bash
   mmdc -i diagram.mmd -o diagram.svg
   mmdc -i diagram.mmd -o diagram.png -w 2048 --backgroundColor white
   ```

6. If local export is unavailable, use Kroki for requested SVG/PNG formats and
   fail on HTTP errors:

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

7. Inspect the render when vision or image preview is available; fix clipping,
   low contrast, unreadable density, or wrong orientation. Limit automatic
   repair to two rounds.
8. Report exact source and output paths plus the embed snippet for the target
   document.

## Output Contract

Return:

- `.mmd` path and generated SVG/PNG paths.
- Validation/export backend used: `mmdc` or `Kroki`.
- Embed snippet, e.g. Markdown `![Alt text](path/to/diagram.svg)`.
- Any skipped format, environment issue, or remaining readability risk.
- Whether user feedback is needed for another review loop.

## References

- `assets/templates/` — starter Mermaid files by diagram type.
- `references/export-and-quality.md` — backend commands, document defaults, and
  readability fixes.
