# Routing — Modern Patterns

## 8. Routing — Modern Patterns

### Route Definitions — Functional

```typescript
// app.routes.ts
import { Routes } from '@angular/router';
import { authGuard } from '@core/guards/auth-guard';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'dashboard',
    pathMatch: 'full'
  },
  {
    path: 'login',
    loadComponent: () => import('./features/auth/ui/login-page').then(m => m.LoginPage)
  },
  {
    path: 'dashboard',
    canActivate: [authGuard],
    loadComponent: () => import('./features/dashboard/ui/dashboard-page').then(m => m.DashboardPage)
  },
  {
    path: 'users',
    canActivate: [authGuard],
    loadChildren: () => import('./features/user-management/user.routes').then(m => m.userRoutes)
  }
];

// features/user-management/user.routes.ts
import { Routes } from '@angular/router';
import { userResolver } from './resolvers/user.resolver';

export const userRoutes: Routes = [
  {
    path: '',
    loadComponent: () => import('./ui/user-list-page').then(m => m.UserListPage)
  },
  {
    path: ':id',
    resolve: { user: userResolver },
    loadComponent: () => import('./ui/user-detail-page').then(m => m.UserDetailPage)
  }
];
```

### Route Params as Inputs (withComponentInputBinding)

```typescript
// Route: /users/:id?tab=profile
// No need to inject ActivatedRoute!
import { Component, input, inject } from '@angular/core';
import { resource } from '@angular/core';
import { firstValueFrom } from 'rxjs';
import { UserApi } from '../data/user-api';

@Component({ ... })
export class UserDetailPage {
  // Automatically bound from route params & query params
  id = input.required<string>();     // from :id
  tab = input('profile');            // from ?tab=

  private api = inject(UserApi);
  user = resource({
    params: () => ({ id: this.id() }),
    loader: ({ params }) => firstValueFrom(this.api.getById(params.id))
  });
}
```

### Functional Resolver

```typescript
// features/user-management/resolvers/user.resolver.ts
import { inject } from '@angular/core';
import { ResolveFn } from '@angular/router';
import { UserApi } from '../data/user-api';
import { User } from '../models/user.model';
import { firstValueFrom } from 'rxjs';

export const userResolver: ResolveFn<User> = (route) => {
  const api = inject(UserApi);
  return firstValueFrom(api.getById(route.paramMap.get('id')!));
};
```

### Functional canDeactivate

```typescript
import { inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { CanDeactivateFn } from '@angular/router';
import { Signal } from '@angular/core';

export const unsavedChangesGuard: CanDeactivateFn<{ hasUnsavedChanges: Signal<boolean> }> =
  (component) => {
    if (!component.hasUnsavedChanges()) return true;
    // SSR guard: confirm() is browser-only
    if (!isPlatformBrowser(inject(PLATFORM_ID))) return true;
    return confirm('You have unsaved changes. Leave anyway?');
  };
```

### Nested Routing with Layout

```typescript
// Layout route with outlet
{
  path: 'admin',
  canActivate: [adminGuard],
  loadComponent: () => import('./core/layout/admin-layout').then(m => m.AdminLayout),
  children: [
    { path: 'users', loadComponent: ... },
    { path: 'settings', loadComponent: ... }
  ]
}

// admin-layout.ts
@Component({
  imports: [RouterOutlet, AdminNav],
  template: `
    <app-admin-nav />
    <main>
      <router-outlet />
    </main>
  `
})
export class AdminLayout {}
```
