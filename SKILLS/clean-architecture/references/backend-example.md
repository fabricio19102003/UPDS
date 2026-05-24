# Minimal Backend Example

This example is pseudocode. Adapt syntax to the current language without changing dependency direction.

```pseudo
// Application use case: coordinates policy and ports, not framework details.
class CreateOrderUseCase:
  constructor(orderRepo: OrderRepositoryPort, payment: PaymentPort, events: EventPublisherPort)

  execute(command: CreateOrderCommand) -> CreateOrderResult:
    customer = orderRepo.getCustomer(command.customerId)
    order = Order.create(customer, command.items)

    authorization = payment.authorize(order.total)
    order.markPaymentAuthorized(authorization.id)

    orderRepo.save(order)
    events.publish(order.pullDomainEvents())

    return CreateOrderResult(order.id)
```

```pseudo
// Ports are named by business capability, not technology.
interface OrderRepositoryPort:
  getCustomer(customerId: CustomerId) -> Customer
  save(order: Order) -> void

interface PaymentPort:
  authorize(amount: Money) -> AuthorizedPayment
```

```pseudo
// Delivery adapter: HTTP is outside. It translates protocol input/output.
class CreateOrderController:
  constructor(createOrder: CreateOrderUseCase)

  handle(httpRequest) -> httpResponse:
    command = CreateOrderCommand.fromRequest(httpRequest.body)
    result = createOrder.execute(command)
    return HttpResponse.created({ id: result.orderId })
```

```pseudo
// Infrastructure adapter: DB is outside. Mapper protects Domain from persistence shape.
class SqlOrderRepository implements OrderRepositoryPort:
  constructor(db, mapper: OrderMapper)

  save(order):
    row = mapper.toPersistence(order)
    db.upsert("orders", row)

class OrderMapper:
  toDomain(row) -> Order
  toPersistence(order) -> OrderRow
```

```pseudo
// Use-case test: no HTTP server, no DB, no ORM.
test "creates order and authorizes payment":
  orderRepo = FakeOrderRepository(existingCustomer)
  payment = FakePaymentPort(authorizedId = "pay_123")
  events = SpyEventPublisher()

  useCase = CreateOrderUseCase(orderRepo, payment, events)
  result = useCase.execute(CreateOrderCommand(customerId, items))

  assert result.orderId exists
  assert orderRepo.savedOrder.status == "PAYMENT_AUTHORIZED"
  assert payment.authorizedAmount == expectedTotal
  assert events.published contains OrderCreated
```
