# Clean Architecture Review Checklist

Use this checklist when auditing an implementation or before claiming a design follows Clean Architecture.

## Dependency Direction

- [ ] Domain has no imports from UI, HTTP, DB, ORM, framework, storage, SDKs, router, or global store.
- [ ] Application/use cases depend on ports/interfaces or plain contracts, not concrete adapters.
- [ ] Infrastructure depends inward and implements ports defined by Domain/Application.
- [ ] Delivery depends inward and adapts external protocols to use-case inputs/outputs.
- [ ] Any rule break is documented with a clear tradeoff and rollback path.

## Boundary Data

- [ ] API DTOs, ORM records, generated client types, and form state are mapped at boundaries.
- [ ] Domain entities/value objects do not double as database rows or HTTP responses.
- [ ] Errors from Domain/Application are translated in Delivery, not coupled to protocol status codes.

## Use Cases

- [ ] Each non-trivial workflow has an intention-revealing use case name.
- [ ] Controllers/components/pages delegate to use cases instead of owning business rules.
- [ ] Use cases declare required ports and policies explicitly.
- [ ] Cross-cutting concerns are centralized via middleware/decorators/pipeline/wrappers.

## Frontend-Specific

- [ ] Components render, collect input, and trigger actions; they do not own business workflows.
- [ ] API/storage/router/analytics calls are hidden behind adapters.
- [ ] Store-specific types do not leak into Domain.
- [ ] UI validation is separated from domain invariants.

## Testing

- [ ] Domain invariants have unit tests when domain behavior exists.
- [ ] Use cases are tested with fake ports or functional test harnesses.
- [ ] Adapters have integration/contract tests for real external behavior.
- [ ] Delivery has API/component/e2e tests for critical user/protocol flows.
