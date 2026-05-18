#!/usr/bin/env bash
# Scaffold a new web-design-pro project from templates.
#
# Usage:
#   ./scripts/new-project.sh <slug>
#
# Interactive: any missing value is prompted for.
# Non-interactive: set env vars before invoking.
#
# Env vars (all optional — prompted if unset):
#   BUSINESS_NAME       e.g. "Cornerstone Law"
#   INDUSTRY            e.g. "boutique law firm estate planning"
#   DESCRIPTORS         e.g. "premium trust minimal"
#   VIBE                premium-trust | bold-modern | calm-wellness | energetic-fitness
#   GOAL                form | call | email
#   VALUE_PROP          one-line description for <meta description>
#   HERO_HEADLINE       the H1 of the hero
#   HERO_SUB            the hero subheading paragraph
#   PRIMARY_CTA         e.g. "Schedule a Consultation"
#   PRIMARY_CTA_SHORT   nav-bar version, e.g. "Get Started"
#   EYEBROW             above-headline credibility line
#   SOCIAL_PROOF_LINE   short trust line under CTAs
#   SERVICES_HEADLINE / SERVICES_SUB
#   PROOF_HEADLINE / PROOF_SUB
#   ABOUT_HEADLINE
#   CONTACT_HEADLINE / CONTACT_SUB
#   FOOTER_TAGLINE

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATES="$REPO_ROOT/templates"

# ---- args ----
SLUG="${1:-}"
if [[ -z "$SLUG" ]]; then
  echo "Usage: $0 <project-slug>" >&2
  echo "  e.g. $0 cornerstone-law" >&2
  exit 64
