# Design System Rules

## Precedence

1. Existing product design system or brand guide.
2. Existing component library conventions.
3. Accessibility and platform constraints.
4. New aesthetic direction.

Never override a real brand/system with a generic visual trend unless the user explicitly asks for redesign exploration.

## Token Model

Use tokens by role:

- Primitive: raw values (`blue-900`, `16px`, `0.75rem`, font family).
- Semantic: meaning (`color-primary`, `surface-muted`, `text-danger`).
- Component: usage (`button-primary-bg`, `card-radius`, `input-border-focus`).

Prefer semantic/component tokens in UI code. Raw values belong in token definitions, not scattered across components.

## Component Consistency

- Reuse existing components before creating new ones.
- New variants need a real use case and documented states.
- Do not introduce one-off spacing, colors, shadows, or motion curves without system reason.
- Align icon style, corner radius, elevation, density, and typography across the surface.

## When No System Exists

Create a minimal system:

- type scale;
- spacing scale;
- semantic colors;
- surface/elevation rules;
- button/input/card states;
- responsive breakpoints;
- motion principles.

Keep it small. A lightweight system beats random polish.
