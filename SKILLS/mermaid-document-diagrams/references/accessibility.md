<!-- markdownlint-disable MD013 -->

# Mermaid Diagram Accessibility

Use this checklist before delivering SVG/PNG diagrams for documents.

## Required checks

| Area | Rule | Fix |
| --- | --- | --- |
| Purpose | Diagram has a clear title or surrounding sentence | Add a document caption or heading |
| Alt text | Every embedded image has meaningful alt text | Describe the takeaway, not every node |
| Contrast | Text and edges are readable on the target background | Use high-contrast theme variables or white PNG background |
| Text size | Labels remain readable at final document width | Shorten labels, split lines with `<br/>`, or export wider PNG |
| Color meaning | Color is not the only carrier of meaning | Add labels, icons, grouping, or edge text |
| Complexity | Dense diagrams are navigable | Split into smaller diagrams or group with `subgraph` |
| Format | Output matches target accessibility needs | Prefer SVG for scalable docs; provide PNG fallback when needed |

## Alt text patterns

Markdown:

```markdown
![Authentication sequence from login request to JWT response](auth-flow.svg)
```

HTML:

```html
<img src="auth-flow.svg" alt="Authentication sequence from login request to JWT response">
```

LaTeX caption:

```tex
\caption{Authentication sequence from login request to JWT response.}
```

## Delivery rule

Return an embed snippet with alt text whenever you generate a diagram for a document.
If the diagram is too complex to describe in one sentence, suggest splitting it.
