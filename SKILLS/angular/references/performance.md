# Performance

## 13. Performance

### Zoneless Change Detection — Bootstrap (Opt-In Recommended)

Zoneless is an **opt-in** feature in Angular 20 — Zone.js remains the default unless you explicitly add `provideZonelessChangeDetection()`. For new projects, opting in to zoneless is the recommended pattern.

Declare `provideZonelessChangeDetection()` in **one place only** — `app.config.ts`. `main.ts` simply passes `appConfig` to `bootstrapApplication` without re-adding providers.

```typescript
// app.config.ts — declare provideZonelessChangeDetection() HERE (single source of truth)
import { ApplicationConfig, provideZonelessChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZonelessChangeDetection(), // ← opt-in: replaces zone.js entirely
    provideRouter(routes)
    // ... other providers
  ]
};

// main.ts — just pass appConfig; do NOT re-add provideZonelessChangeDetection() here
import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from './app/app';
import { appConfig } from './app/app.config';

bootstrapApplication(AppComponent, appConfig);
```

### Lazy Loading Everything

```typescript
// ✅ Route-level code splitting
{
  path: 'reports',
  loadComponent: () => import('./features/reports/ui/reports-page').then(m => m.ReportsPage)
}

// ✅ Lazy load heavy libraries
async loadChart() {
  const { Chart } = await import('chart.js');
  // use Chart
}
```

### @defer for Heavy Components

```html
<!-- Component loads when it enters viewport -->
@defer (on viewport; prefetch on idle) {
  <app-complex-dashboard [data]="data()" />
} @placeholder (minimum 200ms) {
  <app-skeleton-loader rows="5" />
} @loading {
  <app-spinner size="lg" />
}
```

### NgOptimizedImage

```typescript
import { NgOptimizedImage } from '@angular/common';

@Component({
  imports: [NgOptimizedImage],
  template: `
    <!-- Automatically: lazy loading, srcset, width/height -->
    <img ngSrc="/assets/avatar.jpg" width="64" height="64" alt="User avatar" />

    <!-- Priority image (LCP) — preloaded -->
    <img ngSrc="/assets/hero.jpg" width="1200" height="600" priority alt="Hero" />

    <!-- Fill mode for responsive containers -->
    <div style="position: relative; height: 300px">
      <img ngSrc="/assets/banner.jpg" fill alt="Banner" />
    </div>
  `
})
export class HeroSection {}
```

### Virtual Scrolling

```typescript
import { ScrollingModule } from '@angular/cdk/scrolling';

@Component({
  imports: [ScrollingModule],
  template: `
    <cdk-virtual-scroll-viewport itemSize="56" style="height: 600px">
      <div *cdkVirtualFor="let item of items; trackBy: trackByFn" class="item">
        {{ item.name }}
      </div>
    </cdk-virtual-scroll-viewport>
  `
})
export class LargeListPage {
  items = input.required<ListItem[]>();
  trackByFn = (_: number, item: ListItem) => item.id;
}
```

### Bundle Budgets — angular.json

```json
{
  "budgets": [
    {
      "type": "initial",
      "maximumWarning": "500kb",
      "maximumError": "1mb"
    },
    {
      "type": "anyComponentStyle",
      "maximumWarning": "2kb",
      "maximumError": "4kb"
    }
  ]
}
```

### Tree-Shaking Practices

```typescript
// ✅ DO — import specific operators
import { map, filter, switchMap } from 'rxjs/operators';

// ❌ DON'T — import entire library
import * as rxjs from 'rxjs';

// ✅ DO — providedIn: 'root' (tree-shakable)
@Injectable({ providedIn: 'root' })
export class UserApi {}

// ✅ DO — standalone components (no NgModule overhead)
// (standalone is default in Angular 20 — no action needed)
```
