# Research Sources

Use these sources for patterns and evaluation criteria. Copy structure and reasoning, not brand aesthetics or stack-specific APIs.

## Design Systems and Component Documentation

- `carbon-design-system/carbon` and `carbon-website`: component usage, anatomy, states, motion, dashboards, data visualization, and do/don't examples. Do not copy IBM visual identity as universal.
- `uswds/uswds` and `uswds/uswds-site`: tokens, accessibility status, component guidance, responsive QA, and government-grade forms. Do not copy government styling by default.
- `alphagov/govuk-design-system` and `alphagov/govuk-frontend`: plain-language forms, error summaries, progressive enhancement, and assistive technology discipline. Do not copy GOV.UK austerity unless context fits.
- `primer/react` and `primer/design`: component proposals, empty/loading states, navigation, data visualization, and product-system reasoning. Do not copy GitHub-specific patterns blindly.
- `salesforce-ux/design-system`, `microsoft/fluentui`, `patternfly/patternfly`, `pinterest/gestalt`: useful for tokens, theming, component anatomy, visual regression, and do/don't documentation. Do not inherit their enterprise aesthetics by default.

## Headless and Behavior Primitives

- `radix-ui/primitives`, `mui/base-ui`, `adobe/react-spectrum`, `chakra-ui/ark`, `tailwindlabs/headlessui`: useful for keyboard behavior, ARIA patterns, focus management, state attributes, headless composition, and cross-framework thinking. They solve behavior, not visual identity.
- WAI-ARIA APG (`w3c/aria-practices`): source of truth for interactive component roles, keyboard behavior, states, and focus expectations.

## Accessibility and QA

- `dequelabs/axe-core`, `pa11y/pa11y-ci`, `NickColley/jest-axe`, `testing-library/jest-dom`, `microsoft/accessibility-insights-web`, and Storybook a11y are useful for checks. Automation complements manual review; it does not prove full accessibility.

## Visual Craft and Data Visualization

- `observablehq/plot`: chart accessibility, scales, legends, axes, tips, and before/after examples.
- `airbnb/visx`: composable chart construction and theme examples; demos are not final product design.
- `motiondivision/motion`: implementation reference for motion, layout animation, gestures, and reduced motion.
- `argyleink/open-props`: token vocabulary for easing, shadows, sizes, colors, and gradients; do not use it as a bag of random effects.
