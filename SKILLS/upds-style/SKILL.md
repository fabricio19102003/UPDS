---
name: upds-style
description: >
  Apply the UPDS institutional design system to any web project.
  Provides brand colors, typography (Inter), glassmorphism surfaces,
  component patterns, and Tailwind CSS recipes for a consistent
  premium academic portal look. Use when building UPDS web apps,
  landing pages, dashboards, or any frontend that must follow UPDS
  visual identity. Trigger: "estilo UPDS", "linea grafica UPDS",
  "UPDS design", "UPDS brand", "UPDS style", "crear interfaz UPDS",
  "disenar pagina UPDS".
license: Apache-2.0
metadata:
  author: fabricio-melgar
  version: "1.0.0"
  stack: React, Tailwind CSS v4, Vite
  source-project: upds-list-main
---

# UPDS Design System

Apply UPDS institutional visual identity to any web project.
The system delivers a **premium academic portal** feel: corporate
blue core softened with sky accents, glassmorphism surfaces, generous
radii, subtle shadows, and polished micro-interactions.

## Visual Tone

- Modern institutional, NOT bureaucratic
- Light, airy, and optimistic
- Premium dashboard aesthetic over typical university form page
- Frosted-glass surfaces over flat cards
- Large heroic typography with gradient fills
- Soft glows and blurred decorative orbs

---

## Critical Rules

1. **Font**: Always use `Inter` from Google Fonts as the sole typeface.
   Import in CSS: `@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');`
   Set root: `font-family: 'Inter', system-ui, -apple-system, sans-serif;`

2. **Primary brand color**: `blue-900` (`#1C398E`) is the anchor.
   Never use a different blue as the primary. Sky tones are accents only.

3. **Surfaces**: Use glassmorphism by default for cards and containers:
   `bg-white/80 backdrop-blur-xl border border-white/50 rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.08)]`

4. **Border radius**: Prefer large radii. Minimum `rounded-xl` for
   interactive elements, `rounded-2xl` to `rounded-3xl` for containers.
   Almost NO sharp corners in the UPDS system.

5. **Shadows**: Use soft custom shadows, not harsh box-shadows.
   Default surface: `shadow-[0_8px_30px_rgb(0,0,0,0.08)]`
   Blue-tinted for CTAs: `shadow-lg shadow-blue-900/30`

6. **Background**: Page background is always a subtle gradient:
   `bg-gradient-to-br from-slate-50 via-white to-sky-50`

7. **No dark mode**: The UPDS system is light-only by design.

---

## Color Palette

### Brand Colors

| Token         | HEX       | Usage                                    |
|---------------|-----------|------------------------------------------|
| `blue-900`    | `#1C398E` | Primary brand, header, CTA gradient start |
| `blue-800`    | `#193CB8` | CTA gradient end, active filters          |
| `blue-700`    | `#1447E6` | Hero gradient midpoint                    |
| `blue-600`    | `#155DFC` | Active states, loader accents             |
| `blue-500`    | `#2B7FFF` | Status indicators, secondary accents      |

### Accent Colors

| Token         | HEX       | Usage                                    |
|---------------|-----------|------------------------------------------|
| `sky-500`     | `#00A6F4` | Secondary accent, footer wordmark         |
| `sky-400`     | `#00BCFF` | Hero text gradient end, loader ring       |
| `sky-200`     | `#B8E6FE` | Selection background, glow orbs           |
| `sky-50`      | `#F0F9FF` | Page background tint, hover surfaces      |

### Neutral Scale

| Token         | HEX       | Usage                                    |
|---------------|-----------|------------------------------------------|
| `slate-900`   | `#0F172B` | Headlines, primary text                   |
| `slate-800`   | `#1D293D` | Card titles, row text                     |
| `slate-600`   | `#45556C` | Support text, hover icons                 |
| `slate-500`   | `#62748E` | Secondary copy                            |
| `slate-400`   | `#90A1B9` | Placeholder text, labels                  |
| `slate-200`   | `#E2E8F0` | Borders, dividers                         |
| `slate-100`   | `#F1F5F9` | Table dividers, skeleton base             |
| `slate-50`    | `#F8FAFC` | Page background base                      |

