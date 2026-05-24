# Complexity Scale

Choose the lightest structure that protects dependency direction and testability.

## Level 0 — Simple Script or CRUD

Use when there is no meaningful business rule and the code is short-lived or low-risk.

- Keep it simple.
- Do not create Domain entities, mediator, repositories, or events.
- Still avoid scattering raw external calls everywhere.

## Level 1 — Use-Case Boundary

Use when a workflow matters: login, checkout, submit form, create order, import file.

- Add explicit use cases/application services.
- Define ports for external dependencies.
- Keep controllers/components thin.
- Add use-case tests with fake ports.

## Level 2 — Domain Model

Use when business rules, invariants, state transitions, or ubiquitous language matter.

- Add entities/value objects/domain services where behavior belongs to the business.
- Protect invariants inside Domain.
- Use repositories only for aggregate persistence needs.
- Keep DTOs and persistence models outside Domain.

## Level 3 — CQRS / Events / Advanced Patterns

Use only when complexity justifies it: separate read/write models, async side effects, auditability, integrations, scale, or team boundaries.

- CQRS is optional; commands and queries may simply be separate functions/classes.
- Domain events are for meaningful side effects, not logging everything.
- Specifications are useful for reusable domain queries, not as a default wrapper.
- Mediators are dispatch tools, not architecture by themselves.

## Rule

If a pattern does not reduce coupling, clarify intent, improve testability, or handle real complexity, remove it.