fi
if ! [[ "$SLUG" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "Error: slug must be lowercase letters, digits, and hyphens only." >&2
  exit 64
fi

PROJECT_DIR="$REPO_ROOT/projects/$SLUG"
if [[ -e "$PROJECT_DIR" ]]; then
  echo "Error: $PROJECT_DIR already exists. Pick a different slug or delete it first." >&2
  exit 65
fi

# ---- helpers ----
prompt() {
  # prompt <var-name> <question> [default]
  local var="$1" question="$2" default="${3:-}"
  local current="${!var:-}"
  if [[ -n "$current" ]]; then return; fi
  local answer
  if [[ -n "$default" ]]; then
    read -r -p "$question [$default]: " answer
    answer="${answer:-$default}"
  else
    read -r -p "$question: " answer
  fi
  printf -v "$var" '%s' "$answer"
}

prompt_choice() {
  # prompt_choice <var-name> <question> <opt1> <opt2> ...
  local var="$1" question="$2"; shift 2
  local current="${!var:-}"
  if [[ -n "$current" ]]; then
    # validate
    for opt in "$@"; do
      if [[ "$opt" == "$current" ]]; then return; fi
    done
    echo "Warning: \$$var=$current is not in {$*}. Re-prompting." >&2
  fi
  echo "$question"
  select chosen in "$@"; do
    if [[ -n "${chosen:-}" ]]; then
      printf -v "$var" '%s' "$chosen"
      break
    fi
  done
}

# ---- gather inputs ----
prompt BUSINESS_NAME "Business name"
prompt INDUSTRY "Industry / product type (free-form, e.g. 'boutique law firm')"
prompt DESCRIPTORS "Design descriptors (2-3 words, e.g. 'premium trust minimal')"
prompt_choice VIBE "Vibe preset:" premium-trust bold-modern calm-wellness energetic-fitness
prompt_choice GOAL "Primary conversion goal:" form call email
prompt VALUE_PROP "Primary value prop (one line, for meta description and tab title)"
prompt HERO_HEADLINE "Hero headline (the H1 — outcome, not feature)" "$VALUE_PROP"
prompt HERO_SUB "Hero subheading paragraph"
prompt PRIMARY_CTA "Primary CTA button text" "Schedule a Consultation"
prompt PRIMARY_CTA_SHORT "Short CTA for nav bar (≤ 18 chars)" "Get Started"
prompt EYEBROW "Hero eyebrow line (credibility, e.g. 'Trusted by 200+ clients')" "Trusted by leading clients"
prompt SOCIAL_PROOF_LINE "Inline social proof line" "Rated 5.0 by 100+ clients"
prompt SERVICES_HEADLINE "Services section headline" "What we do"
prompt SERVICES_SUB "Services subheading" "Three core services. One result: outcomes you can measure."
prompt PROOF_HEADLINE "Proof section headline" "Results that speak"
prompt PROOF_SUB "Proof subheading" "We measure success in what our clients accomplish."
prompt ABOUT_HEADLINE "About section headline" "Built for people who expect more."
prompt CONTACT_HEADLINE "Contact section headline" "Let's talk."
prompt CONTACT_SUB "Contact subheading" "No commitment. We respond within one business day."
prompt FOOTER_TAGLINE "Footer tagline (one short sentence)" "$VALUE_PROP"

# ---- resolve vibe → colors + fonts ----
case "$VIBE" in
  premium-trust)
    PRIMARY_COLOR="#1a2332"; ACCENT_COLOR="#c9a55c"
    DARK_COLOR="#0f172a";    LIGHT_COLOR="#f8f5f0"
    DISPLAY_FONT="Playfair Display"; BODY_FONT="Inter"
    DISPLAY_FONT_QUERY="Playfair+Display"; BODY_FONT_QUERY="Inter"
    ;;
  bold-modern)
    PRIMARY_COLOR="#0a0a0a"; ACCENT_COLOR="#ff5722"
    DARK_COLOR="#171717";    LIGHT_COLOR="#fafafa"
    DISPLAY_FONT="Space Grotesk"; BODY_FONT="Inter"
    DISPLAY_FONT_QUERY="Space+Grotesk"; BODY_FONT_QUERY="Inter"
    ;;
  calm-wellness)
    PRIMARY_COLOR="#5b8a72"; ACCENT_COLOR="#d4a574"
    DARK_COLOR="#2c3e34";    LIGHT_COLOR="#f7f4ee"
    DISPLAY_FONT="Cormorant Garamond"; BODY_FONT="Lato"
    DISPLAY_FONT_QUERY="Cormorant+Garamond"; BODY_FONT_QUERY="Lato"
    ;;
  energetic-fitness)
    PRIMARY_COLOR="#0d1117"; ACCENT_COLOR="#ff3c5f"
    DARK_COLOR="#000000";    LIGHT_COLOR="#ffffff"
    DISPLAY_FONT="Anton"; BODY_FONT="Inter"
    DISPLAY_FONT_QUERY="Anton"; BODY_FONT_QUERY="Inter"
    ;;
  *)
    echo "Unknown vibe: $VIBE" >&2; exit 1 ;;
esac

# ---- render ----
render() {
  # render <src-template> <dest-file>
  local src="$1" dest="$2"
  # Python is more reliable than sed for arbitrary user text (no need to escape /, &, etc.)
  python3 - "$src" "$dest" <<PYEOF
import os, sys, pathlib
src = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
subs = {
    "BUSINESS_NAME":      os.environ["BUSINESS_NAME"],
    "BUSINESS_SLUG":      os.environ["BUSINESS_SLUG"],
    "INDUSTRY":           os.environ["INDUSTRY"],
    "DESCRIPTORS":        os.environ["DESCRIPTORS"],
    "VIBE":               os.environ["VIBE"],
    "GOAL":               os.environ["GOAL"],
    "VALUE_PROP":         os.environ["VALUE_PROP"],
    "HERO_HEADLINE":      os.environ["HERO_HEADLINE"],
    "HERO_SUB":           os.environ["HERO_SUB"],
    "PRIMARY_CTA":        os.environ["PRIMARY_CTA"],
    "PRIMARY_CTA_SHORT":  os.environ["PRIMARY_CTA_SHORT"],
    "EYEBROW":            os.environ["EYEBROW"],
    "SOCIAL_PROOF_LINE":  os.environ["SOCIAL_PROOF_LINE"],
    "SERVICES_HEADLINE":  os.environ["SERVICES_HEADLINE"],
    "SERVICES_SUB":       os.environ["SERVICES_SUB"],
    "PROOF_HEADLINE":     os.environ["PROOF_HEADLINE"],
    "PROOF_SUB":          os.environ["PROOF_SUB"],
    "ABOUT_HEADLINE":     os.environ["ABOUT_HEADLINE"],
    "CONTACT_HEADLINE":   os.environ["CONTACT_HEADLINE"],
    "CONTACT_SUB":        os.environ["CONTACT_SUB"],
    "FOOTER_TAGLINE":     os.environ["FOOTER_TAGLINE"],
    "PRIMARY_COLOR":      os.environ["PRIMARY_COLOR"],
    "ACCENT_COLOR":       os.environ["ACCENT_COLOR"],
    "DARK_COLOR":         os.environ["DARK_COLOR"],
    "LIGHT_COLOR":        os.environ["LIGHT_COLOR"],
    "DISPLAY_FONT":       os.environ["DISPLAY_FONT"],
    "BODY_FONT":          os.environ["BODY_FONT"],
    "DISPLAY_FONT_QUERY": os.environ["DISPLAY_FONT_QUERY"],
    "BODY_FONT_QUERY":    os.environ["BODY_FONT_QUERY"],
}
out = src
for k, v in subs.items():
    out = out.replace("{{" + k + "}}", v)
pathlib.Path(sys.argv[2]).write_text(out, encoding="utf-8")
PYEOF
}

