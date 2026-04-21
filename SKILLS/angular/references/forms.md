# Forms — Signal-Era Patterns

## 9. Forms — Signal-Era Patterns

### Reactive Forms with Strict Typing

```typescript
import { Component, inject, ChangeDetectionStrategy } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';

interface LoginForm {
  email: string;
  password: string;
  rememberMe: boolean;
}

@Component({
  imports: [ReactiveFormsModule],
  template: `
    <form [formGroup]="form" (ngSubmit)="submitForm()">
      <label for="email">Email</label>
      <input id="email" formControlName="email" type="email" />
      @if (form.controls.email.invalid && form.controls.email.touched) {
        <span class="error">Valid email required</span>
      }
      <label for="password">Password</label>
      <input id="password" formControlName="password" type="password" />
      <label>
        <input formControlName="rememberMe" type="checkbox" />
        Remember me
      </label>
      <button type="submit" [disabled]="form.invalid">Login</button>
    </form>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LoginForm {
  private fb = inject(FormBuilder);

  form = this.fb.nonNullable.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(8)]],
    rememberMe: [false]
  });

  submitForm(): void {
    if (this.form.invalid) return;
    const value = this.form.getRawValue(); // fully typed
    console.log(value.email, value.password);
  }
}
```

### Custom Validators

```typescript
// shared/utils/validators.ts
import { AbstractControl, ValidationErrors, ValidatorFn, AsyncValidatorFn } from '@angular/forms';
import { Observable, of } from 'rxjs';
import { map, debounceTime, switchMap, first } from 'rxjs';

export function passwordStrength(): ValidatorFn {
  return (control: AbstractControl): ValidationErrors | null => {
    const value: string = control.value ?? '';
    const hasUpper = /[A-Z]/.test(value);
    const hasNumber = /\d/.test(value);
    const hasSpecial = /[!@#$%^&*]/.test(value);

    if (hasUpper && hasNumber && hasSpecial) return null;
    return {
      passwordStrength: {
        hasUpper,
        hasNumber,
        hasSpecial
      }
    };
  };
}

// Async validator — accepts an abstract check function so shared/ never imports from @features/
// Usage: uniqueEmailValidator((email) => userApi.checkEmailExists(email))
export function uniqueEmailValidator(checkFn: (email: string) => Observable<boolean>): AsyncValidatorFn {
  return (control: AbstractControl) => {
    if (!control.value) return of(null); // short-circuit on empty value
    return checkFn(control.value).pipe(
      map(exists => exists ? { emailTaken: true } : null)
    );
  };
}
```

### Custom Form Control (ControlValueAccessor)

```typescript
import {
  Component, ElementRef, forwardRef, inject, signal, ChangeDetectionStrategy
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'app-star-rating',
  template: `
    @for (star of stars; track star) {
      <button
        type="button"
        (click)="setValue(star)"
        [class.filled]="star <= value()"
        [disabled]="isDisabled()"
      >★</button>
    }
  `,
  // (focusout) on the HOST wrapper — fires only when focus leaves the entire control,
  // not when it moves between individual star buttons
  host: { '(focusout)': 'onFocusOut($event)' },
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => StarRating),
    multi: true
  }],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class StarRating implements ControlValueAccessor {
  stars = [1, 2, 3, 4, 5];
  value = signal(0);
  isDisabled = signal(false);

  private elementRef = inject(ElementRef);
  private onChange: (v: number) => void = () => {};
  onTouched: () => void = () => {};

  setValue(v: number): void {
    this.value.set(v);
    this.onChange(v);
  }

  /** Only mark touched when focus leaves the ENTIRE control (not between stars). */
  onFocusOut(event: FocusEvent): void {
    if (!this.elementRef.nativeElement.contains(event.relatedTarget)) {
      this.onTouched();
    }
  }

  writeValue(v: number): void { this.value.set(v ?? 0); }
  registerOnChange(fn: (v: number) => void): void { this.onChange = fn; }
  registerOnTouched(fn: () => void): void { this.onTouched = fn; }
  setDisabledState(disabled: boolean): void { this.isDisabled.set(disabled); }
}
```

### Dynamic Forms

```typescript
@Component({
  imports: [ReactiveFormsModule, NgFor],
  template: `
    <form [formGroup]="form">
      <div formArrayName="addresses">
        @for (addr of addresses.controls; track $index) {
          <div [formGroupName]="$index">
            <input formControlName="street" placeholder="Street" />
            <input formControlName="city" placeholder="City" />
            <button type="button" (click)="removeAddress($index)">Remove</button>
          </div>
        }
      </div>
      <button type="button" (click)="addAddress()">Add Address</button>
    </form>
  `
})
export class DynamicAddressForm {
  private fb = inject(FormBuilder);

  form = this.fb.group({
    addresses: this.fb.array([this.createAddress()])
  });

  get addresses() { return this.form.controls.addresses; }

  createAddress() {
    return this.fb.nonNullable.group({
      street: ['', Validators.required],
      city: ['', Validators.required]
    });
  }

  addAddress(): void { this.addresses.push(this.createAddress()); }
  removeAddress(i: number): void { this.addresses.removeAt(i); }
}
```
