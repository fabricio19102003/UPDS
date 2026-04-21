---
name: angular
description: >
  Angular 20+ best practices, architecture patterns, signals, testing, and modern development workflows.
  Trigger: When writing Angular code, creating components, services, testing, or making architecture decisions in Angular projects.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

# Angular 20+ Definitive Agent Skill

This skill is the AUTHORITATIVE reference for Angular 20+ development. Every pattern here is production-ready, opinionated, and current. An agent reading only this skill knows the critical rules; full details are in the `references/` folder.

---

## Table of Contents

1. [General Principles](#1-general-principles) — **FULL (core rules)**
2. [Project Architecture](references/architecture.md) — Feature folders, barrel exports, path aliases
3. [Atomic Design in Angular](references/architecture.md) — Atoms, molecules, organisms, pages
4. [Component Patterns](references/components.md) — Presentational, container, host metadata
5. [Signals — The Complete Guide](references/signals.md) — signal, computed, effect, resource, rxResource
6. [State Management](references/state-management.md) — Signal stores, NgRx decision, immutability
7. [Dependency Injection — Modern Style](references/dependency-injection.md) — inject(), tokens, guards, interceptors
8. [Routing — Modern Patterns](references/routing.md) — Functional routes, lazy loading, resolvers
9. [Forms — Signal-Era Patterns](references/forms.md) — Reactive forms, validators, CVA
10. [Template Syntax — Modern Control Flow](references/templates.md) — @if, @for, @defer, pipes
11. [HTTP & Data Layer](references/http-data-layer.md) — resource(), interceptors, caching
12. [Testing — Complete Guide](references/testing.md) — Vitest, TestBed, ATL, MSW, harnesses
13. [Performance](references/performance.md) — Zoneless, lazy loading, virtual scroll, budgets
14. [SSR & Hydration](references/ssr-hydration.md) — Full hydration, incremental hydration, SSR guards
15. [Security](references/security.md) — Sanitization, CSP, JWT pattern
16. [Accessibility](references/accessibility.md) — CDK a11y, ARIA, keyboard navigation
17. [Build & Tooling](references/build-tooling.md) — esbuild, HMR, ESLint flat config
18. [Migration Notes](references/migration.md) — NgModules→Standalone, Zone→Zoneless, old APIs→new

---

## 1. General Principles

### Rules

- **Max 300 lines per file** — if exceeded, split into sub-components or services
- **Prefer pure functions** — no side effects unless explicitly needed
- **Meaningful, behavior-based naming** — no default suffixes like `.component.ts` (use `user-list.ts` → `export class UserList`)
- **JSDoc for all public APIs** — document purpose and usage
- **Explicit error handling** — never swallow errors silently
- **Airbnb JavaScript Style Guide** adapted for Angular/TypeScript
- **Standalone components are the default** — NEVER specify `standalone: true` (it's implicit in Angular 20)
- **Zoneless change detection** is the **opt-in recommended pattern** — add `provideZonelessChangeDetection()` in bootstrap (Zone.js is still the default unless you opt in)

### Naming Conventions

> **Note**: The behavior-based naming below (without suffixes like `.component`, `.service`) is an **opinionated project convention** — not the official Angular style guide. The official Angular style guide recommends suffixes (e.g., `UserListComponent`, `UserService`). Choose the convention that fits your team; apply it consistently.

```typescript
// ✅ DO — behavior-based naming (opinionated convention — see note above)
user-list.ts            → export class UserList
auth.ts                 → export class AuthProvider
user-data.ts            → export class UserDataClient
highlight.ts            → export class HighlightBehavior

// ✅ DO — add suffix only when ambiguity exists
auth.ts                 → export class AuthService  // acceptable when "service" clarifies role
user-list.ts            → export class UserListView // acceptable when "view" disambiguates

// ✅ ALWAYS keep suffix for Pipes (Angular requirement)
currency-pipe.ts        → export class CurrencyPipe

// ❌ DON'T — default suffix pollution
user-list.component.ts  → UserListComponent  // old style, avoid
auth.service.ts         → AuthService         // only keep "Service" if genuinely ambiguous
user.model.ts           → User                // suffix-free preferred; ".model.ts" is acceptable for type/interface files
```

### Event Handler Naming

```typescript
// ✅ DO — name what the function DOES
toggleMenu() { }
submitForm() { }
handleKeyboardNavigation() { }

// ❌ DON'T — "on" prefix (old Angular style)
onMenuToggle() { }
onFormSubmit() { }
```

### JSDoc Example

```typescript
/**
 * Fetches a paginated list of users filtered by the given criteria.
 *
 * @param filters - Search filters (name, role, status)
 * @param page - Zero-based page index
 * @returns Signal-wrapped paginated result
 */
getUsers(filters: UserFilters, page: number): Signal<PaginatedResult<User>> { ... }
```

---

## Section Summaries

### 2–3. Architecture & Atomic Design → [Full Reference](references/architecture.md)

- **Screaming Architecture**: `src/features/`, `src/shared/`, `src/core/` — folders named by domain
- **Barrel exports** via `index.ts` — only export the public surface, never internal details
- **Path aliases**: `@shared/*`, `@features/*`, `@core/*` in `tsconfig.json`
- **Atomic Design**: Atom → Molecule → Organism → Template → Page; each level imports only from below
- **Page components** are containers: inject data, pass to presentational children

### 4. Component Patterns → [Full Reference](references/components.md)

- ALWAYS `ChangeDetectionStrategy.OnPush` — no exceptions
- ALWAYS standalone (no NgModule); ALWAYS `input()` / `output()`; ALWAYS `inject()`
- ALWAYS `host: {}` metadata — never `@HostBinding` / `@HostListener`
- **Presentational** = inputs + outputs only; **Container** = injects services, orchestrates
- Use `viewChild()` / `contentChild()` signal-based queries (Angular 17+)

### 5. Signals → [Full Reference](references/signals.md)

- `signal()` = mutable state; `computed()` = derived (lazy); `effect()` = side effects (browser-only with SSR guard)
- `linkedSignal()` = writable derived (resets with source); `model()` = two-way binding
- `resource()` = request/response HTTP (NOT for streams); `rxResource()` = RxJS stream resource
- Bridge: `toSignal()` Observable→Signal; `toObservable()` Signal→Observable
- Decision: real-time streams → RxJS + toSignal(); local state → signal(); derived → computed()

### 6. State Management → [Full Reference](references/state-management.md)

- Signal services with `private _state = signal(...)` + `readonly state = this._state.asReadonly()`
- Use NgRx only for: cross-feature complex state, time-travel debugging, or existing NgRx teams
- Always produce new references — never mutate in-place inside `update()`
- SSR guard localStorage access with `isPlatformBrowser()`

### 7. Dependency Injection → [Full Reference](references/dependency-injection.md)

- `inject()` at field level — never constructor injection
- `InjectionToken` for configuration values; `multi: true` for plugin patterns
- Functional guards (`CanActivateFn`) and functional interceptors (`HttpInterceptorFn`)
- `provideZonelessChangeDetection()` in `app.config.ts` only (single source of truth)

### 8. Routing → [Full Reference](references/routing.md)

- `loadComponent` for lazy components; `loadChildren` for lazy feature routes
- Route params auto-bound as inputs via `withComponentInputBinding()` — no ActivatedRoute needed
- Functional resolvers (`ResolveFn`); functional `canDeactivate` with SSR guard for `confirm()`
- Layout routes with nested `<router-outlet>` for shared chrome

### 9. Forms → [Full Reference](references/forms.md)

- `FormBuilder.nonNullable.group()` for strict typing; always `getRawValue()`
- Custom validators: `ValidatorFn` (sync) and `AsyncValidatorFn` (async with `Observable<ValidationErrors | null>`)
- CVA: use `host: { '(focusout)': 'onFocusOut($event)' }` on host to correctly detect when focus leaves the control
- Dynamic forms via `FormArray`; `FormBuilder.array()` + `push/removeAt`

### 10. Templates → [Full Reference](references/templates.md)

- `@if` / `@else if` / `@else` — replace `*ngIf`; `@for (... track id)` — ALWAYS include `track`
- `@switch` / `@case` / `@default` — replace `[ngSwitch]`
- `@defer (on viewport)` for progressive loading with `@placeholder`, `@loading`, `@error`
- `in` operator NOT supported in templates — use a method or computed signal

### 11. HTTP & Data Layer → [Full Reference](references/http-data-layer.md)

- `resource()` is the preferred pattern for HTTP data — auto-refetches on params signal change
- Interceptors: auth (add token), error (redirect on 401/403), retry (exponential backoff), loading
- Optimistic updates: snapshot → update → try server → catch rollback
- TTL cache pattern with `Map<string, {data, timestamp}>` for expensive reads

### 12. Testing → [Full Reference](references/testing.md)

- Vitest + `@analogjs/vite-plugin-angular` — fast, no Karma/Jasmine
- Prefer Angular Testing Library (`render`, `screen`, `fireEvent`) over raw TestBed for component tests
- `fixture.componentRef.setInput()` to set signal inputs in TestBed tests
- HTTP: `provideHttpClientTesting()` + `HttpTestingController`; flush `resource()` requests
- MSW for integration-level API mocking; CDK Harnesses for reusable component test APIs
- Zoneless: `await fixture.whenStable()` primary; `fixture.detectChanges()` secondary; `TestBed.flushEffects()` for effects

### 13. Performance → [Full Reference](references/performance.md)

- `provideZonelessChangeDetection()` — opt-in, declared once in `app.config.ts`
- Route-level `loadComponent` / `loadChildren` — always lazy-load feature routes
- `NgOptimizedImage` for all `<img>` — adds srcset, lazy, LCP preload automatically
- CDK Virtual Scroll for lists > 100 items; `@defer (on viewport)` for heavy off-screen components
- Bundle budgets in `angular.json`; tree-shake by importing specific RxJS operators

### 14. SSR & Hydration → [Full Reference](references/ssr-hydration.md)

- `provideClientHydration(withEventReplay())` in `app.config.ts` (client config, NOT server config)
- Incremental hydration requires `withIncrementalHydration()` + `@defer (hydrate on ...)`
- `afterNextRender()` for one-time browser setup; `afterRenderEffect()` for reactive browser side effects
- NEVER use `window`, `document`, `localStorage` in constructor — always guard with `isPlatformBrowser()`

### 15. Security → [Full Reference](references/security.md)

- Angular sanitizes `[innerHTML]` and `[href]` automatically — do not bypass without validation
- `bypassSecurityTrustResourceUrl()` ONLY after explicit allowlist check
- Strict CSP in `index.html`; enable `trustedTypes` in `angular.json`
- JWT: store access token **in-memory only**; refresh token via httpOnly cookie (server-managed)

### 16. Accessibility → [Full Reference](references/accessibility.md)

- Use `cdkTrapFocus` + `LiveAnnouncer` from `@angular/cdk/a11y` for modals/dialogs
- `[attr.aria-expanded]`, `[attr.aria-controls]` for expandable patterns
- `FocusKeyManager` constructed from `viewChildren()` — NOT injectable; rebuild in `effect()` when items change
- Add `.withTypeAhead()` only when items implement `getLabel(): string`

### 17. Build & Tooling → [Full Reference](references/build-tooling.md)

- Angular 20 uses esbuild + Vite by default (`@angular-devkit/build-angular:application`)
- HMR enabled by default in `ng serve`; use `--stats-json` + `webpack-bundle-analyzer` for bundle analysis
- ESLint flat config (`eslint.config.mjs`) with `angular-eslint` and `typescript-eslint`

### 18. Migration Notes → [Full Reference](references/migration.md)

- NgModules → Standalone: drop `declarations`, add direct `imports` to `@Component`
- Zone.js → Zoneless: add `provideZonelessChangeDetection()`, remove `import 'zone.js'`
- Constructor DI → `inject()`; `@Input`/`@Output` → `input()`/`output()`; `@ViewChild` → `viewChild()`
- `*ngIf`/`*ngFor`/`[ngSwitch]` → `@if`/`@for`/`@switch`; Angular Animations → native CSS

---

## Quick Reference Cheatsheet

```typescript
// Bootstrap (main.ts)
bootstrapApplication(AppComponent, appConfig);

// Zoneless — opt-in recommended (app.config.ts)
provideZonelessChangeDetection() // opt-in: not the default

// Component skeleton
@Component({
  imports: [],                          // standalone — list dependencies here
  selector: 'app-my-component',
  template: `...`,
  changeDetection: ChangeDetectionStrategy.OnPush,
  host: {}
})
export class MyComponent {
  // Signals
  myState = signal(initialValue);
  derived = computed(() => this.myState() * 2);

  // Inputs / Outputs
  requiredInput = input.required<string>();
  optionalInput = input(defaultValue);
  myOutput = output<EventType>();

  // DI
  private myService = inject(MyService);

  // Lifecycle (prefer signals/effects over lifecycle hooks)
  constructor() {
    effect(() => { /* side effect on signal changes */ });
    afterNextRender(() => { /* browser-only, one-time setup */ });
    afterRenderEffect(() => { /* browser-only, reactive — runs when deps change */ });
  }
}

// Resource (data fetching)
data = resource({
  params: () => this.paramSignal(),
  loader: async ({ params }) => await fetchSomething(params)
});

// Template
@if (condition()) { ... } @else { ... }
@for (item of items(); track item.id) { ... } @empty { ... }
@switch (val()) { @case ('a') { ... } @default { ... } }
@defer (on viewport) { <heavy-comp /> } @placeholder { <skeleton /> }
```

---

*This skill covers Angular 20+ as of April 2026. Patterns are production-proven and opinionated — where conventions differ from the official Angular style guide, this is noted inline.*
