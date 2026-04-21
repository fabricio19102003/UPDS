# State Management

## 6. State Management

### Signal Services — Lightweight Store (Preferred)

```typescript
// features/cart/data/cart.store.ts
import { Injectable, signal, computed, effect, inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { CartItem } from '../models/cart-item.model';

@Injectable({ providedIn: 'root' })
export class CartStore {
  // Private mutable state
  private _items = signal<CartItem[]>([]);
  private isBrowser = isPlatformBrowser(inject(PLATFORM_ID));

  // Public read-only state
  readonly items = this._items.asReadonly();
  readonly total = computed(() =>
    this._items().reduce((sum, i) => sum + i.price * i.qty, 0)
  );
  readonly itemCount = computed(() =>
    this._items().reduce((n, i) => n + i.qty, 0)
  );
  readonly isEmpty = computed(() => this._items().length === 0);

  constructor() {
    // SSR guard: localStorage is only available in the browser
    if (this.isBrowser) {
      // Persist to localStorage on every change
      effect(() => {
        localStorage.setItem('cart', JSON.stringify(this._items()));
      });

      // Rehydrate on startup
      const saved = localStorage.getItem('cart');
      if (saved) this._items.set(JSON.parse(saved));
    }
  }

  addItem(item: CartItem): void {
    this._items.update(items => {
      const existing = items.find(i => i.id === item.id);
      if (existing) {
        return items.map(i =>
          i.id === item.id ? { ...i, qty: i.qty + 1 } : i
        );
      }
      return [...items, { ...item, qty: 1 }];
    });
  }

  removeItem(id: string): void {
    this._items.update(items => items.filter(i => i.id !== id));
  }

  clear(): void {
    this._items.set([]);
  }
}
```

### When to Use a Proper Store (NgRx)

Use NgRx (or similar) when:
- Multiple features share complex state with many actors
- You need time-travel debugging / DevTools inspection
- State transitions are complex enough to need reducers + effects
- Your team is already using NgRx

For 80% of apps, signal services are sufficient.

### Immutability Patterns

```typescript
// ✅ DO — always produce new references
this._users.update(users => users.map(u =>
  u.id === id ? { ...u, name: newName } : u
));

// ✅ DO — filter to remove
this._items.update(items => items.filter(i => i.id !== removeId));

// ✅ DO — spread to add
this._tags.update(tags => [...tags, newTag]);

// ❌ DON'T — mutate in place (signal won't detect change)
this._users.update(users => {
  users.find(u => u.id === id)!.name = newName; // mutates, broken
  return users;
});
```
