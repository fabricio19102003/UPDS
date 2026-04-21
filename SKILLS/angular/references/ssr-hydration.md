# SSR & Hydration

## 14. SSR & Hydration

### Full Hydration Setup

`provideClientHydration()` belongs in the **shared/client** app config (`app.config.ts`), not in the server config. The server config (`app.config.server.ts`) is for server-rendering providers only.

```typescript
// app.config.ts — shared/client config
import { ApplicationConfig, provideZonelessChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient, withFetch } from '@angular/common/http';
import { provideClientHydration, withEventReplay } from '@angular/platform-browser';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZonelessChangeDetection(),
    provideRouter(routes),
    provideHttpClient(withFetch()),
    provideClientHydration(
      withEventReplay() // replays events that happen before hydration completes
    )
  ]
};

// app.config.server.ts — server-only providers
import { mergeApplicationConfig, ApplicationConfig } from '@angular/core';
import { provideServerRendering } from '@angular/platform-server';
import { appConfig } from './app.config';

const serverConfig: ApplicationConfig = {
  providers: [
    provideServerRendering()
    // provideClientHydration() does NOT belong here — it is in app.config.ts
  ]
};

export const config = mergeApplicationConfig(appConfig, serverConfig);
```

### Incremental Hydration with @defer

To use incremental hydration (`hydrate on ...` triggers), you **must** add `withIncrementalHydration()` to `provideClientHydration()` in your app config:

```typescript
// app.config.ts — required setup for incremental hydration
import { provideClientHydration, withEventReplay, withIncrementalHydration } from '@angular/platform-browser';

providers: [
  provideClientHydration(
    withEventReplay(),
    withIncrementalHydration() // enables hydrate on ... triggers in templates
  )
]
```

Then use `hydrate on ...` triggers in templates:

```html
<!-- Server renders placeholder, client hydrates on viewport -->
@defer (hydrate on viewport) {
  <app-comment-section [postId]="postId()" />
} @placeholder {
  <div class="comment-placeholder">Loading comments...</div>
}

<!-- Hydrate on interaction — island architecture -->
@defer (hydrate on interaction) {
  <app-share-buttons />
}
```

### afterNextRender / afterRenderEffect — Browser-Only Code

Angular 20 provides two render hooks:
- `afterNextRender()` — runs **once** after the first render (one-time initialization)
- `afterRenderEffect()` — runs after **every** render where reactive dependencies change (replaces the old `afterRender` for reactive use cases)

```typescript
import { Component, afterNextRender, afterRenderEffect, signal } from '@angular/core';

@Component({ ... })
export class MapComponent {
  private mapInitialized = signal(false);
  private markers = signal<Marker[]>([]);

  constructor() {
    // Runs only in browser, ONCE after first render — use for one-time setup
    afterNextRender(() => {
      this.initializeMap();
      this.mapInitialized.set(true);
    });

    // Runs after every render when reactive dependencies change
    afterRenderEffect(() => {
      const markers = this.markers(); // reactive dependency
      this.updateMapMarkers(markers);
    });
  }

  // ❌ DON'T — browser APIs in constructor (SSR will crash)
  // window.location.href — crashes on server

  // ✅ DO — use afterNextRender (one-time) or afterRenderEffect (reactive)
}
```

### isPlatformBrowser — Conditional Browser Code

```typescript
import { inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';

export class AnalyticsService {
  private isBrowser = isPlatformBrowser(inject(PLATFORM_ID));

  track(event: string): void {
    if (!this.isBrowser) return; // safe for SSR
    (window as any).gtag('event', event);
  }
}
```
