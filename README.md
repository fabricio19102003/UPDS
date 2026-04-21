# UPDS — Skills & Design System

Repositorio central de skills de IA y recursos compartidos para la **Universidad Privada Domingo Savio (UPDS) — Sede Cobija**.

Este repositorio contiene skills reutilizables que estandarizan la forma en que los agentes de IA (Claude, OpenCode, etc.) trabajan con los proyectos UPDS, garantizando **coherencia visual y profesionalismo** en todos los desarrollos.

---

## Skills Disponibles

| Skill | Descripcion | Stack |
|-------|-------------|-------|
| [`upds-style`](SKILLS/upds-style/SKILL.md) | Design system institucional UPDS. Colores, tipografia, glassmorphism, componentes Tailwind y mas. | React, Tailwind CSS v4, Vite |
| [`angular`](SKILLS/angular/SKILL.md) | Angular 20+ best practices, arquitectura, signals, testing y flujos de desarrollo modernos. | Angular 20, TypeScript 5.8+, Vitest |

---

## Que es una Skill?

Una skill es un conjunto de instrucciones empaquetadas como una carpeta que le ensena a un agente de IA como manejar tareas especificas. En lugar de re-explicar tus preferencias en cada conversacion, la skill lo hace por vos automaticamente.

**Analogia**: Si el agente de IA es un chef profesional, la skill es la receta. Le dice exactamente que ingredientes usar, en que orden, y como debe quedar el resultado final.

---

## Inicio Rapido

### 1. Clonar el repositorio

```bash
git clone https://github.com/fabricio19102003/UPDS.git
```

### 2. Instalar la skill

Consulta la [Guia de Instalacion](INSTALLATION.md) para instrucciones detalladas segun tu entorno:

- **Claude.ai** (web)
- **Claude Code** (terminal)
- **OpenCode / Otros agentes**

### 3. Usar la skill

Una vez instalada, la skill se activa automaticamente cuando le pidas al agente cosas como:

- *"Crea una interfaz con estilo UPDS"*
- *"Aplica la linea grafica de UPDS a este proyecto"*
- *"Disena una landing page UPDS"*
- *"Usa el design system de UPDS"*

---

## Estructura del Repositorio

```
UPDS/
├── README.md                          # Este archivo
├── INSTALLATION.md                    # Guia de instalacion paso a paso
└── SKILLS/
    ├── upds-style/                    # Skill del Design System UPDS
    │   ├── SKILL.md                   # Instrucciones core del agente
    │   ├── assets/
    │   │   ├── design-tokens.md       # Tokens de diseno completos
    │   │   └── tailwind-preset.js     # Preset Tailwind reutilizable
    │   └── references/
    │       ├── component-recipes.md   # Recetas de componentes UI
    │       └── gradients-and-effects.md  # Efectos visuales y animaciones
    └── angular/                       # Skill de Angular 20+
        ├── SKILL.md                   # Patrones core + links a referencias
        └── references/                # 16 archivos de referencia detallados
            ├── architecture.md        # Arquitectura + Atomic Design
            ├── components.md          # Patrones de componentes
            ├── signals.md             # Guia completa de Signals
            ├── state-management.md    # Manejo de estado
            ├── dependency-injection.md# DI estilo moderno
            ├── routing.md             # Patrones de routing modernos
            ├── forms.md               # Formularios Signal-Era
            ├── templates.md           # Sintaxis de templates
            ├── http-data-layer.md     # HTTP y capa de datos
            ├── testing.md             # Guia completa de testing
            ├── performance.md         # Performance
            ├── ssr-hydration.md       # SSR e Hidratacion
            ├── security.md            # Seguridad
            ├── accessibility.md       # Accesibilidad
            ├── build-tooling.md       # Build y Tooling
            └── migration.md           # Notas de migracion
```

---

## Que incluye `upds-style`?

### Paleta de Colores

El sistema usa azul institucional como ancla, con acentos sky y una escala neutra slate:

| Rol | Color | Ejemplo |
|-----|-------|---------|
| Brand primario | `#1C398E` | ![#1C398E](https://via.placeholder.com/16/1C398E/1C398E.png) Header, CTAs, logo |
| Brand secundario | `#193CB8` | ![#193CB8](https://via.placeholder.com/16/193CB8/193CB8.png) Gradientes, filtros activos |
| Acento principal | `#155DFC` | ![#155DFC](https://via.placeholder.com/16/155DFC/155DFC.png) Estados activos, loader |
| Acento sky | `#00A6F4` | ![#00A6F4](https://via.placeholder.com/16/00A6F4/00A6F4.png) Acentos secundarios |
| Background | `#F8FAFC` | ![#F8FAFC](https://via.placeholder.com/16/F8FAFC/F8FAFC.png) Fondo de pagina |
| Texto primario | `#0F172B` | ![#0F172B](https://via.placeholder.com/16/0F172B/0F172B.png) Headlines |

### Tipografia

- **Fuente unica**: Inter (Google Fonts)
- **Jerarquia**: desde `96px font-black` (hero) hasta `11px font-medium` (micro)

### Estilo Visual

- **Glassmorphism**: Superficies translucidas con blur (`bg-white/80 backdrop-blur-xl`)
- **Bordes redondeados**: Minimo `rounded-xl`, preferencia `rounded-2xl` a `rounded-3xl`
- **Sombras suaves**: Custom `0 8px 30px rgb(0,0,0,0.08)`
- **Gradiente de fondo**: `from-slate-50 via-white to-sky-50`
- **Sin dark mode**: El sistema es exclusivamente light

### Componentes Incluidos

- Header fijo con glassmorphism
- Hero section con texto gradiente
- Search input con glass wrapper
- Filter pills (activos/inactivos)
- Data table (desktop) + card rows (mobile)
- Badges/chips semanticos con rotacion de colores
- Advisory/info cards con acento lateral
- Empty state con borde dashed
- Loader premium (doble anillo)
- Skeleton loading con shimmer
- Footer con botones sociales
- Animacion fadeInUp de entrada

---

## Tono Visual

El sistema transmite un **"portal academico premium"**: corporativo pero no burocratico, limpio y aereo, con estetica de dashboard moderno. Se siente mas como una startup elegante que una pagina universitaria tipica.

---

## Contribuir

Si queres agregar una nueva skill o mejorar una existente:

1. Crea un branch: `git checkout -b feat/nombre-skill`
2. Agrega tu skill en `SKILLS/nombre-skill/SKILL.md`
3. Segui la [especificacion de Agent Skills](https://agentskills.io/specification)
4. Abre un Pull Request

### Reglas para skills

- Carpeta en **kebab-case** (`mi-skill`, no `Mi Skill`)
- Archivo principal: **`SKILL.md`** (exacto, case-sensitive)
- **NO** incluir `README.md` dentro de la carpeta de la skill
- YAML frontmatter con `name` y `description` obligatorios
- `SKILL.md` menor a 500 lineas; detalles en `references/` o `assets/`

---

## Licencia

Apache-2.0

---

## Contacto

**UPDS Cobija** — Universidad Privada Domingo Savio, Sede Cobija, Bolivia

Desarrollado y mantenido por el equipo de desarrollo UPDS Cobija.
