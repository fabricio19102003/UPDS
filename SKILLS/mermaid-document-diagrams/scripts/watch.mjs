#!/usr/bin/env node
import { existsSync, readdirSync, statSync, watch } from 'node:fs';
import { join, resolve } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { dirname } from 'node:path';

const here = dirname(fileURLToPath(import.meta.url));
const renderScript = join(here, 'render.mjs');
const stdout = text => process.stdout.write(`${text}\n`);
const stderr = text => process.stderr.write(`${text}\n`);

function help() {
  stdout(`Usage: node scripts/watch.mjs --input-dir docs/diagrams --output-dir docs/diagrams [options]

Watches .mmd files and re-renders changed diagrams. Options passed to render.mjs:
  -f, --format <list>       Comma list: svg,png,pdf (default: svg,png)
      --backend <name>      auto | mmdc | kroki
      --allow-remote        Allow remote Kroki fallback when mmdc is unavailable
      --width <px>          PNG width for mmdc
      --background <color>  Background color
      --theme <name>        mmdc theme
`);
}

function parseArgs(argv) {
  const opts = { inputDir: null, outputDir: null, pass: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    const v = argv[i + 1];
    switch (a) {
      case '--input-dir': opts.inputDir = v; i++; break;
      case '--output-dir': opts.outputDir = v; i++; break;
      case '-h':
      case '--help': help(); process.exit(0);
      case '-f':
      case '--format':
      case '--backend':
      case '--width':
      case '--background':
      case '--theme': opts.pass.push(a, v); i++; break;
      case '--allow-remote':
      case '--no-kroki': opts.pass.push(a); break;
      default: throw new Error(`Unknown argument: ${a}`);
    }
  }
  if (!opts.inputDir) throw new Error('--input-dir is required');
  if (!opts.outputDir) throw new Error('--output-dir is required');
  return opts;
}

function listMmd(dir) {
  return readdirSync(dir)
    .map(name => join(dir, name))
    .filter(path => statSync(path).isFile() && path.endsWith('.mmd'));
}

function render(file, opts) {
  const result = spawnSync(process.execPath, [
    renderScript,
    '--input', file,
    '--output-dir', opts.outputDir,
    ...opts.pass,
  ], { encoding: 'utf8', stdio: 'pipe' });

  if (result.status === 0) stdout(`✓ rendered ${file}`);
  else stderr(`✗ failed ${file}\n${(result.stderr || result.stdout).trim()}`);
}

function main() {
  const opts = parseArgs(process.argv.slice(2));
  opts.inputDir = resolve(opts.inputDir);
  opts.outputDir = resolve(opts.outputDir);
  if (!existsSync(opts.inputDir)) throw new Error(`Input directory not found: ${opts.inputDir}`);

  stdout(`Watching ${opts.inputDir}`);
  for (const file of listMmd(opts.inputDir)) render(file, opts);

  const timers = new Map();
  watch(opts.inputDir, { persistent: true }, (_event, filename) => {
    if (!filename || !filename.endsWith('.mmd')) return;
    const file = join(opts.inputDir, filename);
    clearTimeout(timers.get(file));
    timers.set(file, setTimeout(() => {
      if (existsSync(file)) render(file, opts);
    }, 250));
  });
}

try {
  main();
} catch (e) {
  console.error(`mermaid-watch: ${e.message}`);
  process.exit(1);
}
