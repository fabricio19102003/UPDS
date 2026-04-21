# Guia de Instalacion — UPDS Skills

Esta guia te explica como instalar las skills de UPDS en tu entorno
de trabajo. Hay **tres metodos** segun la herramienta que uses.

---

## Tabla de contenidos

- [Metodo 1: Claude.ai (web)](#metodo-1-claudeai-web)
- [Metodo 2: Claude Code (terminal)](#metodo-2-claude-code-terminal)
- [Metodo 3: OpenCode y otros agentes](#metodo-3-opencode-y-otros-agentes)
- [Instalar la skill Angular](#instalar-la-skill-angular)
- [Verificar la instalacion](#verificar-la-instalacion)
- [Verificar Angular skill](#verificar-angular-skill)
- [Uso basico](#uso-basico)
- [Preguntas frecuentes](#preguntas-frecuentes)

---

## Metodo 1: Claude.ai (web)

Este metodo es para usar la skill directamente en **claude.ai** desde
el navegador.

### Paso 1: Descargar la skill

Tenes dos opciones:

**Opcion A — Descargar ZIP desde GitHub:**

1. Anda a [github.com/fabricio19102003/UPDS](https://github.com/fabricio19102003/UPDS)
2. Click en el boton verde **"Code"**
3. Click en **"Download ZIP"**
4. Descomprime el ZIP en tu computadora
5. Navega hasta la carpeta `SKILLS/upds-style/`

**Opcion B — Clonar con git:**

```bash
git clone https://github.com/fabricio19102003/UPDS.git
```

### Paso 2: Comprimir la skill

Comprime SOLO la carpeta `upds-style` (no todo el repo) en un
archivo `.zip`:

```
upds-style.zip
├── SKILL.md
├── assets/
│   ├── design-tokens.md
│   └── tailwind-preset.js
└── references/
    ├── component-recipes.md
    └── gradients-and-effects.md
```

> **Importante**: La carpeta raiz del ZIP debe ser `upds-style/` y
> debe contener `SKILL.md` directamente. NO comprimas carpetas
> padre extra.

### Paso 3: Subir a Claude.ai

1. Abri [claude.ai](https://claude.ai)
2. Anda a **Settings** (icono de engranaje)
3. Busca **Capabilities** > **Skills**
4. Click en **"Upload Skill"** o **"Add Skill"**
5. Selecciona el archivo `upds-style.zip`
6. Espera la confirmacion de que se subio correctamente

### Paso 4: Activar la skill

1. En la misma seccion de Skills, asegurate de que **upds-style**
   este con el toggle activado (ON)
2. Listo. La skill se va a cargar automaticamente cuando le pidas
   a Claude cosas relacionadas al estilo UPDS

---

## Metodo 2: Claude Code (terminal)

Este metodo es para usar la skill en **Claude Code** (la CLI oficial
de Anthropic).

### Opcion A: Skill a nivel de proyecto (recomendado)

Copia la carpeta de la skill dentro de tu proyecto:

```bash
# Desde la raiz de tu proyecto
mkdir -p .claude/skills

# Clonar el repo UPDS (si no lo tenes)
git clone https://github.com/fabricio19102003/UPDS.git /tmp/UPDS

# Copiar la skill
cp -r /tmp/UPDS/SKILLS/upds-style .claude/skills/

# Limpiar
rm -rf /tmp/UPDS
```

Tu proyecto queda asi:

```
mi-proyecto/
├── .claude/
│   └── skills/
│       └── upds-style/
│           ├── SKILL.md
│           ├── assets/
│           └── references/
├── src/
├── package.json
└── ...
```

> Claude Code detecta automaticamente las skills en `.claude/skills/`.

### Opcion B: Skill global (todos los proyectos)

Si queres que la skill este disponible en TODOS tus proyectos:

```bash
# Crear directorio global de skills (si no existe)
mkdir -p ~/.config/claude/skills

# Clonar y copiar
git clone https://github.com/fabricio19102003/UPDS.git /tmp/UPDS
cp -r /tmp/UPDS/SKILLS/upds-style ~/.config/claude/skills/
rm -rf /tmp/UPDS
```

### Opcion C: Git submodule (mantener actualizada)

Si queres que la skill se mantenga sincronizada con el repo:

```bash
# Desde la raiz de tu proyecto
git submodule add https://github.com/fabricio19102003/UPDS.git .upds
```

Luego referencia la skill desde `.claude/skills/` con un symlink:

```bash
mkdir -p .claude/skills
ln -s ../../.upds/SKILLS/upds-style .claude/skills/upds-style
```

Para actualizar:

```bash
git submodule update --remote .upds
```

---

## Metodo 3: OpenCode y otros agentes

Este metodo es para **OpenCode** u otros agentes compatibles con el
estandar Agent Skills.

### OpenCode

```bash
# Crear directorio de skills en tu config de OpenCode
mkdir -p ~/.config/opencode/skills

# Clonar y copiar
git clone https://github.com/fabricio19102003/UPDS.git /tmp/UPDS
cp -r /tmp/UPDS/SKILLS/upds-style ~/.config/opencode/skills/
rm -rf /tmp/UPDS
```

### A nivel de proyecto (OpenCode)

```bash
# Desde la raiz de tu proyecto
mkdir -p .agent/skills
git clone https://github.com/fabricio19102003/UPDS.git /tmp/UPDS
cp -r /tmp/UPDS/SKILLS/upds-style .agent/skills/
rm -rf /tmp/UPDS
```

### Otros agentes

Cualquier agente que soporte el estandar [Agent Skills](https://agentskills.io)
puede usar esta skill. El requisito es:

1. La carpeta `upds-style/` debe estar en el directorio de skills
   que tu agente escanea
2. Debe contener `SKILL.md` con el frontmatter YAML valido
3. El agente debe soportar progressive disclosure (carga de archivos
   adicionales bajo demanda)

Consulta la documentacion de tu agente para saber donde colocar
las skills.

---

## Instalar la skill Angular

La skill `angular` se instala de la misma manera que `upds-style`, solo cambia
el nombre de la carpeta. A continuacion se detallan los comandos para cada metodo.

### Claude.ai (web) — Angular

1. Segui los mismos pasos que para `upds-style` (Metodo 1 arriba)
2. Al comprimir, usa la carpeta `SKILLS/angular/` en lugar de `SKILLS/upds-style/`

La estructura del ZIP debe ser:

```
angular.zip
├── SKILL.md
└── references/
    ├── architecture.md
    ├── components.md
    ├── signals.md
    ├── state-management.md
    ├── dependency-injection.md
    ├── routing.md
    ├── forms.md
    ├── templates.md
    ├── http-data-layer.md
    ├── testing.md
    ├── performance.md
    ├── ssr-hydration.md
    ├── security.md
    ├── accessibility.md
    ├── build-tooling.md
    └── migration.md
```

### Claude Code (terminal) — Angular

**Opcion A: A nivel de proyecto**

```bash
# Desde la raiz de tu proyecto Angular
mkdir -p .claude/skills

git clone https://github.com/fabricio19102003/UPDS.git /tmp/UPDS
cp -r /tmp/UPDS/SKILLS/angular .claude/skills/
rm -rf /tmp/UPDS
```

**Opcion B: Global (todos los proyectos)**

```bash
mkdir -p ~/.config/claude/skills

git clone https://github.com/fabricio19102003/UPDS.git /tmp/UPDS
cp -r /tmp/UPDS/SKILLS/angular ~/.config/claude/skills/
rm -rf /tmp/UPDS
```

**Opcion C: Git submodule**

Si ya tenes el submodulo `.upds` configurado (ver Metodo 2 arriba):

```bash
mkdir -p .claude/skills
ln -s ../../.upds/SKILLS/angular .claude/skills/angular
```

### OpenCode — Angular

```bash
# Global
mkdir -p ~/.config/opencode/skills

git clone https://github.com/fabricio19102003/UPDS.git /tmp/UPDS
cp -r /tmp/UPDS/SKILLS/angular ~/.config/opencode/skills/
rm -rf /tmp/UPDS
```

```bash
# A nivel de proyecto
mkdir -p .agent/skills
git clone https://github.com/fabricio19102003/UPDS.git /tmp/UPDS
cp -r /tmp/UPDS/SKILLS/angular .agent/skills/
rm -rf /tmp/UPDS
```

---

## Verificar la instalacion

Una vez instalada, verifica que funcione correctamente:

### En Claude.ai

Escribe en el chat:

```
¿Cuando usarias la skill upds-style?
```

Claude deberia responder mencionando que la usa cuando se le pide
crear interfaces con estilo UPDS, linea grafica UPDS, etc.

### En Claude Code / OpenCode

Escribe en el chat:

```
Describe la paleta de colores del design system UPDS
```

El agente deberia responder con los colores del brand (`blue-900`,
`#1C398E`, etc.) sin que vos tengas que explicar nada.

### Test rapido de funcionalidad

Pedi algo concreto:

```
Crea un componente de boton primario siguiendo el estilo UPDS
```

Deberia generar algo como:

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
  Accion
</button>
```

Si la respuesta usa los colores correctos, glassmorphism, y las
clases de Tailwind documentadas, la skill esta funcionando.

---

## Verificar Angular skill

Una vez instalada la skill `angular`, verifica que funcione:

### En Claude Code / OpenCode

Escribe en el chat:

```
Crea un componente standalone de Angular 20 con signals
```

El agente deberia generar codigo que use:

- `input()` y `output()` en vez de `@Input()` / `@Output()`
- `inject()` en vez de constructor injection
- `ChangeDetectionStrategy.OnPush`
- Control flow moderno (`@if`, `@for` con `track`)
- Standalone component sin NgModule

### Test rapido de signals

Pedi algo concreto:

```
Crea un servicio de carrito de compras con signals en Angular 20
```

Deberia generar un servicio con:
- `private _items = signal<CartItem[]>([])`
- `readonly items = this._items.asReadonly()`
- `readonly total = computed(() => ...)`
- `addItem()` / `removeItem()` que producen nuevas referencias (inmutabilidad)

Si la respuesta usa signals, `inject()`, OnPush y control flow moderno, la skill
esta funcionando correctamente.

---

## Uso basico

### Frases que activan la skill automaticamente

La skill `upds-style` se carga sola cuando decis cosas como:

- *"Crea una interfaz con estilo UPDS"*
- *"Aplica la linea grafica UPDS"*
- *"Diseña una landing page UPDS"*
- *"Usa el design system de UPDS para este formulario"*
- *"Quiero que esta pagina siga el estilo UPDS"*
- *"Crea un dashboard con la estetica UPDS"*

### Frases que activan la skill Angular

La skill `angular` se carga sola cuando decis cosas como:

- *"Crea un componente standalone de Angular 20"*
- *"Crea un servicio con signals"*
- *"Testa este componente con Vitest"*
- *"Configura lazy loading para estas rutas"*
- *"Implementa un interceptor de autenticacion"*
- *"Crea un formulario reactivo con validacion"*
- *"Optimiza el rendimiento de este componente Angular"*
- *"Implementa SSR con hidratacion incremental"*

### Ejemplos de uso real

**Crear una pagina completa:**

```
Crea una landing page para el programa de medicina de UPDS Cobija.
Usa el estilo UPDS. Incluye hero section, seccion de beneficios con
cards y un formulario de contacto.
```

**Agregar un componente:**

```
Agrega una tabla de horarios con el estilo UPDS. Debe tener filtros
por turno (manana, tarde, noche) y busqueda.
```

**Estilar un proyecto existente:**

```
Tengo este componente React. Aplicale el design system UPDS para
que se vea consistente con el resto de la app.
```

### Que hace la skill por vos

Cuando la skill esta activa, el agente automaticamente:

1. Usa **Inter** como fuente
2. Aplica la **paleta de colores** institucional (blue-900 como primario)
3. Genera superficies con **glassmorphism** (`bg-white/80 + backdrop-blur-xl`)
4. Usa **bordes redondeados grandes** (`rounded-2xl`+)
5. Aplica **sombras suaves custom** en lugar de las default de Tailwind
6. Implementa el **gradiente de fondo** de pagina
7. Sigue la **jerarquia tipografica** definida
8. Agrega **animaciones fadeInUp** de entrada
9. Mantiene el sistema **light-only** (sin dark mode)
10. Usa los **patrones de componentes** documentados (buttons, cards, tables, etc.)

---

## Mantener actualizada

Si instalaste la skill copiando archivos, para actualizar:

```bash
# Ir al repo clonado (o clonarlo de nuevo)
git clone https://github.com/fabricio19102003/UPDS.git /tmp/UPDS

# Copiar encima de la skill existente
cp -r /tmp/UPDS/SKILLS/upds-style/* <ruta-a-tu-skill>/upds-style/

# Limpiar
rm -rf /tmp/UPDS
```

Si usaste git submodule:

```bash
git submodule update --remote .upds
```

---

## Preguntas frecuentes

### La skill no se activa automaticamente

**Causa probable**: La descripcion no matchea con lo que le estas
pidiendo al agente.

**Solucion**: Usa frases explicitas como "estilo UPDS", "linea
grafica UPDS" o "UPDS design" en tu prompt. Si sigue sin activarse,
mencionala directamente: *"Usa la skill upds-style para esto."*

### Me da error al subir el ZIP a Claude.ai

**Causa probable**: La estructura del ZIP no es correcta.

**Solucion**: Asegurate de que:
- El ZIP contiene la carpeta `upds-style/` como raiz
- Dentro hay un archivo llamado exactamente `SKILL.md` (case-sensitive)
- No hay archivos extra como `.DS_Store` o `Thumbs.db`

### Puedo usar la skill sin Tailwind CSS?

La skill esta optimizada para **Tailwind CSS v4**. Si usas otro
framework CSS, podes tomar los valores de `assets/design-tokens.md`
(colores HEX, tamaños en px, etc.) y aplicarlos manualmente en tu
sistema de estilos.

### Puedo modificar la skill para mi proyecto?

Si. Copia la skill a tu proyecto y editala segun necesites. Si haces
mejoras que beneficien a todos, abri un PR al repo principal.

### Funciona con Next.js / Vue / Angular?

Si. La skill define un **design system visual**, no esta atada a un
framework especifico. Los tokens de color, tipografia y spacing se
aplican a cualquier stack. Los ejemplos de componentes usan clases
de Tailwind CSS que funcionan en cualquier framework que lo soporte.

### Donde reporto un bug o sugiero mejoras?

Abri un [issue en GitHub](https://github.com/fabricio19102003/UPDS/issues)
o contacta al equipo de desarrollo directamente.
