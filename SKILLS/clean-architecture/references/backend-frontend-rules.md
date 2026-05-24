# Clean Architecture Backend and Frontend Rules

## Universal Layer Roles

| Role | Owns | Must not know |
| --- | --- | --- |
| Domain | Entities, value objects, invariants, domain errors/events | UI, HTTP, DB, ORM, framework, storage, SDKs |
| Application / Use Cases | Intentional workflows, ports, policies, transactions | Concrete DB/API clients, components, controllers |
| Infrastructure / Adapters | DB, API clients, storage, identity, messaging, external SDKs | UI decisions and business policy ownership |
| Delivery | HTTP, GraphQL, CLI, jobs, pages, components, forms, routes | Persistence details and domain rule implementation |

## Backend Conventions

- Controllers/endpoints should parse protocol input, call one use case, and translate output/errors.
- Use cases should depend on interfaces/ports, not ORM sessions, generated clients, or framework request objects.
- Commands can load and persist aggregates; queries may use optimized read models or query services when justified.
- Domain invariants belong in domain objects; request shape validation belongs at delivery/application boundaries.
- Infrastructure owns migrations, ORM configuration, concrete repositories, external services, and message brokers.

## Frontend Conventions

- Components/pages render state, collect input, and trigger application actions; they do not own business workflows.
- Frontend use cases/application services coordinate flows such as login, checkout, onboarding, search, or submission.
- Adapters wrap `fetch`, Axios, generated clients, local/session storage, IndexedDB, browser APIs, router APIs, and analytics SDKs.
- Stores are delivery/application state mechanisms, not domain models. Do not let Redux/Zustand/Signals/RxJS types leak into Domain.
- API DTOs and form state are mapped before they become domain/application models.

## Testing Matrix

| Boundary | Test style | Example assertion |
| --- | --- | --- |
| Domain | Unit | Invariant rejects invalid state |
| Application | Use-case unit/functional | Given ports return X, use case returns Y and calls expected ports |
| Infrastructure | Integration/contract | Adapter maps external API/DB behavior correctly |
| Delivery | E2E/component/API | User/protocol flow reaches expected visible result |

## Pragmatism Rules

- A single-project/module structure is acceptable when import rules still protect boundaries.
- Skip domain objects when there are no domain rules; use a direct use case with clear ports instead.
- Prefer concrete, named ports over generic repositories unless the aggregate language justifies a repository.
- Add CQRS, mediator, domain events, specifications, or shared kernels only when complexity demands them.
