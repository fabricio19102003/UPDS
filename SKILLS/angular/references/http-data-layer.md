# HTTP & Data Layer

## 11. HTTP & Data Layer

### Resource API — Preferred Pattern

```typescript
// features/products/data/product-api.ts
import { Injectable, inject, signal, resource } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';
import { Product, ProductFilters } from '../models/product.model';

@Injectable({ providedIn: 'root' })
export class ProductApi {
  private http = inject(HttpClient);
  private filters = signal<ProductFilters>({ page: 0, pageSize: 20 });

  products = resource({
    params: () => this.filters(),
    loader: async ({ params: filters, abortSignal }) => {
      const urlParams = new URLSearchParams({
        page: String(filters.page),
        size: String(filters.pageSize),
        ...(filters.search && { search: filters.search })
      });
      return firstValueFrom(
        this.http.get<Product[]>(`/api/products?${urlParams}`)
      );
    }
  });

  updateFilters(partial: Partial<ProductFilters>): void {
    this.filters.update(f => ({ ...f, ...partial, page: 0 }));
  }

  nextPage(): void {
    this.filters.update(f => ({ ...f, page: f.page + 1 }));
  }
}
```

### Functional Interceptors — Full Suite

```typescript
// Auth interceptor
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const auth = inject(AuthProvider);
  const token = auth.token();
  if (!token) return next(req);
  return next(req.clone({ setHeaders: { Authorization: `Bearer ${token}` } }));
};

// Error interceptor
export const errorInterceptor: HttpInterceptorFn = (req, next) => {
  const router = inject(Router);
  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 401) router.navigate(['/login']);
      if (error.status === 403) router.navigate(['/forbidden']);
      return throwError(() => error);
    })
  );
};

// Retry interceptor with exponential backoff
export const retryInterceptor: HttpInterceptorFn = (req, next) => {
  return next(req).pipe(
    retry({
      count: 3,
      delay: (error, attempt) => {
        if (error.status === 0 || error.status >= 500) {
          return timer(Math.pow(2, attempt) * 1000); // 2s, 4s, 8s
        }
        return throwError(() => error);
      }
    })
  );
};

// Loading interceptor
export const loadingInterceptor: HttpInterceptorFn = (req, next) => {
  const loading = inject(LoadingService);
  loading.increment();
  return next(req).pipe(
    finalize(() => loading.decrement())
  );
};
```

### Optimistic Updates

```typescript
@Injectable({ providedIn: 'root' })
export class TodoStore {
  private _todos = signal<Todo[]>([]);
  readonly todos = this._todos.asReadonly();

  private http = inject(HttpClient);

  async toggleTodo(id: string): Promise<void> {
    // 1. Optimistic update
    const previous = this._todos();
    this._todos.update(todos =>
      todos.map(t => t.id === id ? { ...t, done: !t.done } : t)
    );

    // 2. Server sync
    try {
      const updated = this._todos().find(t => t.id === id)!;
      await firstValueFrom(this.http.patch(`/api/todos/${id}`, { done: updated.done }));
    } catch {
      // 3. Rollback on failure
      this._todos.set(previous);
    }
  }
}
```

### Caching Pattern

```typescript
@Injectable({ providedIn: 'root' })
export class CachedUserApi {
  private http = inject(HttpClient);
  private cache = new Map<string, { data: User; timestamp: number }>();
  private TTL = 5 * 60 * 1000; // 5 minutes

  getUser(id: string): Observable<User> {
    const cached = this.cache.get(id);
    if (cached && Date.now() - cached.timestamp < this.TTL) {
      return of(cached.data);
    }
    return this.http.get<User>(`/api/users/${id}`).pipe(
      tap(user => this.cache.set(id, { data: user, timestamp: Date.now() }))
    );
  }

  invalidate(id: string): void { this.cache.delete(id); }
}
```
