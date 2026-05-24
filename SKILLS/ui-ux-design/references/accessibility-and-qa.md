# Accessibility and QA

## Required Interaction Behavior

- Interactive components need accessible name, role, state, keyboard behavior, and visible focus.
- Dialogs/modals move focus inside on open, trap focus while open, close with `Escape` when safe, and restore focus to the trigger.
- Menus, tabs, accordions, comboboxes, sliders, popovers, and tooltips must follow established keyboard patterns before custom styling.
- Prefer semantic HTML first. Use ARIA only when native elements cannot express the pattern.

## Forms and Errors

- Every input needs a visible label or equivalent accessible name.
- Help text and errors must be programmatically associated with the field.
- Invalid fields need detectable invalid state and clear recovery guidance.
- Multiple errors should provide an error summary or a clear path to the first error.
- Never rely on color alone for required, invalid, success, warning, or selected states.

## Responsive and Touch QA

- Check at least small mobile, tablet, and desktop widths; avoid accidental horizontal scroll.
- Touch targets should be comfortable, ideally around 44x44 CSS px or better.
- Hover-only affordances need touch and keyboard equivalents.
- Account for safe areas, virtual keyboards, long text, localization, and slow networks.

## Automated and Manual Testing

- Use tools such as axe, pa11y, Storybook a11y, or component accessibility tests when available.
- Use matchers/assertions for accessible name, focus, invalid state, and error message when the stack supports it.
- Automation is not enough: manually verify focus order, keyboard flow, reduced motion, screen-reader meaning, and UX clarity.
- JSDOM-style tests may miss color contrast and real browser focus behavior; do not treat them as complete proof.
