# Project Architecture & Atomic Design

## 2. Project Architecture

### Feature-Based Folder Structure (Screaming Architecture)

```
src/
├── shared/
│   ├── ui/                    # Reusable UI components (atoms, molecules)
│   │   ├── button.ts
│   │   ├── modal.ts
│   │   └── index.ts           # Barrel export
│   ├── utils/                 # Pure utility functions
│   │   ├── date-helpers.ts
│   │   └── validators.ts
│   └── data/                  # Global services (auth, api base)
│       ├── auth.ts
│       └── api.ts
├── features/
│   ├── user-management/
│   │   ├── ui/
│   │   │   ├── user-list.ts
│   │   │   └── user-form.ts
│   │   ├── data/
│   │   │   └── user-api.ts
│   │   └── utils/
│   │       └── user-helpers.ts
│   └── dashboard/
│       ├── ui/
│       └── data/
└── core/
    ├── layout/
    │   ├── header.ts
    │   └── footer.ts
    └── guards/
        └── auth-guard.ts
```

### Barrel Exports Strategy

```typescript
// shared/ui/index.ts
export { Button } from './button';
export { Modal } from './modal';
export { Input } from './input';

// features/user-management/index.ts — only export public surface
export { UserList } from './ui/user-list';
export { UserForm } from './ui/user-form';
// ❌ Don't export internal implementation details
```

### Path Aliases — tsconfig.json

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@shared/*": ["src/shared/*"],
      "@features/*": ["src/features/*"],
      "@core/*": ["src/core/*"]
    },
    "strict": true,
    "strictNullChecks": true,
    "noImplicitAny": true
  }
}
```

### Angular.json Path Alias Support

```json
// angular.json — inside architect.build.options
{
  "tsConfig": "tsconfig.app.json"
}
```

### Usage

```typescript
// ✅ DO — use path aliases
import { Button } from '@shared/ui';
import { UserList } from '@features/user-management';
import { AuthProvider } from '@shared/data/auth';

// ❌ DON'T — relative hell
import { Button } from '../../../shared/ui/button';
```

---

## 3. Atomic Design in Angular

### Hierarchy

| Level | Description | Angular Mapping |
|-------|-------------|----------------|
| **Atom** | Smallest UI unit, no dependencies | `Button`, `Input`, `Badge`, `Icon` |
| **Molecule** | Combines 2–3 atoms | `LabelInput`, `SearchBar`, `CardHeader` |
| **Organism** | Complex UI section | `UserCard`, `NavigationMenu`, `DataTable` |
| **Template** | Page layout shell | `DashboardLayout`, `AuthLayout` |
| **Page** | Full routable view | `DashboardPage`, `UserDetailPage` |

### Atom — Button

```typescript
// shared/ui/button.ts
// NOTE: Prefer using a native <button> element internally for full
// keyboard activation semantics. If using host role="button", you
// MUST handle Enter and Space keyboard events explicitly.
import { Component, input, output, ChangeDetectionStrategy } from '@angular/core';

@Component({
  selector: 'app-button',
  // Use a native <button> to get keyboard activation for free
  template: `
    <button
      [type]="type()"
      [disabled]="disabled() || null"
      [attr.aria-label]="ariaLabel() || null"
      [class.primary]="variant() === 'primary'"
      [class.danger]="variant() === 'danger'"
      (click)="handleClick($event)"
    >
      <ng-content />
    </button>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class Button {
  variant = input<'primary' | 'secondary' | 'danger'>('primary');
  disabled = input(false);
  ariaLabel = input<string>();
  type = input<'button' | 'submit' | 'reset'>('button');

  clicked = output<void>();

  handleClick(event: Event): void {
    if (!this.disabled()) {
      this.clicked.emit();
    }
  }
}
```

### Molecule — LabelInput

```typescript
// shared/ui/label-input.ts
import { Component, input, ChangeDetectionStrategy } from '@angular/core';
import { Input } from './input';

@Component({
  imports: [Input],
  selector: 'app-label-input',
  template: `
    <div class="field">
      <label [for]="inputId()">{{ labelText() }}</label>
      <app-input [inputId]="inputId()" [placeholder]="placeholder()" />
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LabelInput {
  inputId = input.required<string>();
  labelText = input.required<string>();
  placeholder = input('');
}
```

### Organism — UserCard

```typescript
// features/user-management/ui/user-card.ts
import { Component, input, output, ChangeDetectionStrategy } from '@angular/core';
import { Button, Badge } from '@shared/ui';
import { User } from '../models/user.model';

@Component({
  imports: [Button, Badge],
  selector: 'app-user-card',
  template: `
    <article class="user-card">
      <app-badge [status]="user().status" />
      <h3>{{ user().name }}</h3>
      <p>{{ user().email }}</p>
      <app-button variant="primary" (clicked)="selectUser.emit(user())">
        View Profile
      </app-button>
    </article>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class UserCard {
  user = input.required<User>();
  selectUser = output<User>();
}
```

### Page — Container (routable)

```typescript
// features/user-management/ui/user-management-page.ts
import { Component, inject, ChangeDetectionStrategy } from '@angular/core';
import { UserList } from './user-list';
import { UserApi } from '../data/user-api';

@Component({
  imports: [UserList],
  selector: 'app-user-management-page',
  template: `
    @if (api.users.isLoading()) {
      <p>Loading...</p>
    } @else if (api.users.error()) {
      <p>Error: {{ api.users.error() }}</p>
    } @else {
      <app-user-list [users]="api.users.value() ?? []" />
    }
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class UserManagementPage {
  protected api = inject(UserApi);
}
```