### Semantic Colors

| Purpose   | Light           | Medium          | Dark            |
|-----------|-----------------|-----------------|-----------------|
| Morning   | `amber-50`      | `amber-400`     | `amber-800`     |
| Afternoon | `orange-50`     | `orange-400`    | `orange-800`    |
| Night     | `blue-50`       | `blue-500`      | `blue-900`      |
| Success   | `emerald-100`   | `emerald-200`   | `emerald-700`   |

For full semantic color list including rotating badge colors, see
`assets/design-tokens.md`.

---

## Typography

### Hierarchy

| Level              | Classes                                                      |
|--------------------|--------------------------------------------------------------|
| Hero headline      | `text-5xl sm:text-6xl md:text-8xl font-black tracking-tighter leading-[1.1]` |
| Section title      | `text-2xl sm:text-3xl font-extrabold`                        |
| Card title         | `text-xl sm:text-2xl font-bold`                              |
| Body large         | `text-lg sm:text-2xl font-medium tracking-tight leading-relaxed` |
| Body               | `text-base lg:text-lg font-semibold`                         |
| Label/Caption      | `text-xs font-bold uppercase tracking-widest text-slate-500` |
| Micro              | `text-[11px] font-medium`                                    |

### Gradient Text (Hero)

```html
<span class="bg-gradient-to-r from-blue-900 via-blue-700 to-sky-400
             bg-clip-text text-transparent">
  Title Text
</span>
```

---

## Layout

- **Max width**: `max-w-7xl` (1280px) for main content
- **Header**: Fixed top, `h-16` mobile / `h-20` desktop, full-width with `max-w-7xl` inner
- **Content padding**: `px-4 sm:px-6`
- **Content offset**: `pt-24 sm:pt-32` (compensate fixed header)
- **Spacing rhythm**: 4px base (`gap-2`, `gap-3`, `gap-4`, `gap-6`)
- **Breakpoints**: `sm:640px`, `md:768px`, `lg:1024px` (Tailwind defaults)
- **Responsive pattern**: Cards on mobile (`<md`), tables on desktop (`md+`)

---

## Core Component Patterns

### Glassmorphism Card

```html
<div class="bg-white/80 backdrop-blur-xl border border-white/50
            rounded-2xl sm:rounded-3xl
            shadow-[0_8px_30px_rgb(0,0,0,0.08)]
            p-4 sm:p-5">
  <!-- content -->
</div>
```

### Primary Button (CTA)

```html
<button class="w-full sm:w-40 h-12 sm:h-16
               bg-gradient-to-r from-blue-900 to-blue-800
               hover:from-blue-800 hover:to-blue-700
               text-white font-bold text-base
               rounded-xl sm:rounded-2xl
               shadow-lg shadow-blue-900/30
               hover:shadow-xl hover:shadow-blue-900/40
               active:scale-[0.97]
               transition-all duration-200">
  Action
</button>
```

### Filter Pill (Active)

```html
<button class="px-4 sm:px-5 py-2 sm:py-2.5
               rounded-full font-bold text-sm sm:text-base
               bg-blue-600 text-white shadow-md
               ring-2 ring-blue-300 ring-offset-2
               transition-all duration-200">
  Filter
</button>
```

### Filter Pill (Inactive)

```html
<button class="px-4 sm:px-5 py-2 sm:py-2.5
               rounded-full font-bold text-sm sm:text-base
               bg-white/70 text-slate-600 shadow-sm
               hover:bg-blue-50 hover:text-blue-700
               transition-all duration-200">
  Filter
</button>
```

### Search Input

