# Build & Tooling

## 17. Build & Tooling

### esbuild + Vite (Default in Angular 20)

```json
// angular.json — builder is @angular-devkit/build-angular:application
{
  "architect": {
    "build": {
      "builder": "@angular-devkit/build-angular:application",
      "options": {
        "outputPath": "dist/my-app",
        "index": "src/index.html",
        "browser": "src/main.ts",
        "polyfills": [],
        "tsConfig": "tsconfig.app.json",
        "assets": ["src/favicon.ico", "src/assets"],
        "styles": ["src/styles.scss"],
        "scripts": []
      }
    }
  }
}
```

### HMR — Hot Module Replacement

```bash
# Angular 20 — HMR enabled by default in dev
ng serve

# Or explicitly:
ng serve --hmr
```

### Bundle Analysis

```bash
# Install
npm install --save-dev webpack-bundle-analyzer

# Generate stats
ng build --stats-json

# Analyze
npx webpack-bundle-analyzer dist/my-app/browser/stats.json
```

### ESLint Configuration (Flat Config, ESLint 9+)

```javascript
// eslint.config.mjs
import angular from 'angular-eslint';
import tsEslint from 'typescript-eslint';

export default tsEslint.config(
  {
    files: ['**/*.ts'],
    extends: [
      ...tsEslint.configs.recommended,
      ...angular.configs.tsRecommended
    ],
    processor: angular.processInlineTemplates,
    rules: {
      '@angular-eslint/directive-selector': ['error', { type: 'attribute', prefix: 'app', style: 'camelCase' }],
      '@angular-eslint/component-selector': ['error', { type: 'element', prefix: 'app', style: 'kebab-case' }],
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/explicit-function-return-type': 'error'
    }
  },
  {
    files: ['**/*.html'],
    extends: [...angular.configs.templateRecommended, ...angular.configs.templateAccessibility],
    rules: {}
  }
);
```
