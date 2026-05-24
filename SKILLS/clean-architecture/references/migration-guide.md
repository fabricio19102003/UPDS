# Migration Guide: Fat Controller or Component to Clean Architecture

Use this when refactoring existing code. Move behavior incrementally; do not rewrite the whole system first.

## Steps

1. **Name the intent**: identify the business workflow hidden in the controller/component, e.g. `RegisterUser`, `CheckoutCart`, `UploadDocument`.
2. **Draw current responsibilities**: mark protocol parsing, validation, business decisions, persistence/API calls, mapping, state updates, and response rendering.
3. **Extract input/output**: create use-case input and output models independent from HTTP, UI events, form state, ORM records, or API DTOs.
4. **Move decisions into a use case**: business rules, orchestration, authorization policy, and transaction boundaries leave the controller/component.
5. **Define ports**: every external call crossing inward becomes a port named by capability, not vendor.
6. **Implement adapters**: move ORM, HTTP clients, browser APIs, SDKs, storage, router, and analytics behind adapters.
7. **Add mappers**: convert request/form/API/DB shapes at the boundary.
8. **Thin the delivery layer**: controller/component only adapts input, invokes the use case, and renders/translates output.
9. **Test the use case**: use fakes/spies for ports before relying on integration or UI tests.
10. **Delete ceremony**: remove interfaces/layers that do not protect a boundary or improve tests.

## Backend Refactor Target

```pseudo
Controller -> UseCase -> Port -> InfrastructureAdapter
```

## Frontend Refactor Target

```pseudo
Component/Page -> UseCase/ApplicationAction -> Port -> Api/Storage/RouterAdapter
```

## Stop Conditions

- Stop when dependency direction is protected and the critical use case is testable without framework infrastructure.
- Do not continue extracting patterns just to match a diagram.
