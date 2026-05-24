# Review Mode

Use this report format when asked to audit architecture.

## Summary

- Verdict: `Pass`, `Pass with warnings`, or `Fail`.
- Architecture shape observed.
- Biggest dependency risk.

Before judging folder names, inspect imports, module references, dependency graph, or architecture tests.

## Findings

### Critical

Use for violations that break Clean Architecture guarantees:

- Domain/Application imports framework, ORM, HTTP client, UI library, store, browser API, SDK, or concrete adapter.
- Business rules live in controllers, endpoints, components, hooks, pages, resolvers, or jobs.
- External DTOs/ORM records are used as domain entities.
- Use cases cannot be tested without real infrastructure.

### Warning

Use for design erosion risks:

- Ports named after vendors or technology instead of capability.
- Mapping mixed into use cases without a clear boundary reason.
- Validation duplicated across layers without separation of input shape vs domain invariant.
- Generic repositories, mediator, CQRS, events, or specifications added without clear need.

### Suggestion

Use for improvements that increase clarity or maintainability:

- Rename use case to business intention.
- Add mapper/presenter for clearer boundary translation.
- Add architecture import test/lint rule.
- Split a fat service into use case + adapter.

### Good Practice

Call out what should be preserved:

- Explicit use cases.
- Thin delivery adapters.
- Ports defined by inner needs.
- Adapters isolated by technology.
- Use-case tests with fakes and adapter integration tests.

## Output Template

```markdown
## Verdict
<Pass | Pass with warnings | Fail>

## Architecture Map
<Observed layers and dependency direction>

## Critical
- [file/path] Finding — why it breaks architecture — recommended fix

## Warning
- [file/path] Finding — risk — recommended fix

## Suggestion
- [file/path] Improvement — expected benefit

## Good Practice
- [file/path] Practice worth preserving

## Next Steps
1. <highest leverage action>
2. <test or rule to prevent regression>
```
