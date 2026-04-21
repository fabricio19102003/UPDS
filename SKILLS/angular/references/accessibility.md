# Accessibility

## 16. Accessibility

### CDK a11y Module

```typescript
import { A11yModule, FocusTrap, LiveAnnouncer } from '@angular/cdk/a11y';

@Component({
  imports: [A11yModule],
  template: `
    <div cdkTrapFocus [cdkTrapFocusAutoCapture]="true">
      <h2>Modal Title</h2>
      <p>Modal content</p>
      <button (click)="close()">Close</button>
    </div>
  `
})
export class Modal {
  private announcer = inject(LiveAnnouncer);

  open(): void {
    this.announcer.announce('Modal opened', 'polite');
  }
}
```

### ARIA Patterns

```typescript
@Component({
  selector: 'app-expandable',
  template: `
    <button
      [attr.aria-expanded]="isExpanded()"
      [attr.aria-controls]="panelId()"
      (click)="toggle()"
    >
      {{ label() }}
    </button>
    <div
      [id]="panelId()"
      [hidden]="!isExpanded()"
      role="region"
    >
      <ng-content />
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class Expandable {
  label = input.required<string>();
  panelId = input.required<string>();
  isExpanded = signal(false);

  toggle(): void { this.isExpanded.update(v => !v); }
}
```

### Keyboard Navigation

`FocusKeyManager` is NOT injectable via `inject()`. It must be constructed manually from a query of focusable items using `viewChildren()`. See the CDK `FocusKeyManager` API.

```typescript
import {
  Component, viewChildren, input, effect, signal, ChangeDetectionStrategy
} from '@angular/core';
import { FocusKeyManager } from '@angular/cdk/a11y';
import { DropdownItem } from './dropdown-item'; // must implement Focusable

@Component({
  imports: [DropdownItem],
  selector: 'app-dropdown',
  template: `
    @for (item of items(); track item.id) {
      <app-dropdown-item [item]="item" />
    }
  `,
  host: {
    '(keydown.arrowUp)': 'focusPrevious($event)',
    '(keydown.arrowDown)': 'focusNext($event)',
    '(keydown.enter)': 'selectCurrent()',
    '(keydown.escape)': 'close()'
  },
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class Dropdown {
  items = input.required<DropdownData[]>();

  // Construct FocusKeyManager from viewChildren — NOT from inject()
  private itemComponents = viewChildren(DropdownItem);
  private focusManager: FocusKeyManager<DropdownItem> | null = null;

  constructor() {
    // Rebuild FocusKeyManager reactively whenever itemComponents() changes
    effect(() => {
      this.focusManager = new FocusKeyManager(this.itemComponents())
        .withWrap();
        // Note: add .withTypeAhead() only if DropdownItem implements FocusableOption
        // with a getLabel(): string method — required for typeahead to work
    });
  }

  focusPrevious(event: KeyboardEvent): void {
    event.preventDefault();
    this.focusManager?.setPreviousItemActive();
  }

  focusNext(event: KeyboardEvent): void {
    event.preventDefault();
    this.focusManager?.setNextItemActive();
  }

  selectCurrent(): void { /* handle selection */ }
  close(): void { /* handle close */ }
}
```
