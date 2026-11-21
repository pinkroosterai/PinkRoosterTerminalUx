# Accessibility

Text is not automatically accessible. Screen-reader users meet terminal output as an unstructured stream they step through line by line; redraws, decoration and tables multiply the cost. These rules make the default work for more people and add an explicit accessible mode for the rest.

## Contents

- [Linear by default](#linear-by-default)
- [Status and progress](#status-and-progress)
- [Meaning beyond colour](#meaning-beyond-colour)
- [Structure and tables](#structure-and-tables)
- [Prompts](#prompts)
- [Full-screen interfaces](#full-screen-interfaces)
- [The accessible mode](#the-accessible-mode)
- [Checking](#checking)

## Linear by default

- One-shot and inline output is append-only: never rewrite lines that are already in the scrollback, except the single live line of a progress display.
- Make each command's result easy to find: a clear first line, the result, a clear end. Do not interleave chrome with results.
- Decorative banners, ASCII art and box borders are read character by character; leave them out of default output. *(Opinion beyond "out of plain/accessible mode", which is sourced.)*

## Status and progress

- Never leave the user in silence: emit a status line when long work starts and when it ends.
- Animated spinners are read as noise and can trouble motion-sensitive users. Provide a static text alternative ("Uploading 3 of 10 files…" updated rarely, or one line per step), used in the accessible mode and when not a terminal.
- No standard environment variable for reduced motion exists in terminals; the accessible mode covers it.

## Meaning beyond colour

- Colour is never the only carrier of meaning: pair it with a word (`error:`, `warning:`, `ok`) or a symbol with a text equivalent.
- Contrast is the user's theme in a terminal: stick to the 16 ANSI colours, which the user can tune, and set no backgrounds. (Fixed RGB cannot guarantee the 4.5:1 text contrast that accessibility standards ask for.)
- Respect `NO_COLOR` and `--color=never` fully.

## Structure and tables

- Offer one-record-per-line output or labelled `key: value` sections as an alternative to column tables; screen-reader users must otherwise count columns and remember headers.
- Offer machine-readable output (`--json`, CSV): it lets assistive-technology users read results in tools of their choice.
- Use whitespace and indentation, not lines and boxes, to show headings and grouping.

## Prompts

- Provide a linear prompt flow: questions printed as plain lines, numbered choices typed as numbers, the chosen value echoed back (`Chose: Greek`), and for multi-select the running selection after each toggle.
- Do not repeat the same key-hint line after every keystroke; say it once.
- Render empty defaults visibly (`(none)`), not as `()`. Say explicitly that an input was invalid, then why.
- Arrow-key menus that redraw on each keystroke are hard to follow by ear: the numbered form is the fallback.

## Full-screen interfaces

- Full-screen apps that repaint regions, use the alternate screen and capture the mouse break screen readers: repaints are announced as new content, scrollback empties, selection stops working.
- Make full-screen opt-in for tools that also have an inline form, never a silent default; warn when enabling it.
- Keep a plain command-line or linear equivalent for the core tasks of a full-screen app.
- Keyboard-first design helps users who cannot use a mouse; never make a feature mouse-only.
- Let users turn off mouse capture.
- An optional audible bell when the tool starts waiting for input helps non-visual users. *(Opinion, from one tool's practice.)*

## The accessible mode

- Provide one persistent switch that turns on every accessible behaviour together: linear prompts, static progress, no decoration, no full-screen, plain output. Make it settable by flag, environment variable and config, and list it in `--help`. The skill does not prescribe its name; follow any existing convention in the project.
- Prefer defaults that need no mode. Users of braille displays have warned that a separate mode can be exclusionary; the mode is the safety net, not the design.
- Do not rely on detecting assistive technology: there is no dependable signal.

## Checking

- Pipe the output through a speech synthesizer (for example `espeak-ng`) and listen: banners, borders and spinners announce themselves.
- Run with `NO_COLOR=1` and check nothing loses meaning.
- Run the accessible mode end to end.
- Where possible, ask a screen-reader user; automated checks catch only part of it.

Based on the project research topics: terminal accessibility; CLI prompts and microcopy (prompts).
