# Dependency Injection — Modern Style

## 7. Dependency Injection — Modern Style

### inject() — Always (No Constructor Injection)

```typescript
// ✅ DO — inject() function
import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { UserApi } from './user-api';

export class UserPage {
  private router = inject(Router);
  private userApi = inject(UserApi);
}

// ❌ DON'T — constructor injection (old style)
export class UserPage {
  constructor(private router: Router, private userApi: UserApi) {}
}
```

### Functional Providers

```typescript
// app.config.ts
import { ApplicationConfig, provideZonelessChangeDetection } from '@angular/core';
import { provideRouter, withComponentInputBinding, withPreloading, PreloadAllModules } from '@angular/router';
import { provideHttpClient, withInterceptors, withFetch } from '@angular/common/http';

import { routes } from './app.routes';
import { authInterceptor } from '@core/interceptors/auth';
import { errorInterceptor } from '@core/interceptors/error';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZonelessChangeDetection(),
    provideRouter(routes,
      withComponentInputBinding(),
      withPreloading(PreloadAllModules)
    ),
    provideHttpClient(
      withFetch(),
      withInterceptors([authInterceptor, errorInterceptor])
    )
  ]
};
```

### InjectionToken — Configuration

```typescript
// core/tokens/api-config.token.ts
import { InjectionToken } from '@angular/core';

export interface ApiConfig {
  baseUrl: string;
  timeout: number;
}

export const API_CONFIG = new InjectionToken<ApiConfig>('API_CONFIG', {
  factory: () => ({ baseUrl: '/api', timeout: 5000 })
});

// Provide in app.config.ts
{
  provide: API_CONFIG,
  useValue: { baseUrl: environment.apiUrl, timeout: 10000 }
}

// Consume
export class UserApi {
  private config = inject(API_CONFIG);
  private baseUrl = this.config.baseUrl;
}
```

### Multi-Providers — Plugin Architecture

```typescript
// Plugin token
export const VALIDATION_RULES = new InjectionToken<ValidationRule[]>('VALIDATION_RULES');

// Each feature registers its rules
{ provide: VALIDATION_RULES, useValue: emailRules, multi: true },
{ provide: VALIDATION_RULES, useValue: passwordRules, multi: true },

// Consumer gets all of them
export class FormValidator {
  private rules = inject(VALIDATION_RULES).flat();
}
```

### Functional Guards

```typescript
// core/guards/auth-guard.ts
import { inject } from '@angular/core';
import { Router, CanActivateFn } from '@angular/router';
import { AuthProvider } from '@shared/data/auth';

export const authGuard: CanActivateFn = (route, state) => {
  const auth = inject(AuthProvider);
  const router = inject(Router);

  if (auth.isAuthenticated()) return true;

  return router.createUrlTree(['/login'], {
    queryParams: { returnUrl: state.url }
  });
};
```

### Functional Interceptors

```typescript
// core/interceptors/auth.ts
import { inject } from '@angular/core';
import { HttpInterceptorFn } from '@angular/common/http';
import { AuthProvider } from '@shared/data/auth';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const auth = inject(AuthProvider);
  const token = auth.token();

  if (!token) return next(req);

  return next(req.clone({
    setHeaders: { Authorization: `Bearer ${token}` }
  }));
};
```

### Environment-Specific Providers

```typescript
// environments/environment.ts
export const environment = {
  production: false,
  apiUrl: 'http://localhost:3000',
  enableDevTools: true
};

// environments/environment.prod.ts
export const environment = {
  production: true,
  apiUrl: 'https://api.myapp.com',
  enableDevTools: false
};
```
