# UPDS Gradients, Effects & Animations

Complete reference for all visual effects in the UPDS Design System.
Load this file when implementing glassmorphism surfaces, gradient
fills, decorative elements, or animations.

---

## Glassmorphism

The signature visual technique of the UPDS system. Every card,
container, and interactive surface uses this pattern.

### Standard Glass Surface

```
bg-white/80 backdrop-blur-xl border border-white/50
rounded-2xl sm:rounded-3xl
shadow-[0_8px_30px_rgb(0,0,0,0.08)]
```

### Glass with Hover Enhancement

```
bg-white/80 backdrop-blur-xl border border-white/50
rounded-2xl sm:rounded-3xl
shadow-[0_8px_30px_rgb(0,0,0,0.08)]
hover:shadow-[0_8px_30px_rgb(0,119,230,0.12)]
transition-all duration-300
```

### Glass with Focus Ring (Inputs)

```
bg-white/80 backdrop-blur-2xl border border-white/80
rounded-2xl sm:rounded-3xl
shadow-[0_8px_30px_rgb(0,0,0,0.08)]
focus-within:ring-4 focus-within:ring-sky-500/20
focus-within:shadow-[0_8px_30px_rgb(0,119,230,0.15)]
transition-all duration-300
```

### Light Glass (Empty State)

```
bg-white/60 backdrop-blur-xl
border-2 border-dashed border-slate-300
rounded-3xl
```

### Rules

- ALWAYS pair translucent bg (`/80`, `/60`) with `backdrop-blur-*`
- NEVER use `bg-white` (fully opaque) for cards — it kills the glass effect
- Minimum blur: `backdrop-blur-xl` for cards, `backdrop-blur-2xl` for inputs
- The custom shadow `0_8px_30px_rgb(0,0,0,0.08)` is mandatory on glass
  surfaces — do NOT substitute with plain `shadow-lg`

---

## Gradients

### Page Background

```
bg-gradient-to-br from-slate-50 via-white to-sky-50
```

This is the ONLY acceptable page background. Do not use plain
`bg-white` or `bg-gray-50`.

### Hero Text Gradient

```html
<span class="bg-gradient-to-r from-blue-900 via-blue-700 to-sky-400
             bg-clip-text text-transparent">
```

Both `bg-clip-text` AND `text-transparent` are required.
This gradient defines the UPDS brand identity in hero contexts.

### CTA Button Gradient

```
bg-gradient-to-r from-blue-900 to-blue-800
```

Hover state:
```
hover:from-blue-800 hover:to-blue-700
```

### Advisory Card Gradient

```
bg-gradient-to-br from-amber-50/90 to-yellow-50/50
```

### Brand Icon Gradient

```
bg-gradient-to-br from-blue-900 to-blue-700
```

Used for the square logo mark in the header.

### Instagram Social Gradient (hover only)

```
hover:bg-gradient-to-tr hover:from-yellow-500
hover:via-pink-500 hover:to-purple-600
```

### Skeleton Shimmer Gradient (CSS)

```css
background: linear-gradient(90deg, #f1f5f9 25%, #e2e8f0 50%, #f1f5f9 75%);
background-size: 200% 100%;
```

### Advisory Left Accent Gradient

```
bg-gradient-to-b from-amber-400 to-yellow-500
```

Applied to a `w-1.5` vertical strip on the left side of advisory cards.

---

## Shadows

### Custom Shadows (use via arbitrary values)

| Name         | Tailwind Class                                  | When to use              |
|--------------|------------------------------------------------|--------------------------|
| Glass        | `shadow-[0_8px_30px_rgb(0,0,0,0.08)]`          | All glass surfaces       |
| Glass hover  | `shadow-[0_8px_30px_rgb(0,119,230,0.12)]`       | Hovered glass surfaces   |
| Glass focus  | `shadow-[0_8px_30px_rgb(0,119,230,0.15)]`       | Focused glass surfaces   |

### Colored Shadows (use via Tailwind utilities)

