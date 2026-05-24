# Minimal Frontend Example

Frontend Clean Architecture means UI is a driving adapter. Components trigger application behavior; adapters hide API, storage, router, analytics, and framework details.

## Good Flow

```pseudo
// Domain
type Product = { id: ProductId, title: string, price: Money }

// Application ports
interface ProductRepository:
  findById(id: ProductId) -> Product?

interface CartRepository:
  get() -> Cart
  save(cart: Cart) -> void

// Optional boundary side effect. Alternatively return an application output and let UI notify.
interface NotificationPort:
  success(message: string) -> void
  error(message: string) -> void
```

```pseudo
// Application use case
function AddProductToCart(deps):
  return async function execute(command):
    product = await deps.products.findById(ProductId(command.productId))
    if product is null:
      deps.notifier.error("Product not found")
      return

    cart = await deps.cart.get()
    cart.add(product)
    await deps.cart.save(cart)
    deps.notifier.success("Product added")
```

```pseudo
// Infrastructure adapter
class HttpProductRepository implements ProductRepository:
  constructor(http, mapper)

  async findById(id):
    dto = await http.get("/products/" + id.value)
    return mapper.toDomain(dto)

class ProductApiMapper:
  toDomain(dto):
    return Product({ id: ProductId(dto.id), title: dto.name, price: Money.fromCents(dto.price_cents) })
```

```pseudo
// UI component receives the application action; it does not know HTTP/storage details.
function ProductCard({ productId, addProductToCart }):
  return Button(onClick = () => addProductToCart({ productId }))
```

## Bad vs Good

Bad: component owns API calls, DTO shape, and business workflow.

```pseudo
function ProductCard({ productId }):
  async function onClick():
    productDto = await fetch("/api/products/" + productId).json()
    await fetch("/api/cart", { method: "POST", body: { product_id: productDto.id, price_cents: productDto.price_cents } })
  return Button(onClick)
```

Good: component delegates; use case coordinates; adapter maps.

```pseudo
function ProductCard({ productId, addProductToCart }):
  return Button(onClick = () => addProductToCart({ productId }))

async function addProductToCart(command, deps):
  product = await deps.productRepository.findById(command.productId)
  cart = await deps.cartRepository.get()
  cart.add(product)
  await deps.cartRepository.save(cart)
```