export BUSINESS_NAME BUSINESS_SLUG="$SLUG" INDUSTRY DESCRIPTORS VIBE GOAL \
       VALUE_PROP HERO_HEADLINE HERO_SUB PRIMARY_CTA PRIMARY_CTA_SHORT EYEBROW \
       SOCIAL_PROOF_LINE SERVICES_HEADLINE SERVICES_SUB PROOF_HEADLINE PROOF_SUB \
       ABOUT_HEADLINE CONTACT_HEADLINE CONTACT_SUB FOOTER_TAGLINE \
       PRIMARY_COLOR ACCENT_COLOR DARK_COLOR LIGHT_COLOR \
       DISPLAY_FONT BODY_FONT DISPLAY_FONT_QUERY BODY_FONT_QUERY

mkdir -p "$PROJECT_DIR/design-system"
mkdir -p "$PROJECT_DIR/assets/${SLUG}-brand"

render "$TEMPLATES/index.html.template"                    "$PROJECT_DIR/index.html"
render "$TEMPLATES/main.js.template"                        "$PROJECT_DIR/main.js"
render "$TEMPLATES/design-system/MASTER.md.template"        "$PROJECT_DIR/design-system/MASTER.md"
render "$TEMPLATES/assets/brand-spec.md.template"           "$PROJECT_DIR/assets/${SLUG}-brand/brand-spec.md"
cp     "$TEMPLATES/vercel.json"                             "$PROJECT_DIR/vercel.json"

# Project-local README with next steps
cat > "$PROJECT_DIR/README.md" <<EOF
# $BUSINESS_NAME

Generated by web-design-pro on $(date '+%Y-%m-%d').

- Vibe: **$VIBE**
- Industry: $INDUSTRY
- Conversion goal: **$GOAL**

## Next steps

1. Read \`design-system/MASTER.md\` and confirm palette/type with the client.
2. Drop real assets into \`assets/${SLUG}-brand/\` and update \`brand-spec.md\`.
3. Search \`index.html\` for \`[CLIENT TO PROVIDE]\` and \`[…]\` placeholders and replace with real copy.
4. Local preview: \`npx serve .\` (or any static server).
5. Deploy: \`vercel --yes\` then \`vercel --prod\`.
6. Run the audits in \`../../docs/CHECKLISTS.md\` before shipping.
EOF

echo
echo "✓ Scaffolded $PROJECT_DIR"
echo
echo "Next steps:"
echo "  1. Open    $PROJECT_DIR/design-system/MASTER.md  (confirm palette/type)"
echo "  2. Replace [CLIENT TO PROVIDE] markers in $PROJECT_DIR/index.html"
echo "  3. Preview cd $PROJECT_DIR && npx serve ."
echo "  4. Deploy  cd $PROJECT_DIR && vercel --yes"