| Classes                         | When to use                 |
|---------------------------------|-----------------------------|
| `shadow-lg shadow-blue-900/30`  | Primary CTA default         |
| `shadow-xl shadow-blue-900/40`  | Primary CTA hover           |
| `shadow-lg shadow-blue-500/30`  | Blue social button hover    |
| `shadow-lg shadow-pink-500/30`  | Instagram button hover      |
| `shadow-sm`                     | Inactive pills, small chips |
| `shadow-md`                     | Active pills                |
| `shadow-inner`                  | Icon wells (empty state)    |

---

## Animations

### fadeInUp (Primary Entrance)

```css
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in-up {
  animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
```

**Usage**: Apply to page shell, hero, filter groups, result rows,
empty state. Stagger children with inline `animation-delay`:

```html
<div class="animate-fade-in-up" style="animation-delay: 0.1s">
<div class="animate-fade-in-up" style="animation-delay: 0.2s">
<div class="animate-fade-in-up" style="animation-delay: 0.3s">
```

### skeletonLoading (Shimmer)

```css
@keyframes skeletonLoading {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

.skeleton {
  background: linear-gradient(90deg, #f1f5f9 25%, #e2e8f0 50%, #f1f5f9 75%);
  background-size: 200% 100%;
  animation: skeletonLoading 1.5s ease-in-out infinite;
}
```

### Tailwind Animation Utilities Used

| Class                                                    | Duration | Usage                    |
|----------------------------------------------------------|----------|--------------------------|
| `animate-spin`                                           | 1s       | Loader outer ring        |
| `animate-[spin_1.5s_linear_infinite_reverse]`            | 1.5s     | Loader inner ring        |
| `animate-pulse`                                          | 2s       | Center badge, status dot |
| `animate-pulse` + `style="animation-duration: 4s"`      | 4s       | Decorative orb (top)     |
| `animate-pulse` + `style="animation-duration: 6s"`      | 6s       | Decorative orb (bottom)  |

---

## Hover & Interaction Effects

### Scale Effects

| Element        | Hover                  | Active               |
|----------------|------------------------|----------------------|
| Brand block    | `hover:scale-[1.02]`   | —                    |
| CTA button     | —                      | `active:scale-[0.97]`|
| Social buttons | `hover:scale-110`      | `active:scale-95`    |

### Rotation Effects

| Element        | Effect                              |
|----------------|-------------------------------------|
| Brand block    | `hover:rotate-1` (subtle 1deg tilt) |

### Color Transitions

All interactive elements use:
```
transition-all duration-200
```

Glass surfaces with shadow changes use:
```
transition-all duration-300
```

Row hovers use:
```
transition-colors duration-150
```

---

## Decorative Elements

### Background Orbs

Two large, blurred, semi-transparent circles placed behind all
content to create depth and warmth.

**Top-right orb:**
```html
<div class="absolute -top-32 -right-32
            w-[300px] h-[300px] sm:w-[600px] sm:h-[600px]
            bg-sky-200/40 rounded-full
            blur-[60px] sm:blur-[100px]
            animate-pulse"
     style="animation-duration: 4s">
</div>
```

**Bottom-left orb:**
```html
<div class="absolute -bottom-32 -left-32
            w-[300px] h-[300px] sm:w-[600px] sm:h-[600px]
            bg-blue-200/30 rounded-full
            blur-[60px] sm:blur-[100px]
            animate-pulse"
     style="animation-duration: 6s">
</div>
```

**Container for orbs:**
```html
<div class="fixed inset-0 pointer-events-none overflow-hidden">
  <!-- orbs here -->
</div>
```

### Ping Dot (Status Indicator)

```html
<span class="w-2 h-2 bg-blue-500 rounded-full animate-pulse"></span>
```

Used inside hero badges and status indicators.

### Left Accent Strip (Advisory Cards)

```html
<div class="w-1.5 bg-gradient-to-b from-amber-400 to-yellow-500
            shrink-0"></div>
```

Placed as the first child inside a flex container to create a
vertical accent bar on the left edge.

### Dashed Border (Empty States)

```
border-2 border-dashed border-slate-300
```

Only used for empty/placeholder states. Never use dashed borders
for active content containers.
