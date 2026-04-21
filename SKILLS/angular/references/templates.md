# Template Syntax — Modern Control Flow

## 10. Template Syntax — Modern Control Flow

### @if / @else if / @else

```html
@if (user.isAdmin()) {
  <app-admin-panel />
} @else if (user.isModerator()) {
  <app-moderator-panel />
} @else {
  <app-user-panel />
}
```

### @for with track (ALWAYS require track)

```html
<!-- ✅ track by unique ID -->
@for (user of users(); track user.id) {
  <app-user-card [user]="user" />
} @empty {
  <p class="empty-state">No users found.</p>
}

<!-- ✅ track by index only when items have no stable ID -->
@for (item of temporaryItems; track $index) {
  <span>{{ item }}</span>
}

<!-- ❌ NEVER omit track — causes full DOM re-render -->
@for (user of users()) { ... }
```

### @switch / @case / @default

```html
@switch (status()) {
  @case ('active') { <app-badge color="green">Active</app-badge> }
  @case ('pending') { <app-badge color="yellow">Pending</app-badge> }
  @case ('inactive') { <app-badge color="red">Inactive</app-badge> }
  @default { <app-badge>Unknown</app-badge> }
}
```

### @defer — Progressive Loading

```html
<!-- Basic defer: loads when viewport intersection -->
@defer (on viewport) {
  <app-heavy-chart [data]="chartData()" />
} @placeholder {
  <div class="chart-placeholder" style="height: 300px"></div>
} @loading (minimum 300ms) {
  <app-spinner />
} @error {
  <p>Failed to load chart.</p>
}

<!-- Defer with multiple triggers -->
@defer (on idle; on timer(2s)) {
  <app-recommendation-panel />
}

<!-- Defer on interaction -->
@defer (on interaction(toggleBtn)) {
  <app-details-panel />
}
<button #toggleBtn>Show Details</button>

<!-- Prefetch separately from render -->
@defer (on viewport; prefetch on idle) {
  <app-analytics-widget />
}
```

### Angular 20 Template Expressions

```typescript
// Angular 20 supports new operators in templates:

// Exponentiation: **
{{ 2 ** 10 }}  // 1024

// Nullish coalescing
{{ user()?.name ?? 'Anonymous' }}

// Optional chaining
{{ user()?.profile?.avatar }}

// Ternary
{{ isAdmin() ? 'Admin' : 'User' }}

// Template literals (via interpolation)
[title]="'Hello ' + userName()"

// ❌ NOTE: The `in` operator is NOT supported in Angular templates.
// Use a method or computed signal instead:
// ✅ @if (hasRole('admin')) { <app-admin-menu /> }
// ✅ protected hasRole = (role: string) => this.userRoles().includes(role);
```

### Pipes

```html
<!-- Built-in pipes work with signals -->
{{ amount() | currency:'USD' }}
{{ date() | date:'mediumDate' }}
{{ name() | uppercase }}
{{ items() | slice:0:5 }}

<!-- Async pipe for Observables (prefer resource() over async pipe) -->
{{ user$ | async | json }}
```
