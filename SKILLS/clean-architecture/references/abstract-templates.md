# Abstract Templates

Use these as shapes, not exact code. Rename roles to match the project language and conventions.

## Use Case

```pseudo
class UseCaseName:
  constructor(requiredPortA, requiredPortB, optionalPolicy)

  execute(input: UseCaseInput) -> UseCaseOutput:
    validate input shape or delegate validation policy; keep domain invariant validation inside Domain
    load required state through ports
    apply domain/application decisions
    persist or call external systems through ports
    return output model
```

## Input / Output Models

```pseudo
type UseCaseInput = {
  primitiveOrValueObjectFields
}

type UseCaseOutput = {
  resultFieldsOnlyNeededByCaller
}
```

## Port

```pseudo
interface CapabilityPort:
  methodNamedByBusinessNeed(input) -> output
```

Port names should describe the application need: `AuthorizePayment`, `LoadAccount`, `SaveCart`, `SendNotification`, `GetCurrentUser`.

## Adapter

```pseudo
class ConcreteTechnologyAdapter implements CapabilityPort:
  constructor(externalClient, mapper)

  methodNamedByBusinessNeed(input):
    externalInput = mapper.toExternal(input)
    externalResult = externalClient.call(externalInput)
    return mapper.toInternal(externalResult)
```

## Mapper

```pseudo
class BoundaryMapper:
  toInternal(externalDtoOrRecord) -> DomainOrApplicationModel
  toExternal(domainOrApplicationModel) -> ExternalDtoOrRecord
```

## Use-Case Test

```pseudo
test "use case expresses expected business outcome":
  fakePort = FakeCapabilityPort(preconfiguredResult)
  spyPort = SpySideEffectPort()
  useCase = UseCaseName(fakePort, spyPort)

  result = useCase.execute(validInput)

  assert result == expectedOutput
  assert spyPort.wasCalledWith(expectedSideEffect)
  assert no framework/database/http dependency was required
```
