# Testing — Complete Guide

## 12. Testing — Complete Guide

### Vitest Configuration

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import angular from '@analogjs/vite-plugin-angular';

export default defineConfig({
  plugins: [angular()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['src/test-setup.ts'],
    include: ['src/**/*.spec.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'lcov'],
      include: ['src/**/*.ts'],
      exclude: ['src/**/*.spec.ts', 'src/main.ts', 'src/test-setup.ts']
    }
  }
});

// src/test-setup.ts
import '@analogjs/platform/testing';
import { getTestBed } from '@angular/core/testing';
import { BrowserDynamicTestingModule, platformBrowserDynamicTesting } from '@angular/platform-browser-dynamic/testing';

getTestBed().initTestEnvironment(
  BrowserDynamicTestingModule,
  platformBrowserDynamicTesting()
);
```

### Component Testing — TestBed

```typescript
// user-card.spec.ts
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { UserCard } from './user-card';
import { By } from '@angular/platform-browser';
import { User } from '../models/user.model';

describe('UserCard', () => {
  let fixture: ComponentFixture<UserCard>;
  let component: UserCard;

  const mockUser: User = { id: '1', name: 'Alice', email: 'alice@test.com', status: 'active' };

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [UserCard]
    }).compileComponents();

    fixture = TestBed.createComponent(UserCard);
    component = fixture.componentInstance;
    fixture.componentRef.setInput('user', mockUser);
    fixture.detectChanges();
  });

  it('displays the user name', () => {
    const nameEl = fixture.debugElement.query(By.css('h3'));
    expect(nameEl.nativeElement.textContent).toContain('Alice');
  });

  it('emits selectUser when button clicked', () => {
    const spy = vi.fn();
    component.selectUser.subscribe(spy);

    const btn = fixture.debugElement.query(By.css('app-button'));
    btn.triggerEventHandler('clicked', null);

    expect(spy).toHaveBeenCalledWith(mockUser);
  });
});
```

### Component Testing — Angular Testing Library (Preferred)

```typescript
// user-list.spec.ts
import { render, screen, fireEvent } from '@testing-library/angular';
import { UserList } from './user-list';

const mockUsers: User[] = [
  { id: '1', name: 'Alice', email: 'alice@test.com' },
  { id: '2', name: 'Bob', email: 'bob@test.com' }
];

describe('UserList', () => {
  it('renders all users', async () => {
    await render(UserList, {
      inputs: { users: mockUsers }
    });

    expect(screen.getByText('Alice')).toBeInTheDocument();
    expect(screen.getByText('Bob')).toBeInTheDocument();
  });

  it('shows empty state when no users', async () => {
    await render(UserList, {
      inputs: { users: [] }
    });

    expect(screen.getByText('No users found.')).toBeInTheDocument();
  });

  it('emits userSelected on click', async () => {
    const onUserSelected = vi.fn();

    await render(UserList, {
      inputs: { users: mockUsers },
      on: { userSelected: onUserSelected }
    });

    fireEvent.click(screen.getByText('Alice'));
    expect(onUserSelected).toHaveBeenCalledWith(mockUsers[0]);
  });
});
```

### Service Testing

```typescript
// cart.store.spec.ts
import { TestBed } from '@angular/core/testing';
import { CartStore } from './cart.store';

describe('CartStore', () => {
  let store: CartStore;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    store = TestBed.inject(CartStore);
  });

  it('starts empty', () => {
    expect(store.items()).toEqual([]);
    expect(store.isEmpty()).toBe(true);
  });

  it('adds an item', () => {
    const item: CartItem = { id: '1', name: 'Widget', price: 9.99, qty: 1 };
    store.addItem(item);

    expect(store.items()).toHaveLength(1);
    expect(store.total()).toBe(9.99);
    expect(store.isEmpty()).toBe(false);
  });

  it('increments qty for existing item', () => {
    const item: CartItem = { id: '1', name: 'Widget', price: 9.99, qty: 1 };
    store.addItem(item);
    store.addItem(item); // add again

    expect(store.items()[0].qty).toBe(2);
    expect(store.total()).toBe(19.98);
  });

  it('removes an item', () => {
    store.addItem({ id: '1', name: 'Widget', price: 9.99, qty: 1 });
    store.removeItem('1');
    expect(store.isEmpty()).toBe(true);
  });
});
```

### Signal Testing

```typescript
// Testing computed signals
import { TestBed } from '@angular/core/testing';
import { signal, computed, effect } from '@angular/core';

describe('Signal behavior', () => {
  it('computed recalculates on dependency change', () => {
    const price = signal(10);
    const qty = signal(2);
    const total = computed(() => price() * qty());

    expect(total()).toBe(20);

    TestBed.runInInjectionContext(() => {
      price.set(15);
    });
    expect(total()).toBe(30);
  });

  it('effect runs on signal change', () => {
    const sideEffects: number[] = [];
    const count = signal(0);

    TestBed.runInInjectionContext(() => {
      effect(() => { sideEffects.push(count()); });
    });

    TestBed.flushEffects();
    expect(sideEffects).toEqual([0]);

    count.set(1);
    TestBed.flushEffects();
    expect(sideEffects).toEqual([0, 1]);
  });
});
```

### HTTP Testing with HttpTestingController

When testing `resource()`-based APIs, trigger the resource by setting the params signal and then flush the pending HTTP request. The `resource()` API fires HTTP requests internally via `HttpClient`.

```typescript
// product-api.spec.ts — testing a resource()-based API
import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting, HttpTestingController } from '@angular/common/http/testing';
import { ProductApi } from './product-api';
import { Product } from '../models/product.model';

