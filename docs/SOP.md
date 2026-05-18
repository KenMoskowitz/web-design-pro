# Huashu-Design + UI/UX Pro Max — Website Design SOP

**Goal:** Produce an 11/10 production-ready website for any service industry using a repeatable two-skill design pipeline — `/ui-ux-pro-max` for strategy and `/huashu-design` for execution.

**Architecture:** Generate a data-driven design system first (colors, typography, style, UX rules), then execute it as a mobile-first, GSAP-animated static site using Tailwind CSS. Deploy to Vercel.

**Tech Stack:** Tailwind CSS (CDN Play), GSAP (CDN), Vanilla JS / HTML5, Vercel CLI.

---

## Executive Summary

Three stages:

1. **Design Intelligence** (`/ui-ux-pro-max`) — search a database of 161 palettes, 57 font pairings, 50+ UI styles. `--design-system` returns a complete spec. Persist to `design-system/MASTER.md`.
2. **Design Execution** (`/huashu-design`) — build using the spec as input. Enforces (a) brand asset collection first, (b) 3 layout variations before committing, (c) junior-designer checkpoints, (d) anti-AI-slop rules.
3. **Deploy + Validate** — Vercel, then Playwright screenshots at mobile + desktop.

---

## Pre-Flight Checklist

| Question | Why it matters |
| --- | --- |
| What is the product type? (service / SaaS / portfolio / e-commerce) | Determines style family and palette direction |
| Who is the target audience? (age, context, trust threshold) | Determines information density and CTA approach |
| What is the primary conversion goal? (call / form / purchase / email) | Determines hero structure and CTA hierarchy |
| Are real brand assets available? (logo, photos, colors) | Determines whether to collect or design from scratch |

---

## Task 1 — Install & Verify CLI Tools

```bash
python3 --version
ls ~/.claude/plugins/cache/ui-ux-pro-max-skill/ui-ux-pro-max/2.5.0/.claude/skills/ui-ux-pro-max/scripts/search.py
vercel --version
which gws
```

If any are missing, see `docs/CLI-SETUP.md`. The scaffold works without them.

---

## Task 2 — Generate Design System

**Files:** `design-system/MASTER.md` (+ optional `design-system/pages/*.md`)

```bash
python3 ~/.claude/plugins/cache/ui-ux-pro-max-skill/ui-ux-pro-max/2.5.0/.claude/skills/ui-ux-pro-max/scripts/search.py \
  "<descriptors>" --design-system --persist -p "<Project Name>"
```

Supplemental queries:

```bash
# deeper color options
search.py "<descriptors>" --domain color
# UX rules
search.py "animation loading accessibility forms" --domain ux
# typography refinement
search.py "<descriptors>" --domain typography
```

When the CLI is unavailable, hand-author `MASTER.md` from the vibe presets (see `templates/design-system/MASTER.md.template`).

---

## Task 3 — Collect Brand Assets

**Files:** `assets/<slug>-brand/logo.svg` (or `.png`), `assets/<slug>-brand/brand-spec.md`

Mandatory before writing HTML. Priority order:

1. Logo (SVG or high-res PNG, transparent bg)
2. Brand photos / headshots (for personal brand / pro services)
3. Hex values (if established)
4. Font names (if established)

Extract colors from existing assets:

```bash
grep -hoE '#[0-9A-Fa-f]{6}' assets/<slug>-brand/*.{svg,html,css} \
  | sort | uniq -c | sort -rn | head -20
```

---

## Task 4 — Answer the Four Position Questions

1. **Narrative role** — hero / transition / data / closing?
2. **Viewer distance** — mobile thumb-scroll or desktop presentation?
3. **Visual temperature** — calm/authoritative or exciting/energetic?
4. **Capacity check** — does the content fit? (sketch 3 thumbnails)

Then define section order:

```
[ HERO ] → [ TRUST BAR ] → [ PROBLEM/SOLUTION ] → [ SERVICES ] →
[ PROOF ] → [ ABOUT ] → [ FAQ ] → [ FINAL CTA ] → [ FOOTER ]
```

Confirm direction with the client/reviewer before building. This is the cheapest point to change direction.

---

## Task 5 — Build the Site (HTML + Tailwind + GSAP)

**Stack:**

| Tech         | Method                              | Why                            |
| ------------ | ----------------------------------- | ------------------------------ |
| Tailwind CSS | CDN Play (cdn.tailwindcss.com)      | Zero build, full JIT           |
| GSAP         | CDN + ScrollTrigger                 | Industry-standard animation    |
| Fonts        | Google Fonts (preconnect + swap)    | Fast, free                     |
| Icons        | Heroicons inline SVG                | No request, themeable          |

Use `templates/index.html.template` as the starting scaffold. Section patterns are documented inline.

---

## Task 6 — Wire GSAP Animations

```js
gsap.registerPlugin(ScrollTrigger);

// Hero entrance — staggered fade+rise
gsap.timeline({ defaults: { ease: 'power3.out', duration: 0.9 } })
  .to('[data-anim="eyebrow"]',  { opacity: 1, y: 0 })
  .to('[data-anim="headline"]', { opacity: 1, y: 0 }, '-=0.6')
  .to('[data-anim="sub"]',      { opacity: 1, y: 0 }, '-=0.6')
  .to('[data-anim="cta"]',      { opacity: 1, y: 0 }, '-=0.6');

// Section reveals
gsap.utils.toArray('[data-reveal]').forEach((el) => {
  gsap.from(el, {
    opacity: 0, y: 40, duration: 0.8, ease: 'power2.out',
    scrollTrigger: { trigger: el, start: 'top 85%' },
  });
});
```

Hover micro-interactions are pure Tailwind (`hover:-translate-y-1 hover:shadow-xl transition-all duration-300`).

---

## Task 7 — Mobile Optimization

- Viewport: `width=device-width, initial-scale=1.0` (never `user-scalable=no`)
- Hero: `text-5xl md:text-7xl` (do not over-scale on mobile)
- Touch targets: min `h-12` (48px)
- Input types: `email`, `tel`, `text` (correct keyboards)
- No horizontal scroll: `px-4` or `px-6`, `max-w-6xl mx-auto`
- Nav: hamburger on mobile, links visible at `md+`
- Images: declared `width`/`height`, `loading="lazy"` below fold
- Body text min `text-base` (16px) to prevent iOS zoom

---

## Task 8 — Conversion Optimization Checklist

See `docs/CHECKLISTS.md` → **Conversion audit**.

---

## Task 9 — Deploy to Vercel

```bash
cd projects/<slug>
vercel --yes
# optionally:
vercel alias set <deploy-url> <production-domain>
npx playwright screenshot <url> /tmp/site-verify.png --viewport-size="390,844"
```

`vercel.json` is included by the scaffold for static HTML deploys.

---

## Task 10 — Send Live URLs

```bash
gws gmail messages send \
  --to "client@example.com" \
  --subject "Live Website Links — <Project>" \
  --body "$(cat <<'EOF'
Hi,

Your new sites are live:
🌐 <Site 1>: <URL>
🌐 <Site 2>: <URL>

All deployed to Vercel, mobile + conversion optimized.

— <You>
EOF
)"
```

---

## Self-Review

Run `docs/CHECKLISTS.md` → **Self-review** before marking complete.
