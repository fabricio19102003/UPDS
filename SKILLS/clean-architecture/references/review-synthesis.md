# Review Synthesis for This Skill

## Repositories Reviewed

- `Gentleman-Programming/Front-End-Clean-Architecture`: useful as a React organization example, but risks teaching Clean Architecture as folders. Issues found: framework/store/HTTP coupling in pages, Axios leaking into models, few pure use-case boundaries.
- `jasontaylordev/cleanarchitecture`: strong backend .NET reference with real layers, use cases, pipeline behaviours, tests, templates, and ADRs. Do not generalize MediatR, EF Core, Aspire, SPA hosting under Web, or `DbSet<T>` in Application.
- `ardalis/cleanarchitecture`: strong for Core/UseCases/Infrastructure/Web, DDD tactical patterns, ports/adapters, domain events, repo/specification tradeoffs, and pragmatic minimal mode. Do not generalize FastEndpoints, Ardalis packages, EF Core, SmartEnum, Vogen, or mandatory CQRS/mediator.
- `thombergs/buckpal`: compact Java hexagonal example with inbound/outbound ports, persistence adapters, mappers, and ArchUnit dependency tests. Do not generalize Spring annotations or ArchUnit itself.
- `cosmicpython/code`: strong Python service-layer example with repositories, unit of work, message bus, and tests with fakes. Do not force message bus/UoW into CRUD.
- `ThreeDotsLabs/wild-workouts-go-ddd-example`: strong real-world Go DDD/hexagonal example with multiple adapters and command/query separation. Do not generalize Go-specific package conventions.
- `CodelyTV/typescript-ddd-example` and `Sairyss/domain-driven-hexagon`: useful TypeScript backend references for bounded contexts, command/query handlers, repository ports, mappers, and automated dependency rules. Do not copy framework/decorator-heavy structure blindly.
- `bespoyasov/frontend-clean-architecture`, `CodelyTV/frontend-hexagonal_architecture-example`, and `xurxodev/frontend-clean-architecture`: useful frontend references showing ports, adapters, UI delegation, PLOC/presenter ideas, and testability. Watch for DTO leaks, hooks mixed with use cases, and composition inside UI.

## Adopt These Ideas

- Verify architecture by imports/dependencies, not directory names.
- Make use cases explicit and intention-revealing.
- Keep external details in adapters and map data at boundaries.
- Test according to architectural risk and boundary.
- Document deliberate rule breaks with ADR-style notes.
- Provide a minimal mode for small systems without losing dependency direction.
- Use architecture tests, lint rules, or import checks when the language/tooling supports them.
- Distinguish driving adapters (UI/API/CLI/jobs) from driven adapters (DB/API/storage/messaging).
- Prefer fakes/spies for use-case tests and real integrations for adapter tests.

## Avoid These Anti-Patterns

- “Clean Architecture” that only creates `domain/application/infrastructure` folders.
- Domain importing React, Angular, Redux, Axios, ASP.NET, Express, EF, Prisma, browser APIs, or generated API clients.
- Controllers, components, hooks, pages, or endpoints containing business rules.
- Generic repositories, mediator, CQRS, domain events, or specifications added by reflex.
- DTOs, ORM entities, generated clients, or API response types reused as domain entities.
- Frontend components instantiating API clients directly for business workflows.
