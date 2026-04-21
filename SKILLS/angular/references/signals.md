# Signals — The Complete Guide

## 5. Signals — The Complete Guide

### signal() — Basic State

```typescript
import { signal, Signal } from '@angular/core';

// Create
const count = signal(0);
const user = signal<User | null>(null);

// Read
console.log(count()); // 0

// Update
count.set(5);         // replace
count.update(n => n + 1); // transform
user.set({ id: '1', name: 'Alice' });

// Read-only public API
export class Counter {
  private _count = signal(0);
  readonly count: Signal<number> = this._count.asReadonly();

  increment(): void { this._count.update(n => n + 1); }
}
```

### computed() — Derived State

```typescript
import { signal, computed } from '@angular/core';

const firstName = signal('John');
const lastName = signal('Doe');

// Lazy — only recalculates when dependencies change
const fullName = computed(() => `${firstName()} ${lastName()}`);
console.log(fullName()); // "John Doe"

// Complex derived state
const cart = signal<CartItem[]>([]);
const total = computed(() =>
  cart().reduce((sum, item) => sum + item.price * item.qty, 0)
);
const hasItems = computed(() => cart().length > 0);
const itemCount = computed(() => cart().reduce((n, i) => n + i.qty, 0));
```

### effect() — Side Effects

```typescript
import { effect, signal, inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';

export class ThemeService {
  private theme = signal<'light' | 'dark'>('light');
  private isBrowser = isPlatformBrowser(inject(PLATFORM_ID));

  constructor() {
    // SSR guard: document and localStorage are browser-only
    if (this.isBrowser) {
      // Automatically cleaned up when service is destroyed
      effect(() => {
        document.documentElement.setAttribute('data-theme', this.theme());
        localStorage.setItem('theme', this.theme());
      });
    }
  }

  // Cleanup inside effect
  setupPolling(): void {
    effect((onCleanup) => {
      const id = setInterval(() => this.refresh(), 5000);
      onCleanup(() => clearInterval(id)); // runs before next effect or on destroy
    });
  }
}
```

### linkedSignal() — Derived Writable Signal

```typescript
import { signal, linkedSignal, input } from '@angular/core';

// Use case: reset selection when options change
export class SelectComponent {
  options = input.required<string[]>();

  // Resets to first option whenever options() changes
  selectedOption = linkedSignal(() => this.options()[0]);

  // Can still be overridden by user
  select(option: string): void {
    this.selectedOption.set(option); // manual override works
  }
}

// Complex linked signal with previous value
const pageSize = signal(10);
const currentPage = linkedSignal<number>({
  source: pageSize,
  computation: (newSize, previous) =>
    previous ? Math.floor((previous.value * previous.source) / newSize) : 0
});
```

### resource() — Async Data Loading

```typescript
import { resource, signal, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';

export class UserApi {
  private http = inject(HttpClient);
  private userId = signal<string | null>(null);

  // Automatically refetches when userId changes
  user = resource({
    params: () => this.userId(),
    loader: async ({ params: id, abortSignal }) => {
      if (!id) return null;
      return firstValueFrom(
        this.http.get<User>(`/api/users/${id}`)
      );
    }
  });

  loadUser(id: string): void {
    this.userId.set(id);
  }
}

// Usage in template
@Component({
  template: `
    @if (api.user.isLoading()) {
      <app-spinner />
    } @else if (api.user.error()) {
      <app-error [message]="api.user.error()" />
    } @else if (api.user.value(); as user) {
      <app-user-detail [user]="user" />
    }
  `
})
export class UserPage {
  protected api = inject(UserApi);
}
```

### rxResource() — RxJS-Based Resource

```typescript
import { signal, inject } from '@angular/core';
import { rxResource } from '@angular/core/rxjs-interop';
import { HttpClient } from '@angular/common/http';

export class ProductApi {
  private http = inject(HttpClient);
  private categoryId = signal<number>(1);

  products = rxResource({
    params: () => ({ category: this.categoryId() }),
    stream: ({ params }) =>
      this.http.get<Product[]>(`/api/products?category=${params.category}`)
  });
}
```

### toSignal() / toObservable() — RxJS Bridge

```typescript
import { toSignal, toObservable } from '@angular/core/rxjs-interop';
import { inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { switchMap, map, EMPTY } from 'rxjs';

export class UserPage {
  private route = inject(ActivatedRoute);
  private http = inject(HttpClient);

  // Observable → Signal
  userId = toSignal(
    this.route.paramMap.pipe(map(p => p.get('id'))),
    { initialValue: null }
  );

  // Signal → Observable (when you need RxJS operators)
  private userId$ = toObservable(this.userId);
  user$ = this.userId$.pipe(
    switchMap(id => id ? this.http.get<User>(`/api/users/${id}`) : EMPTY)
  );
}
```

### model() — Two-Way Binding

```typescript
import { Component, model, ChangeDetectionStrategy } from '@angular/core';

// Child — accepts two-way binding
@Component({
  selector: 'app-toggle',
  template: `
    <button (click)="isActive.set(!isActive())">
      {{ isActive() ? 'ON' : 'OFF' }}
    </button>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class Toggle {
  isActive = model(false); // two-way: [isActive] + (isActiveChange)
}

// Parent — uses two-way binding
@Component({
  imports: [Toggle],
  template: `
    <app-toggle [(isActive)]="featureEnabled" />
    <p>Feature is: {{ featureEnabled() ? 'on' : 'off' }}</p>
  `
})
export class FeaturePage {
  featureEnabled = signal(false);
}
```

### Signals vs RxJS — Decision Tree

```
Is the data a request/response HTTP call (load on params change)?
├── YES → Use resource() (params + loader) or rxResource() (params + stream)
│         NOTE: resource() is for request/response only — NOT for streams
│
Is the data a continuous event stream (WebSocket, SSE, real-time)?
├── YES → Use RxJS Observable + toSignal() to expose as signal
│         resource() does NOT support WebSocket or SSE
│
Is it complex stream manipulation (debounce, combineLatest, retry)?
├── YES → Use RxJS + toSignal() to expose as signal
│
Is it local component state that changes over time?
├── YES → Use signal()
│
Is it derived from other signals?
├── YES → Use computed()
│
Does it need to trigger side effects (DOM, localStorage, logging)?
├── YES → Use effect()
│
Is it a writable derived state (resets when source changes)?
├── YES → Use linkedSignal()
│
Otherwise → signal() is almost always the right answer
```
