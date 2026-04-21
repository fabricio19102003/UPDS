# Migration Notes

## 18. Migration Notes

### NgModules → Standalone (Angular 20: Standalone is default)

NgModules are **NOT deprecated** — they are legacy (still supported) but not recommended for new code. Prefer standalone components for all new Angular 20+ projects.

```typescript
// ⚠️ LEGACY — NgModule (still supported, but avoid in new code)
@NgModule({
  declarations: [UserList],
  imports: [CommonModule],
  exports: [UserList]
})
export class UserModule {}

// ✅ NEW — Standalone component (default in Angular 20)
// No standalone: true needed — it's the default
@Component({
  imports: [UserCard], // direct imports
  selector: 'app-user-list',
  template: `...`
})
export class UserList {}
```

### Zone.js → Zoneless (Opt-In Recommended)

Zoneless is NOT the default in Angular 20. Zone.js remains the default; zoneless is an explicit opt-in. For new projects, opting in is recommended.

```typescript
// ✅ OPT-IN — app.config.ts (recommended for new projects)
import { provideZonelessChangeDetection } from '@angular/core';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZonelessChangeDetection(), // explicit opt-in
    // ... other providers
  ]
};

// If opting in to zoneless, also remove zone.js from polyfills.ts:
// ❌ REMOVE: import 'zone.js';
```

### Constructor DI → inject()

```typescript
// ❌ OLD
export class UserPage {
  constructor(
    private router: Router,
    private userService: UserService,
    private cdr: ChangeDetectorRef
  ) {}
}

// ✅ NEW
export class UserPage {
  private router = inject(Router);
  private userService = inject(UserService);
  // ChangeDetectorRef not needed with zoneless + signals
}
```

### Traditional Control Flow → @if / @for / @switch

```html
<!-- ❌ OLD — structural directives -->
<div *ngIf="user; else loading">{{ user.name }}</div>
<ng-template #loading>Loading...</ng-template>

<li *ngFor="let item of items; trackBy: trackById">{{ item.name }}</li>

<ng-container [ngSwitch]="status">
  <span *ngSwitchCase="'active'">Active</span>
</ng-container>

<!-- ✅ NEW — built-in control flow -->
@if (user(); as u) {
  {{ u.name }}
} @else {
  Loading...
}

@for (item of items(); track item.id) {
  <li>{{ item.name }}</li>
}

@switch (status()) {
  @case ('active') { <span>Active</span> }
}
```

### @ViewChild → viewChild()

```typescript
// ❌ OLD
@ViewChild('canvas') canvas!: ElementRef<HTMLCanvasElement>;
@ViewChild(MyDirective) directive?: MyDirective;

// ✅ NEW
canvas = viewChild.required<ElementRef<HTMLCanvasElement>>('canvas');
directive = viewChild(MyDirective);
```

### @Input / @Output → input() / output()

```typescript
// ❌ OLD
@Input() user!: User;
@Input({ required: true }) title!: string;
@Output() userSelected = new EventEmitter<User>();

// ✅ NEW
user = input.required<User>();
title = input.required<string>();
userSelected = output<User>();
```

### @HostBinding / @HostListener → host: {}

```typescript
// ❌ OLD
@HostBinding('class.active') isActive = false;
@HostListener('click') onClick() { ... }

// ✅ NEW
@Component({
  host: {
    '[class.active]': 'isActive()',
    '(click)': 'handleClick()'
  }
})
export class MyComponent {
  isActive = signal(false);
  handleClick(): void { ... }
}
```

### Angular Animations → Native CSS

```typescript
// ❌ OLD — Angular Animations (legacy, avoid in new code — prefer native CSS)
import { trigger, transition, style, animate } from '@angular/animations';
animations: [
  trigger('fadeIn', [
    transition(':enter', [
      style({ opacity: 0 }),
      animate('300ms ease-in', style({ opacity: 1 }))
    ])
  ])
]

// ✅ NEW — Native CSS (in component styles or global)
// .fade-in {
//   animation: fadeIn 300ms ease-in;
// }
// @keyframes fadeIn {
//   from { opacity: 0; }
//   to { opacity: 1; }
// }
```
