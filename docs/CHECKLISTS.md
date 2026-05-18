# Checklists

Run these before marking any website complete.

---

## Anti-pattern reference

These instantly make a site look AI-generated. Avoid all of them:

| What to avoid                              | Replace with                                              |
| ------------------------------------------ | --------------------------------------------------------- |
| Purple gradients everywhere                | Single brand color with one strategic accent              |
| Emoji used as icons                        | Heroicons inline SVG (themeable)                          |
| Placeholder text (Lorem ipsum)             | Real copy or explicit `[CLIENT TO PROVIDE]` markers       |
| CSS silhouettes for product images         | Real photos or honest empty placeholder                   |
| Rounded card + left color border accent    | Clean white card, shadow on hover                         |
| Five CTAs all styled as primary buttons    | One primary, one secondary, rest as text links            |
| Inter/Roboto as the only font              | Display serif (or distinctive sans) + clean body sans     |
| Animations on every element                | 2–3 hero elements + section reveals; rest static          |
| Generic stock photos (laptop on desk)      | Real client photos or brand-specific imagery              |
| "Data slop" (made-up stats)                | Real numbers or remove entirely                           |
| Same accent color used 12 times            | Use accent only on primary CTA + 1 highlight per section  |
| Hero background image of a city skyline    | Brand photo, illustration, or solid color                 |
| Decorative blur orbs everywhere            | One subtle gradient or remove                             |

---

## Mobile audit (390px width)

- [ ] Viewport meta is `width=device-width, initial-scale=1.0` (no `user-scalable=no`)
- [ ] Hero headline capped at `text-5xl` on mobile (`text-5xl md:text-7xl`)
- [ ] Every touch target ≥ `h-12` (48px)
- [ ] Forms use correct `type=` for keyboard (`email`, `tel`, `text`)
- [ ] No horizontal scroll — every section uses `px-4`/`px-6`, content `max-w-6xl mx-auto`
- [ ] Hamburger nav on mobile, full nav at `md+`
- [ ] Images have declared `width`/`height` to prevent CLS
- [ ] Below-fold images have `loading="lazy"`
- [ ] Body text ≥ `text-base` (16px) to prevent iOS zoom-on-focus

---

## Conversion audit

### Above-fold

- [ ] Primary value prop is clear in 5 seconds
- [ ] CTA visible without scroll on mobile (390×844)
- [ ] One social proof element in the hero (star rating, client count, credential)
- [ ] No placeholder text on the live page

### Trust

- [ ] At least 3 testimonials with real names and outcomes
- [ ] Credentials / certifications / awards visible
- [ ] Phone or address visible (for local services)
- [ ] Privacy/no-spam microcopy near every form

### CTA hierarchy

- [ ] One primary CTA per section maximum
- [ ] CTA copy describes the outcome (`Get My Free Consultation`, not `Submit`)
- [ ] At least 3 CTAs across the full page (hero, mid-page, footer)
- [ ] First contact form has ≤ 5 fields

### Speed

- [ ] Hero image is `loading="eager"` and under 200 KB
- [ ] All other images are `loading="lazy"`
- [ ] No render-blocking scripts (GSAP at bottom of `<body>`)
- [ ] Google Fonts uses `display=swap`

---

## Self-review (the final pass)

- [ ] No placeholder text on the live page
- [ ] Renders correctly at 390px (iPhone 14)
- [ ] Every CTA links to a real destination (`#contact` or form)
- [ ] Every nav link scrolls to the correct section
- [ ] GSAP runs without console errors
- [ ] Visual test: "Does this look hand-crafted or AI-generated?"
- [ ] Conversion test: "Can a visitor understand the value prop and act within 10 seconds?"
