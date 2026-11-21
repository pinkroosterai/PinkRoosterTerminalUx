# Audit checklist

The pre-delivery audit for build mode and the review standard for audit mode. Each item is pass/fail. Fix every failure before delivering in build mode; report it in audit mode.

## Contents

- [Terminal slop](#terminal-slop)
- [Streams and environments](#streams-and-environments)
- [Ending cleanly](#ending-cleanly)
- [Visual](#visual)
- [Layout and keys](#layout-and-keys)
- [Words](#words)
- [Accessibility](#accessibility)
- [Running the checks](#running-the-checks)
- [The audit report](#the-audit-report)

## Terminal slop

The failure modes generated terminal UI falls into. Any one is a failure.

- [ ] No nested boxes; no border around a single block of one-shot output.
- [ ] No rainbow colour: a handful of semantic roles, the rest default text.
- [ ] No emoji used as layout or as the only status signal; no decorative banners or ASCII art in default output.
- [ ] No hidden shortcuts: every key in use appears in a legend or help screen.
- [ ] Nothing breaks at 80 columns: no wrapped table cells, no overlapping panes, no truncated key information.
- [ ] No spinner, progress bar or colour code in piped stdout or CI logs.
- [ ] No mouse capture without a way to select text and a way to turn it off.
- [ ] No vague errors: each says what failed, why and how to fix it.
- [ ] No "Successfully…", "Done!" or "Are you sure?".
- [ ] No frozen spinner or half-drawn frame left in the scrollback after exit.
- [ ] No unbounded output: long lists page, truncate or summarise.

## Streams and environments

- [ ] stdout carries only the result; everything else goes to stderr.
- [ ] Piped (`tool | cat`): no colour, no animation, no prompts; the output still makes sense.
- [ ] `NO_COLOR=1`, `TERM=dumb` and `--color=never` each remove colour, and nothing loses meaning.
- [ ] Without a terminal on stdin, a missing input fails at once and names the flag.
- [ ] `tool | head -1` exits without an error message.
- [ ] Exit code 0 on success and on zero results; documented non-zero codes on failure.
- [ ] Destructive actions have `--dry-run` where they change many or remote things, and a non-interactive `--yes`.

## Ending cleanly

- [ ] Ctrl-C at the busiest moment says something at once, and leaves a normal shell prompt: cursor visible, echo on, main screen, no stray mouse or paste modes.
- [ ] A second Ctrl-C skips slow clean-up but never terminal restoration.
- [ ] A crash restores the terminal before printing the error.

## Visual

- [ ] The project's existing palette and patterns are kept (unless a redesign was asked for).
- [ ] Colours are semantic roles on the 16 ANSI colours; no fixed RGB without a fallback; no backgrounds.
- [ ] Hierarchy survives without colour: bold, spacing and alignment carry it.
- [ ] Aligned output uses only glyphs of known width; every symbol has an ASCII fallback; Nerd Font icons are opt-in.

## Layout and keys

- [ ] The display mode fits the task (inline for one-shot, full-screen only for sessions), and full-screen hands content back on exit.
- [ ] Usable at 80×24; below the minimum size, a message gives current and needed size.
- [ ] Every action is reachable by keyboard; Esc backs out, `q` quits or pops, `?` helps, `/` filters.
- [ ] A context-sensitive legend shows the keys for the focused area.
- [ ] Long output pages only on a terminal and respects the user's pager settings.
- [ ] Tables have a script-friendly form and truncate rather than wrap.

## Words

- [ ] Prompts show the choices and default in text; the destructive default is No.
- [ ] Errors: failure, cause, fix; the fix is a command where possible.
- [ ] Success is a terse receipt for state changes; queries print only the answer.
- [ ] Empty states name the noun and scope and suggest the next step.
- [ ] Confirmations name the target and consequence; severe ones require the target's name.
- [ ] Help: examples first, every flag with type and default, fits 80 columns.

## Accessibility

- [ ] Output is linear: no rewriting of scrollback beyond one live progress line.
- [ ] A static alternative replaces animation (accessible mode and non-terminal).
- [ ] Prompts have a numbered, linear form.
- [ ] Tables have a one-record-per-line or machine-readable alternative.
- [ ] One persistent accessible switch exists and is listed in help.

## Running the checks

Run what the environment allows, and say what was not run:

- pipe the output: `tool … | cat` and `tool … | head -1`;
- strip colour: `NO_COLOR=1 tool …`, `TERM=dumb tool …`;
- narrow it: `COLUMNS=80 tool …` (and smaller, for full-screen apps);
- non-interactive: `tool … < /dev/null`;
- listen: `tool … | espeak-ng` where available.

A coding agent usually has no real terminal. Interrupt handling, terminal restoration, mouse behaviour and full-screen rendering then need a human run: list those checks for the user rather than claiming them.

## The audit report

In audit mode, report in the conversation (write a file only if the user asks):

1. A one-paragraph verdict: what the interface does well, and its worst problem.
2. Findings ordered by user harm: broken pipes, hung CI and a corrupted terminal first; then lost information (colour-only meaning, accessibility); then confusion (hidden keys, vague errors); then polish.
3. Each finding: the checklist item it fails, the **evidence** (file and line, or the command run and what it printed), the harm in one line, and the fix.
4. What was not checked, and how the user can check it.

Based on the project research topics: all six topics above, and the gaps in existing skills found in the terminal UX prior-art research.