```html
<div class="bg-white/80 backdrop-blur-2xl
            border border-white/80 rounded-2xl sm:rounded-3xl
            shadow-[0_8px_30px_rgb(0,0,0,0.08)]
            hover:shadow-[0_8px_30px_rgb(0,119,230,0.12)]
            focus-within:ring-4 focus-within:ring-sky-500/20
            p-2 sm:p-3 transition-all duration-300">
  <input class="w-full bg-transparent outline-none
                text-slate-800 placeholder:text-slate-400
                text-base sm:text-lg font-medium"
         placeholder="Search..." />
</div>
```

For complete component recipes (tables, badges, loaders, skeletons,
empty states, advisory cards), see `references/component-recipes.md`.

For gradients, glassmorphism variants, animations, and decorative
effects, see `references/gradients-and-effects.md`.

---

## Entry Animation

All major sections use a fade-in-up entrance. Add this to your
global CSS:

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

Stagger children with inline `animation-delay`:
`style="animation-delay: 0.1s"`, `0.2s`, `0.3s`, etc.

---

## Icons

- No icon library required; use inline SVGs
- Stroke style: `strokeWidth="2.5"` for a slightly heavier, polished feel
- Outline style preferred for UI icons
- Filled style only for brand/social icons (Facebook, Instagram)
- If adopting a library, prefer **Lucide React** — closest match to the
  existing custom SVG aesthetic

---

## Gotchas

- Do NOT use `tailwind.config.js` custom theme colors. The system
  works with Tailwind v4 default palette composed through utility
  classes. Define semantic aliases via CSS custom properties if needed.
- Do NOT add dark mode classes. The UPDS system is explicitly
  light-only. Remove `darkMode` config if present.
- Do NOT use sharp corners (`rounded-none`, `rounded-sm`). Minimum
  radius is `rounded-lg` for small elements, `rounded-xl` for buttons,
  `rounded-2xl`+ for containers.
- Always pair `bg-white/80` with `backdrop-blur-xl` — the translucency
  without blur looks broken, not intentional.
- Hero gradient text requires BOTH `bg-clip-text` AND `text-transparent`
  together. Missing either one breaks the effect.
- The custom shadow `shadow-[0_8px_30px_rgb(0,0,0,0.08)]` is the
  default for ALL glass surfaces. Do not substitute with `shadow-lg`
  alone — it's too harsh for the UPDS feel.

---

## Decision Tree

```
Building a new UPDS page?
├── Landing/Hero page?
│   ├── Use gradient text for headline
│   ├── Add decorative blurred orbs
│   └── Full glassmorphism card layout
├── Dashboard/Data page?
│   ├── Glass cards for metrics
│   ├── Table with slate header + sky hover rows
│   └── Filter pills for segmentation
├── Form page?
│   ├── Glass container for form
│   ├── Rounded inputs with focus ring
│   └── Blue gradient CTA button
└── Any page
    ├── Fixed header with UPDS brand
    ├── Gradient page background
    ├── Inter font everywhere
    └── fadeInUp entrance animation
```

## Checklist Before Shipping

- [ ] Inter font imported and set as root family
- [ ] Page background uses `from-slate-50 via-white to-sky-50`
- [ ] All cards use glassmorphism pattern
- [ ] No sharp corners anywhere
- [ ] Primary actions use blue gradient CTA
- [ ] Typography follows the hierarchy table
- [ ] fadeInUp animation on main content sections
- [ ] Custom shadow `0_8px_30px_rgb(0,0,0,0.08)` on surfaces
- [ ] No dark mode classes or toggles

## Resources

- **Design Tokens**: See `assets/design-tokens.md` for the complete
  token reference including all semantic and badge rotation colors.
- **Tailwind Preset**: See `assets/tailwind-preset.js` for a
  drop-in Tailwind v4 preset with UPDS brand values.
- **Component Recipes**: See `references/component-recipes.md` for
  copy-paste Tailwind class recipes for every UI component.
- **Effects & Animations**: See `references/gradients-and-effects.md`
  for glassmorphism variants, gradient definitions, keyframes, and
  decorative element patterns.
