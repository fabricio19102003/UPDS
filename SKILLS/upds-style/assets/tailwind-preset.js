/**
 * UPDS Design System — Tailwind CSS v4 Preset
 *
 * Usage in your CSS (Tailwind v4):
 *
 *   @import "tailwindcss";
 *   @import "./upds-preset.css";
 *
 * Or copy the @theme block below directly into your main CSS file.
 *
 * NOTE: Tailwind v4 uses CSS-based configuration, not JS config files.
 * This file documents the design tokens as a reference AND provides
 * a CSS block you can copy-paste.
 */

/*
 * ============================================================
 * COPY THIS CSS BLOCK INTO YOUR MAIN STYLESHEET
 * ============================================================
 *
 * @theme {
 *   --font-sans: 'Inter', system-ui, -apple-system, sans-serif;
 *
 *   --color-upds-50:  #EFF6FF;
 *   --color-upds-100: #DBEAFE;
 *   --color-upds-200: #BEDBFF;
 *   --color-upds-300: #8EC5FF;
 *   --color-upds-400: #51A2FF;
 *   --color-upds-500: #2B7FFF;
 *   --color-upds-600: #155DFC;
 *   --color-upds-700: #1447E6;
 *   --color-upds-800: #193CB8;
 *   --color-upds-900: #1C398E;
 *
 *   --color-upds-accent-50:  #F0F9FF;
 *   --color-upds-accent-200: #B8E6FE;
 *   --color-upds-accent-400: #00BCFF;
 *   --color-upds-accent-500: #00A6F4;
 *
 *   --shadow-glass:       0 8px 30px rgb(0 0 0 / 0.08);
 *   --shadow-glass-hover: 0 8px 30px rgb(0 119 230 / 0.12);
 *   --shadow-glass-focus: 0 8px 30px rgb(0 119 230 / 0.15);
 * }
 *
 * ============================================================
 */

/*
 * GLOBAL ROOT STYLES — Add to your index.css
 *
 * :root {
 *   font-family: 'Inter', system-ui, -apple-system, sans-serif;
 *   line-height: 1.5;
 *   font-weight: 400;
 *   color: #1a1a1a;
 *   background-color: #f8fafc;
 *   font-synthesis: none;
 *   text-rendering: optimizeLegibility;
 *   -webkit-font-smoothing: antialiased;
 *   -moz-osx-font-smoothing: grayscale;
 * }
 */

/*
 * ANIMATIONS — Add to your index.css
 *
 * @keyframes fadeInUp {
 *   from {
 *     opacity: 0;
 *     transform: translateY(20px);
 *   }
 *   to {
 *     opacity: 1;
 *     transform: translateY(0);
 *   }
 * }
 *
 * .animate-fade-in-up {
 *   animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
 * }
 *
 * @keyframes skeletonLoading {
 *   0% { background-position: -200% 0; }
 *   100% { background-position: 200% 0; }
 * }
 *
 * .skeleton {
 *   background: linear-gradient(90deg, #f1f5f9 25%, #e2e8f0 50%, #f1f5f9 75%);
 *   background-size: 200% 100%;
 *   animation: skeletonLoading 1.5s ease-in-out infinite;
 * }
 */

// For Tailwind v3 projects (legacy), export as JS preset:
export default {
  theme: {
    extend: {
      fontFamily: {
        sans: ["'Inter'", 'system-ui', '-apple-system', 'sans-serif'],
      },
      colors: {
        upds: {
          50:  '#EFF6FF',
          100: '#DBEAFE',
          200: '#BEDBFF',
          300: '#8EC5FF',
          400: '#51A2FF',
          500: '#2B7FFF',
          600: '#155DFC',
          700: '#1447E6',
          800: '#193CB8',
          900: '#1C398E',
        },
        'upds-accent': {
          50:  '#F0F9FF',
          200: '#B8E6FE',
          400: '#00BCFF',
          500: '#00A6F4',
        },
      },
      boxShadow: {
        glass:       '0 8px 30px rgb(0 0 0 / 0.08)',
        'glass-hover': '0 8px 30px rgb(0 119 230 / 0.12)',
        'glass-focus': '0 8px 30px rgb(0 119 230 / 0.15)',
      },
      borderRadius: {
        '4xl': '2rem',
      },
      animation: {
        'fade-in-up': 'fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards',
      },
      keyframes: {
        fadeInUp: {
          from: { opacity: '0', transform: 'translateY(20px)' },
          to:   { opacity: '1', transform: 'translateY(0)' },
        },
      },
    },
  },
};
