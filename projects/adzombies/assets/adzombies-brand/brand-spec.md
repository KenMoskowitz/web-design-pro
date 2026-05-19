# Ad Zombies — Brand Spec

**Date:** _(fill in YYYY-MM-DD when assets land)_
**Asset completeness:** `inferred` _(change to `partial` or `complete` once real assets land)_

---

## Core Assets

- **Logo:** `assets/adzombies-brand/logo.svg` _(NOT YET PROVIDED)_
- **Logo (mark only):** `assets/adzombies-brand/logo-mark.svg` _(optional)_
- **Hero photo:** `assets/adzombies-brand/hero.jpg` _(NOT YET PROVIDED)_
- **Team photos:** `assets/adzombies-brand/team/*.jpg` _(optional)_

While assets are missing, `index.html` references the SVG wordmark fallback inside the file. Replace the inline SVG with the real logo before shipping.

---

## Color Palette

| Token             | Hex                | Notes                                    |
| ----------------- | ------------------ | ---------------------------------------- |
| Primary           | `#0a0a0a` | Hero, primary CTA fill                   |
| Accent            | `#7CFC00`  | One highlight per section                |
| Dark              | `#0a0a0a`    | Footer, body headings                    |
| Light             | `#f5f5f5`   | Page background                          |

Source: vibe preset `bold-modern`. Confirm against any existing brand collateral before shipping.

---

## Typography

- **Display:** `Bungee`
- **Body:** `Inter`

Source: vibe preset. If the brand has established fonts, replace and update `index.html` `<link>` tags + Tailwind `fontFamily` config.

---

## Tone / Personality

_(Fill in 3–5 adjectives that describe how the brand should feel. Examples below — edit per project.)_

- irreverent bold AI-era street-cred

---

## Collection checklist

- [ ] Logo (SVG preferred, PNG 2× minimum)
- [ ] Logo mark (optional, for favicon and nav)
- [ ] Hero photo (≥ 2000px wide, ≤ 200 KB after compression)
- [ ] 3–6 team or work photos
- [ ] Confirmed color hexes (run `grep -hoE '#[0-9A-Fa-f]{6}' ...` on existing collateral)
- [ ] Confirmed font names (check existing website / brand guide)
- [ ] 3 real testimonials with name + title + outcome
- [ ] Phone, address, business hours
