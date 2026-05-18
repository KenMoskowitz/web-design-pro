# CLI Setup (optional)

The scaffold runs without any of these. Install only when you need them.

---

## ui-ux-pro-max

Data-driven palette + typography pairing generator.

```bash
# Plugin install (Claude Code skill)
# 1. From Claude Code, type: /plugin install ui-ux-pro-max
# 2. Verify:
ls ~/.claude/plugins/cache/ui-ux-pro-max-skill/ui-ux-pro-max/2.5.0/.claude/skills/ui-ux-pro-max/scripts/search.py
```

Usage:

```bash
python3 ~/.claude/plugins/cache/ui-ux-pro-max-skill/ui-ux-pro-max/2.5.0/.claude/skills/ui-ux-pro-max/scripts/search.py \
  "boutique law firm estate planning trust professional premium" \
  --design-system --persist -p "Cornerstone Law"
```

When available, replace the vibe-preset section of `MASTER.md` with the CLI output.

---

## Vercel CLI

Static deploy.

```bash
npm install -g vercel
vercel login          # one-time
cd projects/<slug>
vercel --yes          # creates a preview URL
vercel --prod         # promotes to production
```

`vercel.json` is included by the scaffold.

---

## gws (Google Workspace CLI)

For sending live-URL handoff emails. Internal Google tool — install per your org's instructions.

```bash
gws gmail messages send \
  --to "client@example.com" \
  --subject "Live Website Links — Acme" \
  --body "$(cat handoff.txt)"
```

If unavailable, compose the handoff email manually using `examples/handoff-email-template.txt` as a starting point.
