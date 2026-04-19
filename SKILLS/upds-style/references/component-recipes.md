# UPDS Component Recipes

Complete copy-paste Tailwind class recipes for every UI component
in the UPDS Design System. Load this file when building specific
components and you need the exact class combinations.

---

## Fixed Header

```html
<header class="fixed top-0 left-0 right-0 z-50
               bg-white/80 backdrop-blur-xl
               border-b border-white/50
               shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
  <div class="max-w-7xl mx-auto px-4 sm:px-6
              h-16 sm:h-20
              flex items-center justify-between">

    <!-- Brand block -->
    <div class="flex items-center gap-3
                hover:scale-[1.02] hover:rotate-1
                transition-transform duration-300 cursor-pointer">
      <div class="w-10 h-10 sm:w-12 sm:h-12
                  bg-gradient-to-br from-blue-900 to-blue-700
                  rounded-xl sm:rounded-2xl
                  flex items-center justify-center
                  shadow-lg shadow-blue-900/30">
        <span class="text-white font-black text-sm sm:text-base">U</span>
      </div>
      <span class="text-blue-900 font-black text-xl sm:text-2xl
                    tracking-tight">
        UPDS
      </span>
    </div>

    <!-- Right side content -->
    <div class="flex items-center gap-3">
      <!-- navigation or status elements -->
    </div>
  </div>
</header>
```

---

## Page Shell

```html
<div class="min-h-screen
            bg-gradient-to-br from-slate-50 via-white to-sky-50
            relative overflow-hidden">

  <!-- Decorative orbs (behind content) -->
  <div class="fixed inset-0 pointer-events-none overflow-hidden">
    <div class="absolute -top-32 -right-32
                w-[300px] h-[300px] sm:w-[600px] sm:h-[600px]
                bg-sky-200/40 rounded-full
                blur-[60px] sm:blur-[100px]
                animate-pulse"
         style="animation-duration: 4s"></div>
    <div class="absolute -bottom-32 -left-32
                w-[300px] h-[300px] sm:w-[600px] sm:h-[600px]
                bg-blue-200/30 rounded-full
                blur-[60px] sm:blur-[100px]
                animate-pulse"
         style="animation-duration: 6s"></div>
  </div>

  <!-- Content (above orbs) -->
  <div class="relative z-10">
    <!-- header, main, footer -->
  </div>
</div>
```

---

## Main Content Area

```html
<main class="pt-24 sm:pt-32 px-4 sm:px-6">
  <div class="max-w-7xl mx-auto">
    <!-- page content -->
  </div>
</main>
```

---

## Hero Section

```html
<div class="text-center animate-fade-in-up">
  <!-- Optional badge -->
  <div class="inline-flex items-center gap-2
              bg-blue-50 text-blue-900
              px-4 py-2 rounded-full
              text-sm font-bold shadow-sm mb-6">
    <span class="w-2 h-2 bg-blue-500 rounded-full animate-pulse"></span>
    Badge Text
  </div>

  <!-- Headline with gradient -->
  <h1 class="text-5xl sm:text-6xl md:text-8xl
             font-black tracking-tighter leading-[1.1]">
    <span class="bg-gradient-to-r from-blue-900 via-blue-700 to-sky-400
                 bg-clip-text text-transparent">
      Hero Title
    </span>
  </h1>

  <!-- Supporting text -->
  <p class="text-lg sm:text-2xl text-slate-600
            font-medium tracking-tight leading-relaxed
            max-w-4xl mx-auto mt-4">
    Supporting description text goes here.
  </p>
</div>
```

---

## Search Input (with glass wrapper)

```html
<div class="max-w-4xl mx-auto mt-8">
  <div class="bg-white/80 backdrop-blur-2xl
              border border-white/80
              rounded-2xl sm:rounded-3xl
              shadow-[0_8px_30px_rgb(0,0,0,0.08)]
              hover:shadow-[0_8px_30px_rgb(0,119,230,0.12)]
              focus-within:ring-4 focus-within:ring-sky-500/20
              focus-within:shadow-[0_8px_30px_rgb(0,119,230,0.15)]
              p-2 sm:p-3
              transition-all duration-300">
    <div class="flex items-center gap-3">
      <!-- Search icon -->
      <svg class="w-6 h-6 text-slate-400 shrink-0
                  transition-all duration-200"
           fill="none" viewBox="0 0 24 24" stroke="currentColor"
           stroke-width="2.5">
        <path stroke-linecap="round" stroke-linejoin="round"
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
      </svg>

      <!-- Input -->
      <input type="text"
             class="flex-1 bg-transparent outline-none
                    text-slate-800 placeholder:text-slate-400
                    text-base sm:text-lg font-medium"
             placeholder="Buscar..." />

      <!-- Clear button (show when input has value) -->
      <button class="p-2 rounded-full
                     text-slate-400 hover:text-slate-600
                     hover:bg-slate-100
                     transition-all duration-200">
        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24"
             stroke="currentColor" stroke-width="2.5">
          <path stroke-linecap="round" stroke-linejoin="round"
                d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </div>
  </div>
</div>
```

