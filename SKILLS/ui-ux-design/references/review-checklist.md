# UI/UX Review Checklist

Use before final delivery or when auditing a UI.

## Product Fit

- [ ] The UI has a clear audience, goal, and tone.
- [ ] Existing brand/design-system rules are followed or exceptions are justified.
- [ ] Primary action and success path are obvious.
- [ ] Visual choices support the product, not generic decoration.

## Layout and Hierarchy

- [ ] Content has a clear scan path.
- [ ] Spacing, alignment, and grouping are consistent.
- [ ] Important information is not visually equal to secondary information.
- [ ] Responsive behavior is defined for small, medium, and large screens.

## Interaction States

- [ ] Default, hover/focus, active, disabled, loading, empty, error, and success states exist where relevant.
- [ ] Focus is visible and keyboard navigation is possible.
- [ ] Touch targets are large enough and not hover-dependent.
- [ ] Motion is purposeful and safe for reduced-motion users.

## Accessibility

- [ ] Text and meaningful icons have readable contrast.
- [ ] Inputs have labels and useful validation messages.
- [ ] Error messages explain recovery, not just failure.
- [ ] Layout does not rely on color alone for meaning.

## Implementation Quality

- [ ] Styling follows project conventions and component APIs.
- [ ] No unnecessary dependencies or heavy effects were added.
- [ ] The design does not break data flow, routing, or existing behavior.
- [ ] Remaining risks or assumptions are reported.
