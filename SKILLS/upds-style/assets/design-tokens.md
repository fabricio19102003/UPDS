# UPDS Design Tokens — Complete Reference

This file contains the exhaustive token reference for the UPDS
Design System. Load this file when you need exact color values,
the full semantic palette, or spacing/radius/shadow details
beyond what SKILL.md covers.

---

## Color Tokens

### Brand Blue Scale

| Token      | HEX       | RGB               | Usage                         |
|------------|-----------|-------------------|-------------------------------|
| `blue-50`  | `#EFF6FF` | `239, 246, 255`   | Tinted pills, hover surfaces  |
| `blue-100` | `#DBEAFE` | `219, 234, 254`   | Night badge fill              |
| `blue-200` | `#BEDBFF` | `190, 219, 255`   | Background orb (lower)        |
| `blue-300` | `#8EC5FF` | `142, 197, 255`   | Active ring accent            |
| `blue-400` | `#51A2FF` | `81, 162, 255`    | Loader pulse ring             |
| `blue-500` | `#2B7FFF` | `43, 127, 255`    | Status dot, chip indicator    |
| `blue-600` | `#155DFC` | `21, 93, 252`     | Active filter, loader accent  |
| `blue-700` | `#1447E6` | `20, 71, 230`     | Hero gradient midpoint        |
| `blue-800` | `#193CB8` | `25, 60, 184`     | CTA gradient end              |
| `blue-900` | `#1C398E` | `28, 57, 142`     | PRIMARY BRAND ANCHOR          |

### Sky Accent Scale

| Token      | HEX       | RGB               | Usage                         |
|------------|-----------|-------------------|-------------------------------|
| `sky-50`   | `#F0F9FF` | `240, 249, 255`   | Page bg tint, row hover       |
| `sky-100`  | `#DFF2FE` | `223, 242, 254`   | Room chips                    |
| `sky-200`  | `#B8E6FE` | `184, 230, 254`   | Selection bg, glow orb        |
| `sky-400`  | `#00BCFF` | `0, 188, 255`     | Hero gradient end             |
| `sky-500`  | `#00A6F4` | `0, 166, 244`     | Secondary accent, footer      |

### Neutral Slate Scale

| Token       | HEX       | RGB               | Usage                        |
|-------------|-----------|-------------------|------------------------------|
| `white`     | `#FFFFFF` | `255, 255, 255`   | Card base, text on blue      |
| `slate-50`  | `#F8FAFC` | `248, 250, 252`   | Page background base         |
| `slate-100` | `#F1F5F9` | `241, 245, 249`   | Dividers, skeleton base      |
| `slate-200` | `#E2E8F0` | `226, 232, 240`   | Borders, footer divider      |
| `slate-300` | `#CAD5E2` | `202, 213, 226`   | Dashed borders, divider bar  |
| `slate-400` | `#90A1B9` | `144, 161, 185`   | Placeholder, side labels     |
| `slate-500` | `#62748E` | `98, 116, 142`    | Secondary copy               |
| `slate-600` | `#45556C` | `69, 85, 108`     | Tertiary copy, hover icons   |
| `slate-800` | `#1D293D` | `29, 41, 61`      | Card titles, row text        |
| `slate-900` | `#0F172B` | `15, 23, 43`      | Hero headline                |
| `black`     | `#000000` | `0, 0, 0`         | Rare, shadow opacity base    |

### Semantic: Morning (Amber/Yellow)

| Token        | HEX       | Usage                    |
|--------------|-----------|--------------------------|
| `amber-50`   | `#FFFBEB` | Advisory card bg         |
| `amber-100`  | `#FEF3C6` | Advisory accent          |
| `amber-200`  | `#FEE685` | Advisory border tint     |
| `amber-400`  | `#FFB900` | Morning indicator        |
| `amber-500`  | `#FE9A00` | Morning active           |
| `amber-800`  | `#973C00` | Morning text dark        |
| `amber-900`  | `#7B3306` | Morning text darker      |
| `yellow-50`  | `#FEFCE8` | Morning badge bg         |
| `yellow-100` | `#FEF9C2` | Morning ring             |
| `yellow-300` | `#FFDF20` | Morning accent bright    |
| `yellow-400` | `#FDC700` | Morning chip fill        |
| `yellow-500` | `#F0B100` | Morning icon             |
| `yellow-700` | `#A65F00` | Morning text emphasis    |
| `yellow-800` | `#894B00` | Morning text dark        |

### Semantic: Afternoon (Orange)

| Token        | HEX       | Usage                    |
|--------------|-----------|--------------------------|
| `orange-50`  | `#FFF7ED` | Afternoon badge bg       |
| `orange-100` | `#FFEDD4` | Afternoon ring           |
| `orange-300` | `#FFB86A` | Afternoon accent         |
| `orange-400` | `#FF8904` | Afternoon chip fill      |
| `orange-500` | `#FF6900` | Afternoon icon           |
| `orange-700` | `#CA3500` | Afternoon text emphasis  |
| `orange-800` | `#9F2D00` | Afternoon text dark      |

### Semantic: Night (Blue)