---

## Filter Pills Group

```html
<div class="flex flex-wrap items-center justify-center
            gap-2 sm:gap-3 mt-6">
  <!-- Active pill -->
  <button class="px-4 sm:px-5 py-2 sm:py-2.5
                 rounded-full font-bold text-sm sm:text-base
                 bg-blue-600 text-white shadow-md
                 ring-2 ring-blue-300 ring-offset-2
                 transition-all duration-200">
    Todos
  </button>

  <!-- Inactive pill -->
  <button class="px-4 sm:px-5 py-2 sm:py-2.5
                 rounded-full font-bold text-sm sm:text-base
                 bg-white/70 text-slate-600 shadow-sm
                 hover:bg-blue-50 hover:text-blue-700
                 transition-all duration-200">
    Manana
  </button>

  <!-- Semantic pill (morning example) -->
  <button class="px-4 sm:px-5 py-2 sm:py-2.5
                 rounded-full font-bold text-sm sm:text-base
                 bg-amber-400 text-amber-900 shadow-md
                 ring-2 ring-yellow-300 ring-offset-2
                 transition-all duration-200">
    Manana
  </button>
</div>
```

---

## Data Table (Desktop md+)

```html
<div class="overflow-x-auto rounded-2xl
            bg-white/80 backdrop-blur-xl
            border border-white/50
            shadow-[0_8px_30px_rgb(0,0,0,0.08)]">
  <table class="w-full min-w-[800px]">
    <!-- Header -->
    <thead>
      <tr class="bg-slate-50/50 border-b border-slate-100">
        <th class="px-6 py-4 text-left
                   text-xs font-bold uppercase tracking-widest
                   text-slate-500">
          Column
        </th>
        <!-- more th columns -->
      </tr>
    </thead>

    <!-- Body -->
    <tbody class="divide-y divide-slate-100">
      <tr class="hover:bg-sky-50/50 transition-colors duration-150">
        <td class="px-6 py-4 lg:px-8 lg:py-5">
          <span class="text-base lg:text-lg font-semibold text-slate-800">
            Cell content
          </span>
        </td>
        <!-- more td columns -->
      </tr>
    </tbody>
  </table>
</div>
```

---

## Mobile Card Row (below md)

```html
<div class="bg-white/80 backdrop-blur-xl
            border border-white/50
            rounded-2xl
            shadow-[0_8px_30px_rgb(0,0,0,0.08)]
            p-4 space-y-2
            animate-fade-in-up">
  <div class="flex items-start justify-between">
    <h3 class="text-base font-semibold text-slate-800">Title</h3>
    <!-- badge -->
    <span class="px-2.5 py-1 rounded-full text-xs font-bold
                 bg-blue-100 text-blue-700">
      Badge
    </span>
  </div>
  <div class="flex flex-wrap gap-2 text-sm text-slate-500">
    <span>Detail 1</span>
    <span class="text-slate-300">|</span>
    <span>Detail 2</span>
  </div>
</div>
```

---

## Semantic Badge/Chip

```html
<!-- Shift chip (rounded-full, semantic color) -->
<span class="inline-flex items-center gap-1.5
             px-3 py-1.5 rounded-full
             text-xs font-bold
             bg-amber-100 text-amber-800
             ring-1 ring-amber-200">
  <span class="w-1.5 h-1.5 rounded-full bg-amber-500"></span>
  Morning
</span>

<!-- Group chip (rounded-lg, rotation color) -->
<span class="px-2.5 py-1 rounded-lg
             text-xs font-bold
             bg-purple-100 text-purple-700
             ring-1 ring-purple-200">
  Group A
</span>

<!-- Room chip (always sky/blue) -->
<span class="px-2.5 py-1 rounded-lg
             text-xs font-bold
             bg-sky-100 text-sky-700
             ring-1 ring-sky-200">
  Room 101
</span>
```

---

## Advisory/Info Card

