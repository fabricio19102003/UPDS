# Security

## 15. Security

### Angular Built-in Sanitization

```typescript
// Angular automatically sanitizes bound values
// ✅ Safe — Angular sanitizes HTML
[innerHTML]="userBio"

// ✅ Safe — Angular sanitizes URLs
[href]="userProfileUrl"

// ✅ Use DomSanitizer explicitly — BUT always validate/allowlist the URL first
// NEVER call bypassSecurityTrustResourceUrl on unvalidated user input
import { DomSanitizer } from '@angular/platform-browser';
import { computed, inject, input } from '@angular/core';

// Allowlist of trusted origins
const TRUSTED_ORIGINS = ['https://www.youtube.com', 'https://player.vimeo.com'];

function isTrustedEmbedUrl(url: string): boolean {
  try {
    const parsed = new URL(url);
    return TRUSTED_ORIGINS.some(origin => parsed.origin === origin);
  } catch {
    return false;
  }
}

@Component({ ... })
export class EmbedComponent {
  private sanitizer = inject(DomSanitizer);
  private rawUrl = input.required<string>();

  // ✅ Validate BEFORE bypassing sanitization
  safeUrl = computed(() => {
    const url = this.rawUrl();
    if (!isTrustedEmbedUrl(url)) {
      throw new Error(`Untrusted embed URL blocked: ${url}`);
    }
    return this.sanitizer.bypassSecurityTrustResourceUrl(url);
  });
}
```

### CSP — Content Security Policy

```html
<!-- index.html — strict CSP -->
<meta http-equiv="Content-Security-Policy"
  content="
    default-src 'self';
    script-src 'self' 'nonce-{server-generated-nonce}';
    style-src 'self' 'unsafe-inline';
    img-src 'self' data: https:;
    connect-src 'self' https://api.myapp.com;
    font-src 'self';
    object-src 'none';
    base-uri 'self';
    frame-ancestors 'none'
  " />
```

### Trusted Types

```typescript
// angular.json — enable Trusted Types
{
  "projects": {
    "my-app": {
      "architect": {
        "build": {
          "options": {
            "trustedTypes": true
          }
        }
      }
    }
  }
}
```

### JWT + Refresh Token Pattern

**Recommended approach**: Store tokens in **httpOnly cookies** (server-managed) or **in-memory only** to protect against XSS attacks. `localStorage` is vulnerable to XSS — any injected script can read it. Use `localStorage` only when you have an explicit business reason and have hardened your CSP.

```typescript
@Injectable({ providedIn: 'root' })
export class AuthProvider {
  // ✅ RECOMMENDED: Keep access token in-memory only (XSS-safe)
  // Refresh token is stored in httpOnly cookie by the server
  private _token = signal<string | null>(null);
  readonly token = this._token.asReadonly();
  readonly isAuthenticated = computed(() => !!this._token());

  private http = inject(HttpClient);
  private router = inject(Router);

  async login(email: string, password: string): Promise<void> {
    const { accessToken } = await firstValueFrom(
      this.http.post<{ accessToken: string }>('/api/auth/login', { email, password })
      // Server sets refresh token as httpOnly cookie automatically
    );
    // Keep access token in-memory — NOT in localStorage
    this._token.set(accessToken);
  }

  async refreshTokens(): Promise<void> {
    try {
      // Refresh token is sent automatically via httpOnly cookie
      const { accessToken } = await firstValueFrom(
        this.http.post<{ accessToken: string }>('/api/auth/refresh', {}, { withCredentials: true })
      );
      this._token.set(accessToken);
    } catch {
      this.logout();
    }
  }

  logout(): void {
    this._token.set(null);
    this.router.navigate(['/login']);
  }
}

// ⚠️ TRADEOFF — localStorage (only if explicitly required):
// - Pro: survives page refresh without a server roundtrip
// - Con: XSS-vulnerable — any injected script can steal the token
// - Mitigation: strict CSP, input sanitization, no third-party scripts
// private _token = signal<string | null>(localStorage.getItem('access_token'));
// localStorage.setItem('access_token', accessToken); // in login()
// localStorage.removeItem('access_token'); // in logout()
```

### No Secrets in Code

```typescript
// ✅ DO — environment variables via server/build config
const apiKey = environment.stripePublicKey; // public key only

// ❌ DON'T — hardcode secrets
const secretKey = 'sk_live_abc123'; // NEVER in frontend code

// ❌ DON'T — access secrets via environment
const dbPassword = process.env['DB_PASSWORD']; // not available in browser
```