Uses the Brand Blue Scale tokens directly:
- Light: `blue-50` / `blue-100`
- Medium: `blue-500`
- Dark: `blue-900`

### Semantic: Success (Emerald)

| Token          | HEX       | Usage                  |
|----------------|-----------|------------------------|
| `emerald-100`  | `#D0FAE5` | Success badge bg       |
| `emerald-200`  | `#A4F4CF` | Success ring           |
| `emerald-700`  | `#007A55` | Success text           |

### Badge Rotation Colors

These are used for group identification chips. Cycle through them
in order for each distinct group value:

| Index | Light (bg)       | Medium (ring)    | Dark (text)      |
|-------|------------------|------------------|------------------|
| 0     | `blue-100`       | `blue-200`       | `blue-700`       |
| 1     | `purple-100`     | `purple-200`     | `purple-700`     |
| 2     | `emerald-100`    | `emerald-200`    | `emerald-700`    |
| 3     | `pink-100`       | —                | `pink-700`       |
| 4     | `amber-100`      | `amber-200`      | `amber-800`      |
| 5     | `cyan-100`       | `cyan-200`       | `cyan-700`       |
| 6     | `rose-100`       | `rose-200`       | `rose-700`       |
| 7     | `teal-100`       | `teal-200`       | `teal-700`       |
| 8     | `orange-100`     | —                | `orange-700`     |
| 9     | `fuchsia-100`    | `fuchsia-200`    | `fuchsia-700`    |
| 10    | `violet-100`     | `violet-200`     | `violet-700`     |

Pattern for badge: `bg-{light} text-{dark} ring-1 ring-{medium}`

---

## Shadow Tokens

| Name                  | Value                                        | Usage                |
|-----------------------|----------------------------------------------|----------------------|
| Glass surface         | `0 8px 30px rgb(0,0,0,0.08)`                | Default card shadow  |
| Glass hover           | `0 8px 30px rgb(0,119,230,0.12)`             | Hovered glass card   |
| Glass focus           | `0 8px 30px rgb(0,119,230,0.15)`             | Focused glass card   |
| CTA default           | Tailwind `shadow-lg` + `shadow-blue-900/30`  | Primary button       |
| CTA hover             | Tailwind `shadow-xl` + `shadow-blue-900/40`  | Button hovered       |
| Soft small            | Tailwind `shadow-sm`                         | Pills, small chips   |
| Medium                | Tailwind `shadow-md`                         | Active filter pills  |

---

## Border Radius Tokens

| Token          | Value  | Usage                                   |
|----------------|--------|-----------------------------------------|
| `rounded-md`   | 6px    | Small badges only                       |
| `rounded-lg`   | 8px    | Minimum for small interactive elements  |
| `rounded-xl`   | 12px   | Buttons, inputs (mobile)                |
| `rounded-2xl`  | 16px   | Cards, inputs, buttons (desktop)        |
| `rounded-3xl`  | 24px   | Large containers, hero cards            |
| `rounded-full` | 9999px | Pills, avatars, circular buttons        |

---

## Spacing Scale (in use)

Base unit: `0.25rem` (4px)

| Class    | Value  | Common usage                    |
|----------|--------|---------------------------------|
| `gap-2`  | 8px    | Tight element groups            |
| `gap-3`  | 12px   | Badge/chip groups               |
| `gap-4`  | 16px   | Standard content gap            |
| `gap-6`  | 24px   | Section spacing                 |
| `p-2`    | 8px    | Search shell inner (mobile)     |
| `p-3`    | 12px   | Search shell inner (desktop)    |
| `p-4`    | 16px   | Card padding (mobile)           |
| `p-5`    | 20px   | Card padding (desktop)          |
| `px-4`   | 16px   | Page gutter (mobile)            |
| `px-6`   | 24px   | Page gutter (desktop)           |
| `px-6`   | 24px   | Table cell horizontal           |
| `py-4`   | 16px   | Table cell vertical             |
| `pt-24`  | 96px   | Content offset for header (mob) |
| `pt-32`  | 128px  | Content offset for header (dsk) |

---

## Breakpoints

| Token | Width  | Key behavior changes                      |
|-------|--------|-------------------------------------------|
| `sm`  | 640px  | Larger type, spacing, header              |
| `md`  | 768px  | Cards switch to table; footer row layout  |
| `lg`  | 1024px | Larger table text and padding             |

`xl` and `2xl` are NOT used in the current system.

---

## Typography Weights

| Class            | Weight | Usage                           |
|------------------|--------|---------------------------------|
| `font-medium`    | 500    | Body text, metadata             |
| `font-semibold`  | 600    | Table row primary text          |
| `font-bold`      | 700    | Card titles, filter pills, CTA  |
| `font-extrabold` | 800    | Section headlines               |
| `font-black`     | 900    | Hero headline only              |

## Letter Spacing

| Class              | Value     | Usage                     |
|--------------------|-----------|---------------------------|
| `tracking-tighter` | -0.05em   | Hero headline             |
| `tracking-tight`   | -0.025em  | Body large                |
| `tracking-wide`    | 0.025em   | Chip labels               |
| `tracking-widest`  | 0.1em     | Table headers, captions   |