```html
<div class="max-w-xl mx-auto mt-6">
  <div class="bg-gradient-to-br from-amber-50/90 to-yellow-50/50
              border border-amber-200/50
              rounded-2xl
              shadow-[0_8px_30px_rgb(0,0,0,0.08)]
              overflow-hidden
              animate-fade-in-up">
    <div class="flex">
      <!-- Left accent bar -->
      <div class="w-1.5 bg-gradient-to-b from-amber-400 to-yellow-500
                  shrink-0"></div>

      <!-- Content -->
      <div class="p-4 sm:p-5 flex gap-3">
        <!-- Info icon -->
        <svg class="w-5 h-5 text-amber-500 shrink-0 mt-0.5"
             fill="none" viewBox="0 0 24 24"
             stroke="currentColor" stroke-width="2.5">
          <path stroke-linecap="round" stroke-linejoin="round"
                d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <div>
          <p class="text-sm font-bold text-amber-900">Title</p>
          <p class="text-sm text-amber-800 mt-1 leading-relaxed">
            Advisory message content.
          </p>
        </div>
      </div>
    </div>
  </div>
</div>
```

---

## Empty State

```html
<div class="max-w-3xl mx-auto text-center
            animate-fade-in-up">
  <div class="bg-white/60 backdrop-blur-xl
              border-2 border-dashed border-slate-300
              rounded-3xl p-8 sm:p-12">
    <!-- Icon well -->
    <div class="w-20 h-20 mx-auto mb-6
                bg-slate-100 rounded-full
                flex items-center justify-center
                shadow-inner">
      <svg class="w-10 h-10 text-slate-400"
           fill="none" viewBox="0 0 24 24"
           stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round"
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
      </svg>
    </div>

    <h3 class="text-2xl sm:text-3xl font-extrabold text-slate-800">
      No results found
    </h3>
    <p class="text-slate-500 mt-3 text-lg leading-relaxed">
      Try adjusting your search or filters.
    </p>
  </div>
</div>
```

---

## Loader (Premium Spinner)

```html
<div class="flex flex-col items-center justify-center gap-6 py-20">
  <div class="relative">
    <!-- Outer ring -->
    <div class="w-16 h-16 rounded-full
                border-4 border-blue-100 border-t-blue-600
                animate-spin"></div>
    <!-- Inner ring (reverse) -->
    <div class="absolute inset-2
                rounded-full
                border-4 border-sky-100 border-b-sky-400
                animate-[spin_1.5s_linear_infinite_reverse]"></div>
    <!-- Center badge -->
    <div class="absolute inset-0 flex items-center justify-center">
      <div class="w-6 h-6 bg-blue-900 rounded-lg animate-pulse"></div>
    </div>
  </div>
  <p class="text-slate-500 font-medium animate-pulse">Loading...</p>
</div>
```

---

## Skeleton Loader

```html
<!-- Requires .skeleton class from global CSS (see SKILL.md) -->
<div class="space-y-4">
  <!-- Skeleton row -->
  <div class="bg-white/80 backdrop-blur-xl
              border border-white/50 rounded-2xl
              shadow-[0_8px_30px_rgb(0,0,0,0.08)]
              p-4 sm:p-5">
    <div class="flex items-center gap-4">
      <div class="skeleton w-10 h-10 rounded-xl"></div>
      <div class="flex-1 space-y-2">
        <div class="skeleton h-4 w-3/4 rounded-lg"></div>
        <div class="skeleton h-3 w-1/2 rounded-lg"></div>
      </div>
      <div class="skeleton h-6 w-20 rounded-full"></div>
    </div>
  </div>
</div>
```

---

## Footer

```html
<footer class="border-t border-slate-200 mt-16">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 py-8
              flex flex-col md:flex-row items-center
              justify-between gap-4">
    <!-- Left: brand -->
    <div class="flex items-center gap-2">
      <span class="text-blue-900 font-black text-lg">UPDS</span>
      <span class="text-slate-400 text-sm">|</span>
      <span class="text-slate-500 text-sm font-medium">
        Cobija, Bolivia
      </span>
    </div>

    <!-- Right: social links -->
    <div class="flex items-center gap-3">
      <!-- Social icon button -->
      <a href="#"
         class="w-10 h-10 rounded-full
                bg-white border border-slate-200
                shadow-sm
                flex items-center justify-center
                text-slate-500
                hover:scale-110 hover:shadow-md
                hover:bg-blue-600 hover:text-white
                hover:border-blue-600
                active:scale-95
                transition-all duration-200">
        <!-- SVG icon inside -->
      </a>
    </div>
  </div>
</footer>
```

---

## Social Button Variants

```html
<!-- Facebook hover: solid blue -->
<a class="... hover:bg-blue-600 hover:text-white hover:border-blue-600
         hover:shadow-lg hover:shadow-blue-500/30">

<!-- Instagram hover: multicolor gradient -->
<a class="... hover:bg-gradient-to-tr hover:from-yellow-500
         hover:via-pink-500 hover:to-purple-600
         hover:text-white hover:border-transparent
         hover:shadow-lg hover:shadow-pink-500/30">
```
