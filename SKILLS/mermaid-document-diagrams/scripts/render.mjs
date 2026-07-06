#!/usr/bin/env node
import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, statSync } from 'node:fs';
import { basename, dirname, extname, join, resolve } from 'node:path';
import { tmpdir } from 'node:os';

const KROKI = 'https://kroki.io/mermaid';
const stdout = text => process.stdout.write(`${text}\n`);

function help() {
  stdout(`Usage: node scripts/render.mjs --input diagram.mmd [options]

Options:
  -i, --input <file>        Mermaid .mmd input file (required)
  -o, --output <file>       Single output file (.svg/.png/.pdf)
      --output-dir <dir>    Output directory for generated formats
  -f, --format <list>       Comma list: svg,png,pdf (default: svg,png)
      --backend <name>      auto | mmdc | kroki (default: auto)
      --allow-remote        Allow remote Kroki fallback when mmdc is unavailable
      --width <px>          PNG width for mmdc (default: 2048)
      --background <color>  Background color (default: white)
      --theme <name>        mmdc theme: default | dark | neutral | forest
      --validate-only       Validate without exporting final files
  -h, --help                Show this help`);
}

function parseArgs(argv) {
  const opts = {
    input: null,
    output: null,
    outputDir: null,
    formats: ['svg', 'png'],
    backend: 'auto',
    kroki: false,
    width: '2048',
    background: 'white',
    theme: null,
    validateOnly: false,
    formatProvided: false,
  };

  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    const v = argv[i + 1];
    switch (a) {
      case '-i':
      case '--input': opts.input = v; i++; break;
      case '-o':
      case '--output': opts.output = v; i++; break;
      case '--output-dir': opts.outputDir = v; i++; break;
      case '-f':
      case '--format':
        opts.formats = v.split(',').map(x => x.trim()).filter(Boolean);
        opts.formatProvided = true;
        i++;
        break;
      case '--backend': opts.backend = v; i++; break;
      case '--allow-remote': opts.kroki = true; break;
      case '--no-kroki': opts.kroki = false; break;
      case '--width': opts.width = v; i++; break;
      case '--background': opts.background = v; i++; break;
      case '--theme': opts.theme = v; i++; break;
      case '--validate-only': opts.validateOnly = true; break;
      case '-h':
      case '--help': help(); process.exit(0);
      default: throw new Error(`Unknown argument: ${a}`);
    }
  }

  if (!opts.input) throw new Error('--input is required');
  if (!existsSync(opts.input)) throw new Error(`Input file not found: ${opts.input}`);
  if (!['auto', 'mmdc', 'kroki'].includes(opts.backend)) throw new Error('--backend must be auto, mmdc, or kroki');
  for (const f of opts.formats) {
    if (!['svg', 'png', 'pdf'].includes(f)) throw new Error(`Unsupported format: ${f}`);
  }
  if (opts.output) {
    const ext = extname(opts.output).slice(1).toLowerCase();
    if (!ext) throw new Error('--output requires an extension');
    if (!['svg', 'png', 'pdf'].includes(ext)) throw new Error(`Unsupported output extension: ${ext}`);
    if (opts.formatProvided && (opts.formats.length !== 1 || opts.formats[0] !== ext)) {
      throw new Error('--output extension must match --format');
    }
    opts.formats = [ext];
  }
  for (const f of opts.formats) {
    if (!['svg', 'png', 'pdf'].includes(f)) throw new Error(`Unsupported format: ${f}`);
  }
  if (opts.backend === 'kroki') opts.kroki = true;
  return opts;
}

function quoteWin(value) {
  const text = String(value);
  if (!/[\s&()^|<>]/.test(text)) return text;
  return `"${text.replace(/\\/g, '\\\\').replace(/"/g, '\\"')}"`;
}

function run(cmd, args, options = {}) {
  const direct = spawnSync(cmd, args, {
    encoding: 'utf8',
    stdio: options.stdio ?? 'pipe',
  });

  if (!direct.error) return direct;

  const command = [cmd, ...args.map(quoteWin)].join(' ');
  return spawnSync('cmd.exe', ['/d', '/s', '/c', command], {
    encoding: 'utf8',
    stdio: options.stdio ?? 'pipe',
  });
}