describe('ProductApi', () => {
  let api: ProductApi;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        ProductApi,
        provideHttpClient(),
        provideHttpClientTesting()
      ]
    });
    api = TestBed.inject(ProductApi);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => { httpMock.verify(); });

  it('fetches products on initialization', async () => {
    const mockProducts: Product[] = [{ id: '1', name: 'Widget', price: 9.99 }];

    // resource() fires the HTTP call immediately on creation
    const req = httpMock.expectOne(r => r.url.includes('/api/products'));
    expect(req.request.method).toBe('GET');
    req.flush(mockProducts);

    // Wait for the resource to settle after flush — TestBed.inject() is synchronous
    await TestBed.flushEffects(); // settles signal-based resource — no component fixture needed in pure service tests
    expect(api.products.value()).toEqual(mockProducts);
  });

  it('refetches when filters change', async () => {
    // Flush initial request
    httpMock.expectOne(r => r.url.includes('/api/products')).flush([]);

    // Change filters — triggers refetch
    api.updateFilters({ search: 'widget' });

    const req = httpMock.expectOne(r => r.url.includes('search=widget'));
    expect(req.request.method).toBe('GET');
    req.flush([{ id: '1', name: 'Widget', price: 9.99 }]);
  });
});
```

### MSW (Mock Service Worker) — API Mocking

```typescript
// src/mocks/handlers.ts
import { http, HttpResponse } from 'msw';

export const handlers = [
  http.get('/api/users', () => {
    return HttpResponse.json([
      { id: '1', name: 'Alice', email: 'alice@test.com' }
    ]);
  }),

  http.get('/api/users/:id', ({ params }) => {
    return HttpResponse.json({ id: params.id, name: 'Alice' });
  }),

  http.post('/api/users', async ({ request }) => {
    const body = await request.json();
    return HttpResponse.json({ id: 'new-id', ...body }, { status: 201 });
  }),

  http.delete('/api/users/:id', () => {
    return new HttpResponse(null, { status: 204 });
  })
];

// src/mocks/server.ts
import { setupServer } from 'msw/node';
import { handlers } from './handlers';
export const server = setupServer(...handlers);

// src/test-setup.ts — add MSW setup
import { server } from './mocks/server';
beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

// Override in specific tests
it('handles server error', async () => {
  server.use(
    http.get('/api/users', () => HttpResponse.json({ error: 'Internal Server Error' }, { status: 500 }))
  );
  // ... test
});
```

### Guard Testing

```typescript
// auth-guard.spec.ts
import { TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { authGuard } from './auth-guard';
import { AuthProvider } from '@shared/data/auth';
import { signal } from '@angular/core';

describe('authGuard', () => {
  let routerSpy: { navigate: ReturnType<typeof vi.fn>; createUrlTree: ReturnType<typeof vi.fn> };
  let authMock: { isAuthenticated: ReturnType<typeof signal> };

  beforeEach(() => {
    routerSpy = {
      navigate: vi.fn(),
      createUrlTree: vi.fn().mockReturnValue('/login')
    };
    authMock = { isAuthenticated: signal(false) };

    TestBed.configureTestingModule({
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: AuthProvider, useValue: authMock }
      ]
    });
  });

  it('allows access when authenticated', () => {
    authMock.isAuthenticated.set(true);
    const result = TestBed.runInInjectionContext(() =>
      authGuard({} as any, { url: '/dashboard' } as any)
    );
    expect(result).toBe(true);
  });

  it('redirects to login when not authenticated', () => {
    authMock.isAuthenticated.set(false);
    TestBed.runInInjectionContext(() =>
      authGuard({} as any, { url: '/dashboard' } as any)
    );
    expect(routerSpy.createUrlTree).toHaveBeenCalledWith(['/login'], {
      queryParams: { returnUrl: '/dashboard' }
    });
  });
});
```

### Interceptor Testing

```typescript
// auth-interceptor.spec.ts
import { TestBed } from '@angular/core/testing';
import { HttpClient, provideHttpClient, withInterceptors } from '@angular/common/http';
import { provideHttpClientTesting, HttpTestingController } from '@angular/common/http/testing';
import { authInterceptor } from './auth';
import { AuthProvider } from '@shared/data/auth';
import { signal } from '@angular/core';

