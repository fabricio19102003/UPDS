---
name: clean-architecture
description: "Trigger: Clean Architecture, hexagonal, ports adapters, layered architecture, use cases. Apply stack-agnostic dependency rules for backend and frontend."
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## Activation Contract

Use this skill when designing, implementing, or reviewing code that claims Clean Architecture, Hexagonal Architecture, Ports and Adapters, layered use cases, or framework-independent application boundaries.

Do not activate it for trivial cosmetic edits, copy-only changes, or small CRUD code with no architectural boundary decision.

## Hard Rules

- Treat Clean Architecture as **dependency direction**, not folder naming.
- Inner layers MUST NOT import frameworks, UI libraries, HTTP clients, ORMs, databases, global stores, SDKs, routers, or platform APIs.
- Domain models express business concepts, invariants, value objects, domain events, and domain services only when the behavior belongs to the business.
- Application/use cases express user/business intentions with explicit input, output, validation/authorization policy, transaction needs, and required ports.
- Infrastructure implements ports: persistence, HTTP/API clients, storage, identity, messaging, telemetry, file system, browser/native APIs.
- Delivery adapts external protocols: controllers, endpoints, GraphQL resolvers, CLI commands, jobs, pages, components, routes, forms.
- DTOs, API responses, ORM records, generated clients, and UI form state MUST be mapped at boundaries before entering Domain.
- Any inner-layer dependency on a framework requires an explicit ADR-style justification.
- Do not introduce CQRS, mediator, repository, specification, domain events, or generic interfaces unless they solve a current problem.

## Decision Gates

| Context | Default shape | Guardrail |
| --- | --- | --- |
| Backend/API | Delivery -> Application -> Domain; Infrastructure implements ports | Controllers/endpoints delegate; no business logic in HTTP layer |
| Frontend | UI -> Application/use cases -> Domain; adapters wrap API/storage/router/store | Components render/orchestrate UI; no raw HTTP or business rules in components |
| Full-stack | Separate external contracts from internal models on both sides | Do not share persistence/API DTOs as domain entities |
| Small app | Minimal modules are acceptable | Still enforce dependency direction with imports, tests, or lint rules |

## Execution Steps

1. Identify the business capability and name use cases by intention, e.g. `CreateOrder`, `GetTodos`, `SubmitVote`.
2. Define domain concepts first only when real business rules exist; avoid anemic ceremony for pure CRUD.
3. Define ports needed by the use case from the inside out.
4. Place adapters outside the use case and map external data into internal models.
5. Keep cross-cutting concerns as middleware, decorators, pipeline behaviours, interceptors, or wrappers: validation, authorization, logging, transactions, retries.
6. Add tests by boundary: Domain unit, Application/use-case unit or functional, Infrastructure integration, Delivery/e2e.
7. During review, check imports before judging folder names.

## Output Contract

When applying or reviewing, report:

- Layer map and dependency direction.
- Use cases and ports introduced or changed.
- Boundary mappings and external details kept outside.
- Import/dependency violations found or confirmed absent.
- Tests added or missing by architectural boundary.
- Any pragmatic exception and its justification.
- Overengineering risks removed or intentionally accepted.

## References

- `references/backend-frontend-rules.md` — stack-agnostic backend/frontend conventions.
- `references/review-checklist.md` — audit checklist for dependency and boundary violations.
- `references/complexity-scale.md` — choose minimal, use-case, DDD, or event-driven structure.
- `references/naming-and-antipatterns.md` — naming conventions and red flags.
- `references/backend-example.md` — minimal backend flow with use case, ports, adapter, mapper, and test.
- `references/frontend-example.md` — minimal frontend flow and bad-vs-good component example.
- `references/abstract-templates.md` — stack-agnostic templates for use cases, ports, adapters, mappers, and tests.
- `references/migration-guide.md` — migrate fat controllers/components toward Clean Architecture.
- `references/review-mode.md` — standard review report format and severity rubric.
- `references/review-synthesis.md` — lessons extracted from reviewed Clean Architecture repos.
