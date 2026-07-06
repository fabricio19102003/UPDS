---
name: mermaid-document-diagrams
description: "Trigger: Mermaid diagrams, export diagram as SVG or PNG, architecture diagram, flowchart, sequence diagram, state machine, ER diagram, Gantt, mindmap, C4, journey, diagrams for docs. Generate validated Mermaid source and render document-ready SVG/PNG assets with local mmdc or Kroki fallback."
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "2.0"
---

## Activation Contract

Use this skill when the user wants Mermaid diagrams for Markdown, READMEs, reports, specs, slides, or other documents, especially when they need `.mmd` source plus SVG/PNG output.

Do not use it for pixel-perfect drawings, freehand sketches, branded icon-heavy canvases, or strict UML notation; route those to draw.io/Excalidraw/PlantUML-style tooling instead.

## Hard Rules

- Keep `.mmd` as the source of truth and store rendered assets beside it.
- Validate before every export; never hand back an untested SVG/PNG.
- Prefer `scripts/render.mjs` so backend fallback, HTTP failure checks, and output checks stay consistent.
- Prefer local `mmdc`; use Kroki only with explicit remote-export approval and no sensitive diagram data.
- Produce SVG by default for docs and PNG for previews, PDFs, slides, email, or tools that cannot embed SVG.
- Optimize for readable documents: short labels, explicit participants, high contrast, useful alt text, and subgraphs for dense systems.

## Decision Gates

| Situation | Action |
| --- | --- |
| User provides Mermaid code | Save it as `.mmd`, validate, then export |
| User provides natural language | Pick the smallest fitting diagram type, write `.mmd`, validate, export |
| Architecture/system with 3+ components | Prefer `flowchart`; use `architecture-beta` only after backend compatibility is confirmed |
| API/message flow | Use `sequenceDiagram` with declared participants |
| Database/domain model | Use `erDiagram` or `classDiagram` |
| State/lifecycle | Use `stateDiagram-v2` |
| Timeline/project plan | Use `gantt` |
| Concept map/brainstorm | Use `mindmap` |
| User experience flow | Use `journey` |
| High-level system context | Use `C4Context` after backend compatibility is confirmed |
| Multiple `.mmd` files | Use `scripts/batch.mjs` and report failures per file |
| Sensitive/private diagram and `mmdc` fails | Do not use Kroki; report setup blocker |
| Render is cramped or clipped | Change direction, split into subgraphs, shorten labels, re-export |

## Execution Steps

1. Ask only for missing choices that affect output: target document, format,
   output directory, theme, or whether remote Kroki is allowed.
2. Create a stable basename such as `docs/diagrams/auth-flow.mmd`.
3. Draft from `assets/templates/`, `assets/gallery/`,
   `assets/themes/document-themes.md`, and the references below.
4. Render one diagram with validation and local backend selection. Set
   `SKILL_DIR` to the installed skill path:

   ```bash
   SKILL_DIR=path/to/mermaid-document-diagrams
   node "$SKILL_DIR/scripts/render.mjs" \
     --input docs/diagrams/auth-flow.mmd \
     --output-dir docs/diagrams \
     --format svg,png
   ```

5. Add `--allow-remote` only when Kroki fallback is approved. Batch render a
   directory when there are multiple diagrams:

   ```bash
   node "$SKILL_DIR/scripts/batch.mjs" \
     --input-dir docs/diagrams \
     --output-dir docs/diagrams/rendered \
     --format svg,png
   ```

6. Use watch mode only during active editing sessions:

   ```bash
   node "$SKILL_DIR/scripts/watch.mjs" \
     --input-dir docs/diagrams \
     --output-dir docs/diagrams \
     --format svg,png
   ```

7. Inspect the render when image preview is available; fix clipping, low
   contrast, unreadable density, or wrong orientation. Limit automatic repair
   to two rounds.
8. Report exact source/output paths, backend used, embed snippet, skipped
   formats, and remaining readability risks.

## Output Contract

Return:

- `.mmd` path and generated SVG/PNG paths.
- Validation/export backend used: `mmdc` or `Kroki`.
- Accessible embed snippet, e.g. Markdown
  `![Authentication flow from request to token](path/to/diagram.svg)`.
- Any skipped format, environment issue, remote-export decision, sensitive-data
  constraint, or remaining readability risk.
- Whether user feedback is needed for another review loop.

## References

- `scripts/render.mjs` — validate and export one `.mmd` to SVG/PNG/PDF.
- `scripts/batch.mjs` — render a directory of `.mmd` files.
- `scripts/watch.mjs` — re-render diagrams during an editing session.
- `assets/templates/` — starter Mermaid files by diagram type.
- `assets/gallery/` — rendered example gallery with `.mmd`, SVG, and PNG.
- `assets/themes/document-themes.md` — document theme guidance and UPDS init
  block.
- `references/export-and-quality.md` — backend commands, document defaults, and
  readability fixes.
- `references/error-guide.md` — common validation/rendering failures and repair
  order.
- `references/accessibility.md` — alt text, contrast, format, and complexity
  checklist.
- `references/ci-integration.md` — GitHub Actions validation guidance.
