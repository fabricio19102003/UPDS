# Component Patterns

## 4. Component Patterns

### The Golden Rules

- **ALWAYS** use `ChangeDetectionStrategy.OnPush`
- **ALWAYS** use standalone components (no `NgModule`)
- **ALWAYS** use `input()` / `output()` — never `@Input()` / `@Output()`
- **ALWAYS** use `inject()` — never constructor injection
- **ALWAYS** use `host: {}` metadata — never `@HostBinding` / `@HostListener`

### Presentational Component

```typescript
// features/user-management/ui/user-list.ts
import {
  Component, input, output, ChangeDetectionStrategy
} from '@angular/core';
import { User } from '../models/user.model';

@Component({
  selector: 'app-user-list',
  template: `
    @for (user of users(); track user.id) {
      <div class="user-item" (click)="userSelected.emit(user)">
        <span>{{ user.name }}</span>
        <span>{{ user.email }}</span>
      </div>
    } @empty {
      <p>No users found.</p>
    }
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class UserList {
  // INPUTS — signal-based
  users = input.required<User[]>();
  selectedId = input<string | null>(null);

  // OUTPUTS — signal-based
  userSelected = output<User>();
}
```

### Container Component

```typescript
// features/user-management/ui/user-management-container.ts
import { Component, inject, signal, ChangeDetectionStrategy } from '@angular/core';
import { Router } from '@angular/router';
import { UserList } from './user-list';
import { UserApi } from '../data/user-api';
import { User } from '../models/user.model';

@Component({
  imports: [UserList],
  selector: 'app-user-management-container',
  template: `
    <app-user-list
      [users]="api.users.value() ?? []"
      [selectedId]="selectedUserId()"
      (userSelected)="navigateToUser($event)"
    />
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class UserManagementContainer {
  private api = inject(UserApi);
  private router = inject(Router);

  protected selectedUserId = signal<string | null>(null);

  navigateToUser(user: User): void {
    this.selectedUserId.set(user.id);
    this.router.navigate(['/users', user.id]);
  }
}
```

### Business Logic vs Application Logic

```typescript
// ✅ Business Logic — WHY things work this way (domain rules)
// e.g., "A user cannot be deleted if they have active orders"
canDeleteUser(user: User): boolean {
  return user.activeOrders === 0 && user.role !== 'admin';
}

// ✅ Application Logic — HOW the app responds (technical needs)
// e.g., "Show modal, then navigate after confirmation"
async deleteUserWithConfirmation(user: User): Promise<void> {
  const confirmed = await this.modal.confirm(`Delete ${user.name}?`);
  if (confirmed) {
    await this.userApi.delete(user.id);
    this.router.navigate(['/users']);
  }
}
```

### Host Metadata

```typescript
@Component({
  selector: 'app-input',
  template: `<input [id]="inputId()" [placeholder]="placeholder()" />`,
  host: {
    // Classes
    '[class.focused]': 'isFocused()',
    '[class.error]': 'hasError()',
    // Events
    '(focusin)': 'isFocused.set(true)',
    '(focusout)': 'isFocused.set(false)',
    // Attributes
    '[attr.aria-label]': 'ariaLabel()',
    '[attr.aria-invalid]': 'hasError()',
    // Static
    'role': 'textbox'
  },
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class Input {
  inputId = input.required<string>();
  placeholder = input('');
  ariaLabel = input<string>();
  hasError = input(false);

  protected isFocused = signal(false);
}
```

### Content Projection

```typescript
// Card with named slots
@Component({
  selector: 'app-card',
  template: `
    <div class="card">
      <div class="card-header">
        <ng-content select="[slot=header]" />
      </div>
      <div class="card-body">
        <ng-content />
      </div>
      <div class="card-footer">
        <ng-content select="[slot=footer]" />
      </div>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class Card {}

// Usage
@Component({
  imports: [Card],
  template: `
    <app-card>
      <h2 slot="header">User Profile</h2>
      <p>Main content goes here</p>
      <app-button slot="footer">Save</app-button>
    </app-card>
  `
})
export class UserProfile {}
```

### ViewChild / ContentChild — Signal-Based

```typescript
import { Component, viewChild, contentChild, ElementRef, AfterViewInit } from '@angular/core';

@Component({ ... })
export class MyComponent implements AfterViewInit {
  // Signal-based queries (Angular 17+)
  canvas = viewChild.required<ElementRef<HTMLCanvasElement>>('canvas');
  header = contentChild<ElementRef>('header');

  ngAfterViewInit(): void {
    // Access via signal call
    const ctx = this.canvas().nativeElement.getContext('2d');
  }
}
```
