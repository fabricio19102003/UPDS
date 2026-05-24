# Naming and Anti-Patterns

## Naming Conventions

- Use cases: verb + business object, e.g. `CreateOrder`, `SubmitApplication`, `GetTodos`, `CompleteTodoItem`.
- Ports: name by capability, not technology, e.g. `PaymentGateway`, `UserRepository`, `SessionProvider`, `TodoQueryService`.
- Adapters: name by implementation, e.g. `StripePaymentGateway`, `PostgresUserRepository`, `HttpTodoApi`, `BrowserSessionProvider`.
- DTOs: name by boundary, e.g. `CreateOrderRequest`, `OrderResponse`, `TodoApiDto`, `LoginFormData`.
- Mappers: name the boundary crossed, e.g. `TodoApiMapper`, `OrderPersistenceMapper`, `LoginFormMapper`.
- Domain types: use business language, not storage/protocol names.

## Red Flags

- A folder named `domain` imports React, Angular, Redux, Axios, Express, ASP.NET, EF, Prisma, SQL clients, browser APIs, or generated clients.
- A controller, component, hook, page, endpoint, resolver, or route contains business decisions.
- A `Service` class does everything: validation, persistence, HTTP, mapping, transactions, and UI state.
- A use case only passes data through without policy, coordination, or boundary value.
- DTOs, ORM entities, generated client models, or form objects are reused as domain entities.
- Generic `Repository<T>` exists without aggregate language or real substitution need.
- CQRS, mediator, domain events, specifications, or shared kernels appear before the problem needs them.
- Frontend components instantiate API clients directly for business workflows.
- Tests only cover UI/API happy paths and never isolate domain or use-case behavior.

## Correction Moves

- Move framework/API/DB calls to adapters.
- Introduce a named use case when a workflow has business meaning.
- Create a port only where an external dependency crosses inward.
- Add mappers where external shapes enter or leave the system.
- Collapse ceremonial layers when they do not protect boundaries or improve tests.
