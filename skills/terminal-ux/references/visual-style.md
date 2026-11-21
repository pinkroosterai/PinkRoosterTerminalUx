# Visual style

Colour, attributes and glyphs. The rule of the skill: **restraint**. Text must make sense with every style stripped away; style adds hierarchy on top.

## Contents

- [Colour roles](#colour-roles)
- [Colour depth](#colour-depth)
- [Light and dark backgrounds](#light-and-dark-backgrounds)
- [Attributes](#attributes)
- [Glyphs and width](#glyphs-and-width)
- [Fallbacks](#fallbacks)
- [Boxes and borders](#boxes-and-borders)

## Colour roles

- Keep the project's existing palette. A project with none gets **semantic roles on the 16 ANSI colours**: error, warning, success, accent, muted. The 16 colours follow the user's theme; fixed 256-colour or RGB values ignore it and can become unreadable.
- Use the normal colours (30–37) for text that matters; avoid the bright variants (90–97) and bright black for essential text, because some themes map them to greys. *(Opinion, from one practitioner report.)*
- Never set a background colour without also setting the foreground. Better: do not set backgrounds at all, except reverse video for selection.
- Use at most a handful of roles per screen. Rainbow output is noise: if everything is highlighted, nothing is. *(Opinion.)*
- Colour never carries meaning alone: pair it with a word or symbol. See [accessibility.md](accessibility.md).

## Colour depth

- Truecolor only when `COLORTERM` is `truecolor` or `24bit`. Its absence means fall back to 256 colours, not to none; ssh and sudo usually drop the variable.
- If you use RGB at all, downsample for 256-colour terminals and provide a theme override.
- macOS Terminal.app: assume 256 colours unless `COLORTERM` says otherwise; recent versions render truecolor, older ones do not. It does not render strikethrough or overline.
- Switches that disable colour are in [output-and-resilience.md](output-and-resilience.md#colour-switches).

## Light and dark backgrounds

Prefer designs that need no detection: the 16 ANSI roles work on both. When a design genuinely depends on the background:

- Ask the terminal for its background colour (the OSC 11 query) only when stdin and stdout are both terminals; read and consume the reply so it does not leak into the shell; wait briefly (around 100 ms is one library's choice) and treat no reply as **unknown**, not as dark.
- Terminals that support the newer dark/light report (mode 2031) answer directly and notify on theme change; use it for long-running full-screen apps.
- `COLORFGBG` is a weak hint, set once at terminal start.
- With an unknown background, use the theme-safe roles.

## Attributes

- Dependable for meaning: **bold**, underline, reverse video. Bold may render as a brighter colour rather than heavier weight.
- Decoration only: dim, italic, strikethrough, curly or coloured underline. Support is uneven.
- `NO_COLOR` keeps attributes, so hierarchy built from bold and spacing survives it.

## Glyphs and width

- Use single-codepoint symbols of known width for anything aligned. Keep emoji with joiners, flags, skin tones and variation selectors out of tables, columns and status gutters: terminals disagree on their width and the cursor drifts.
- East Asian "ambiguous width" characters change width with the locale: pad with the same width rules the terminal uses, or avoid them in aligned layouts.
- Nerd Font icons are opt-in only: without the font the user sees boxes and no variable reveals it. Default to plain Unicode or ASCII, with a flag or config to enable icons, and make icon spacing configurable.

## Fallbacks

- Fall back to ASCII when `TERM` is `linux` or `dumb`, the locale is not UTF-8, or the console is a legacy Windows console; always offer a user-visible override.
- Provide an ASCII equivalent for every symbol you use, decided once in one place (for example `✓`→`ok`, `✗`→`x`, `…`→`...`, box lines → `+-|`). *(Opinion: no sourced convention exists for status symbols.)*
- When piped or in a plain mode, drop decoration entirely rather than substituting it: borders, headers and rules disappear, data stays.

## Boxes and borders

- Default to no boxes. Whitespace, alignment and a single rule separate sections well enough. *(Opinion.)*
- Never nest boxes inside boxes for one-shot output. In full-screen apps, one level of panel borders is enough; the focused panel can differ by border style or title.
- Borders break on resize and in narrow panes, and screen readers read them character by character.

Based on the project research topics: terminal colour and glyphs; terminal accessibility (contrast).
