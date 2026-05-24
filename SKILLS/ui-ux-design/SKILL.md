---
name: ui-ux-design
description: "Trigger: UI/UX, frontend design, landing page, dashboard, UI component, form, improve visual design. Create usable, distinctive, accessible interfaces."
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## Activation Contract

Use this skill when designing, building, styling, reviewing, or improving user interfaces: pages, components, dashboards, forms, landing pages, flows, prototypes, or frontend artifacts.

Do not activate it for backend-only work, copy-only edits, or when a more specific brand/design-system skill fully controls the visual direction.

## Hard Rules

- Respect an existing design system, brand guide, component library, and product constraints before inventing a new style.
- Ask before changing brand direction or replacing an established design system.
- Choose a clear aesthetic direction before implementation: audience, tone, hierarchy, interaction feel, and what makes the interface memorable.
- Avoid generic AI UI: predictable card grids, random purple gradients, default typography, empty glassmorphism, and decoration without purpose.
- Preserve functionality, data flow, accessibility, and responsiveness while improving visuals.
- Every important state needs design: default, hover/focus, active, loading, empty, error, disabled, and success.
- Ensure readable contrast, visible focus, keyboard paths, reduced-motion safety, touch targets, and responsive layouts.
- Do not mark UI as complete until keyboard, focus, error states, responsive behavior, and reduced-motion safety are considered.
- Do not optimize beauty at the expense of usability, clarity, performance, or maintainability.

## Decision Gates

| Context | Focus | Required reference |
| --- | --- | --- |
| New UI | Establish aesthetic direction and structure | `references/design-heuristics.md` |
| Existing UI | Improve without breaking product conventions | `references/review-checklist.md` |
| Generic-looking UI | Remove AI-slop patterns | `references/anti-generic-patterns.md` |
| Specific surface | Apply page/component guidance | `references/context-playbooks.md` |
| Design system work | Tokenize decisions by role | `references/design-system-rules.md` |
| Accessibility or QA risk | Verify behavior, forms, focus, keyboard, and testing limits | `references/accessibility-and-qa.md` |
| Visual craft or data visualization | Strengthen layout, typography, motion, charts, and critique | `references/visual-craft.md` |
| External inspiration | Use curated sources without copying brand aesthetics | `references/research-sources.md` |

## Execution Steps

1. Identify user goal, audience, product context, brand constraints, and target surface.
2. Pick a visual direction with explicit rationale; if brand exists, derive from it instead of replacing it.
3. Design information hierarchy first: layout, grouping, spacing, typography scale, primary action, and scan path.
4. Apply visual language: color, type, surfaces, borders, elevation, iconography, illustration, and motion with restraint.
5. Implement interaction states, responsive behavior, accessibility basics, and performance-safe motion.
6. Review against the checklist before final output.

## Output Contract

Return:

- Visual direction and rationale.
- Files/components changed or proposed.
- Key UX decisions: hierarchy, states, responsive behavior, accessibility.
- Design-system or brand rules followed.
- Checklist results and remaining risks.

## References

- `references/design-heuristics.md` — practical UI/UX and frontend design heuristics.
- `references/anti-generic-patterns.md` — patterns to avoid and correction moves.
- `references/review-checklist.md` — pre-delivery quality checklist.
- `references/context-playbooks.md` — guidance for landing pages, dashboards, forms, components, charts, and mobile.
- `references/design-system-rules.md` — tokens, brand precedence, and component consistency.
- `references/accessibility-and-qa.md` — practical accessibility, forms, keyboard, focus, and testing guidance.
- `references/visual-craft.md` — layout, typography, motion, data visualization, and critique heuristics.
- `references/research-sources.md` — curated external repos and what to adopt or avoid.