function hasCommand(cmd) {
  const probe = run(cmd, ['--version']);
  return probe.status === 0;
}

function assertFile(path) {
  if (!existsSync(path) || statSync(path).size === 0) throw new Error(`Output was not created: ${path}`);
}

function outputPath(opts, format) {
  if (opts.output) return resolve(opts.output);
  const dir = resolve(opts.outputDir ?? dirname(opts.input));
  mkdirSync(dir, { recursive: true });
  const stem = basename(opts.input, extname(opts.input));
  return join(dir, `${stem}.${format}`);
}

function mmdcArgs(input, output, opts) {
  const args = ['-i', input, '-o', output, '--backgroundColor', opts.background];
  if (extname(output).toLowerCase() === '.png') args.push('-w', String(opts.width));
  if (opts.theme) args.push('--theme', opts.theme);
  return args;
}

function tryMmdcValidate(input, opts) {
  if (!hasCommand('mmdc')) return { ok: false, reason: 'mmdc not found' };
  const dir = mkdtempSync(join(tmpdir(), 'mermaid-validate-'));
  const out = join(dir, 'check.png');
  const result = run('mmdc', mmdcArgs(input, out, opts));
  if (result.status !== 0) return { ok: false, reason: result.stderr || result.stdout || 'mmdc failed' };
  try { assertFile(out); } catch (e) { return { ok: false, reason: e.message }; }
  return { ok: true };
}

function krokiRender(input, output, format) {
  if (format === 'pdf') throw new Error('Kroki Mermaid does not support PDF output; use mmdc');
  if (!hasCommand('curl')) throw new Error('curl not found for Kroki fallback');
  const result = run('curl', [
    '--fail-with-body', '-sS', '--connect-timeout', '10', '--max-time', '60',
    '-X', 'POST',
    '-H', 'Content-Type: text/plain',
    '--data-binary', `@${input}`,
    `${KROKI}/${format}`,
    '-o', output,
  ]);
  if (result.status !== 0) throw new Error(result.stderr || result.stdout || 'Kroki request failed');
  assertFile(output);
}

function mmdcRender(input, output, opts) {
  const result = run('mmdc', mmdcArgs(input, output, opts));
  if (result.status !== 0) throw new Error(result.stderr || result.stdout || 'mmdc export failed');
  assertFile(output);
}

function main() {
  const opts = parseArgs(process.argv.slice(2));
  const input = resolve(opts.input);
  const local = opts.backend !== 'kroki' ? tryMmdcValidate(input, opts) : { ok: false, reason: 'backend forced to kroki' };

  if (!local.ok && opts.backend === 'mmdc') throw new Error(`mmdc validation failed: ${local.reason}`);
  if (!local.ok && (!opts.kroki || opts.backend === 'mmdc')) {
    throw new Error(`${local.reason}; pass --allow-remote to use Kroki fallback`);
  }

  const backend = local.ok ? 'mmdc' : 'kroki';

  if (backend === 'kroki') {
    const dir = mkdtempSync(join(tmpdir(), 'mermaid-kroki-check-'));
    krokiRender(input, join(dir, 'check.svg'), 'svg');
  }

  if (opts.validateOnly) {
    stdout(`Validated ${input} with ${backend}`);
    return;
  }

  if (backend === 'kroki' && opts.formats.includes('pdf')) {
    throw new Error('Kroki Mermaid does not support PDF output; use mmdc');
  }

  const outputs = [];
  for (const format of opts.formats) {
    const out = outputPath(opts, format);
    if (backend === 'mmdc') mmdcRender(input, out, opts);
    else krokiRender(input, out, format);
    outputs.push(out);
  }

  stdout(JSON.stringify({ input, backend, outputs }, null, 2));
}

try {
  main();
} catch (e) {
  console.error(`mermaid-render: ${e.message}`);
  process.exit(1);
}