describe('authInterceptor', () => {
  let http: HttpClient;
  let httpMock: HttpTestingController;
  const authMock = { token: signal<string | null>(null) };

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        { provide: AuthProvider, useValue: authMock },
        provideHttpClient(withInterceptors([authInterceptor])),
        provideHttpClientTesting()
      ]
    });
    http = TestBed.inject(HttpClient);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => httpMock.verify());

  it('adds Authorization header when token exists', () => {
    authMock.token.set('my-token');
    http.get('/api/data').subscribe();

    const req = httpMock.expectOne('/api/data');
    expect(req.request.headers.get('Authorization')).toBe('Bearer my-token');
    req.flush({});
  });

  it('does not add header when no token', () => {
    authMock.token.set(null);
    http.get('/api/data').subscribe();

    const req = httpMock.expectOne('/api/data');
    expect(req.request.headers.has('Authorization')).toBe(false);
    req.flush({});
  });
});
```

### Form Testing

```typescript
// login-form.spec.ts
import { render, screen, fireEvent, waitFor } from '@testing-library/angular';
import { LoginForm } from './login-form';

describe('LoginForm', () => {
  it('disables submit when form is invalid', async () => {
    await render(LoginForm);
    const submitBtn = screen.getByRole('button', { name: /login/i });
    expect(submitBtn).toBeDisabled();
  });

  it('enables submit when form is valid', async () => {
    await render(LoginForm);

    fireEvent.input(screen.getByRole('textbox', { name: /email/i }), {
      target: { value: 'test@test.com' }
    });
    fireEvent.input(screen.getByLabelText(/password/i), {
      target: { value: 'SecurePass1!' }
    });

    await waitFor(() => {
      expect(screen.getByRole('button', { name: /login/i })).toBeEnabled();
    });
  });

  it('shows email validation error', async () => {
    await render(LoginForm);
    const emailInput = screen.getByRole('textbox', { name: /email/i });

    fireEvent.input(emailInput, { target: { value: 'not-an-email' } });
    fireEvent.blur(emailInput);

    await waitFor(() => {
      expect(screen.getByText(/valid email required/i)).toBeInTheDocument();
    });
  });
});
```

### Component Harnesses (Angular CDK)

```typescript
// button.harness.ts
import { ComponentHarness } from '@angular/cdk/testing';

export class ButtonHarness extends ComponentHarness {
  static hostSelector = 'app-button';

  // Locate the inner native <button> element
  private getButton = this.locatorFor('button');

  async click(): Promise<void> {
    return (await this.getButton()).click();
  }

  async isDisabled(): Promise<boolean> {
    // Check the inner button's disabled property — not a CSS class on the host
    return (await this.getButton()).getProperty<boolean>('disabled');
  }

  async getText(): Promise<string> {
    return (await this.getButton()).text();
  }
}

// Usage in test
const harness = await loader.getHarness(ButtonHarness);
expect(await harness.isDisabled()).toBe(false);
await harness.click();
```

### Testing Patterns

```
Arrange-Act-Assert (AAA) — always follow this structure:

describe('UserCard', () => {
  it('emits delete event when delete button clicked', async () => {
    // ARRANGE
    const user = { id: '1', name: 'Alice' };
    const onDelete = vi.fn();
    await render(UserCard, { inputs: { user }, on: { deleteUser: onDelete } });

    // ACT
    fireEvent.click(screen.getByRole('button', { name: /delete/i }));

    // ASSERT
    expect(onDelete).toHaveBeenCalledWith(user);
  });
});
```

### What to Test vs What NOT to Test

```
✅ DO TEST:
- Component renders correct data from inputs
- Component emits correct outputs on user interaction
- Computed signals recalculate correctly
- Effects fire at the right time
- HTTP calls use correct URL, method, and body
- Guards block/allow navigation correctly
- Form validation logic
- Business logic in services (pure functions)
- Error states (what shows when API fails)
- Empty states (@empty blocks, loading states)

❌ DO NOT TEST:
- Angular internals (router navigates when link clicked — Angular handles this)
- Implementation details (private methods, internal signal values)
- Template HTML structure for its own sake (if it renders, it renders)
- Third-party library behavior
- CSS / visual styles
- Things that are fully covered by other unit tests already
```

### Zoneless Testing

When using `provideZonelessChangeDetection()`, add it to your TestBed configuration and use `await fixture.whenStable()` as the **primary** way to wait for async updates. `detectChanges()` is still available as an explicit/secondary option.

```typescript
// ✅ PRIMARY PATTERN — zoneless TestBed with whenStable()
it('updates when signal changes', async () => {
  await TestBed.configureTestingModule({
    imports: [MyComponent],
    providers: [provideZonelessChangeDetection()] // match app config
  }).compileComponents();

  const fixture = TestBed.createComponent(MyComponent);
  fixture.componentRef.setInput('count', 5);

  // await whenStable() — preferred for zoneless: waits for all async work
  await fixture.whenStable();
  expect(fixture.nativeElement.textContent).toContain('5');
});

// ✅ SECONDARY OPTION — explicit detectChanges() (synchronous updates)
it('updates synchronously', () => {
  fixture.componentRef.setInput('count', 5);
  fixture.detectChanges(); // explicit — still works in zoneless
  expect(fixture.nativeElement.textContent).toContain('5');
});

// ✅ Flush pending effects synchronously
TestBed.flushEffects();
```
