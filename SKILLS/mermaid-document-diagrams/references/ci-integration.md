<!-- markdownlint-disable MD013 -->

# CI Integration

Use CI when a repository stores Mermaid sources in git and rendered assets must stay current.

## Validate all diagrams

```yaml
name: Validate Mermaid diagrams

on:
  pull_request:
    paths:
      - "docs/**/*.mmd"
      - "SKILLS/**/assets/**/*.mmd"

jobs:
  mermaid:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
      - run: npm install -g @mermaid-js/mermaid-cli
      - run: npx puppeteer browsers install chrome-headless-shell
      - run: |
          for dir in docs SKILLS; do
            [ -d "$dir" ] || continue
            find "$dir" -name '*.mmd' -print0
          done | while IFS= read -r -d '' f; do
            mmdc -i "$f" -o /tmp/mermaid-check.png -w 1600 --backgroundColor white
          done
```

## Regenerate rendered assets

Keep regeneration as an explicit maintainer action unless the team accepts bot commits.
For PR review, validation plus a stale-asset check is usually safer than auto-committing generated PNG/SVG files.

Optional stale-asset check:

```bash
SKILL_DIR=SKILLS/mermaid-document-diagrams
node "$SKILL_DIR/scripts/batch.mjs" \
  --input-dir docs/diagrams \
  --output-dir docs/diagrams \
  --format svg,png \
  --backend mmdc

git diff --exit-code -- docs/diagrams
```

If the diff is non-empty, commit regenerated assets with the `.mmd` change.

Recommended convention:

```text
docs/diagrams/
├── system-flow.mmd
├── system-flow.svg
└── system-flow.png
```

Rules:

- Commit `.mmd` plus final assets used by docs.
- Avoid Kroki in CI for private diagrams unless remote processing is approved.
- Use local `mmdc` in CI for deterministic output and privacy.
