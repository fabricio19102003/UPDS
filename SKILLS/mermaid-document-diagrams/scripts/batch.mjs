#!/usr/bin/env node
import { readdirSync, statSync } from 'node:fs';
import { dirname, join, relative, resolve } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const renderScript = join(here, 'render.mjs');
const stdout = text => process.stdout.write(`${text}\n`);
const stderr = text => process.stderr.write(`${text}\n`);

function help() {
  stdout(`Usage: node scripts/batch.mjs --input-dir diagrams --output-dir rendered [options]

Options pass through to render.mjs:
  -f, --format <list>       Comma list: svg,png,pdf (default: svg,png)
      --backend <name>      auto | mmdc | kroki
      --allow-remote        Allow remote Kroki fallback when mmdc is unavailable
      --width <px>          PNG width for mmdc
      --background <color>  Background color
      --theme <name>        mmdc theme
      --recursive           Include nested directories
`);
}

function parseArgs(argv) {
  const opts = { inputDir: null, outputDir: null, recursive: false, pass: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    const v = argv[i + 1];
    switch (a) {
      case '--input-dir': opts.inputDir = v; i++; break;
      case '--output-dir': opts.outputDir = v; i++; break;
      case '--recursive': opts.recursive = true; break;
      case '-h':
      case '--help': help(); process.exit(0); break;
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

function findMmd(dir, recursive) {
  const files = [];
  for (const name of readdirSync(dir)) {
    const path = join(dir, name);
    const st = statSync(path);
    if (st.isDirectory() && recursive) files.push(...findMmd(path, true));
    else if (st.isFile() && name.endsWith('.mmd')) files.push(path);
  }
  return files;
}

function main() {
  const opts = parseArgs(process.argv.slice(2));
  const inputDir = resolve(opts.inputDir);
  const outputDir = resolve(opts.outputDir);
  const files = findMmd(inputDir, opts.recursive);
  if (files.length === 0) throw new Error(`No .mmd files found in ${inputDir}`);

  let failed = 0;
  for (const file of files) {
    const relativeDir = dirname(relative(inputDir, file));
    const fileOutputDir = relativeDir === '.' ? outputDir : join(outputDir, relativeDir);
    const args = [renderScript, '--input', file, '--output-dir', fileOutputDir, ...opts.pass];
    const result = spawnSync(process.execPath, args, { encoding: 'utf8', stdio: 'pipe' });
    if (result.status === 0) {
      stdout(`✓ ${file}`);
      if (result.stdout.trim()) stdout(result.stdout.trim());
    } else {
      failed++;
      stderr(`✗ ${file}`);
      stderr((result.stderr || result.stdout).trim());
    }
  }

  if (failed) throw new Error(`${failed}/${files.length} diagrams failed`);
  stdout(`Rendered ${files.length} diagram(s)`);
}

try {
  main();
} catch (e) {
  console.error(`mermaid-batch: ${e.message}`);
  process.exit(1);
}
