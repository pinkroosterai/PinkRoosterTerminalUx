---
name: terminal-ux
description: Designs, builds and audits terminal user interfaces (command-line output, interactive prompts and full-screen TUIs) to a high UX standard, applying the rules directly in the project's own language and framework. Use when creating or changing anything a person reads or types into in a terminal (CLI commands and their output, help text, error messages, prompts, progress and spinners, tables, colours, keybindings, TUI screens and layouts) or when asked to review, critique or polish a terminal interface. Not for headless scripts with no human-facing output, or web, desktop and mobile UI.
argument-hint: "[build or audit, and what to work on — or leave empty to infer from the task]"
license: MIT
compatibility: Works in any harness that can read and edit files; a shell is used to check output when available. Needs no network and no specific language or framework.
---

# Terminal UX

Make terminal interfaces that read clearly, behave predictably and degrade gracefully, and write that quality straight into the code. The stance: **opinionated about behaviour, restrained about looks.** Rules on streams, degradation, keys, words and accessibility are firm. Aesthetics are not imposed: the project's own look wins, and a project without one gets quiet, semantic defaults.

This skill is stack-agnostic. It states what the user must see and be able to do; you implement it with whatever the project already uses. Never answer with a tutorial for a UI library; apply the outcome in the user's code.

## Modes

- **Build** — design and build a new command, prompt flow or screen, or change an existing one. Ends with the pre-delivery audit.
- **Audit** — review an existing interface against the same standard and report findings. No code changes unless the user asks.

Pick the mode from the request; ask only if it is genuinely unclear.

## Workflow

1. **Classify the task.**
   - *Small, local edit* (fix a table's alignment, reword an error, add a flag's help line): infer the context from the code and proceed without questions.
   - *Greenfield or ambiguous redesign*: ask a brief set of context questions first, in one batch (Claude Code: `AskUserQuestion`; elsewhere, numbered questions in the message): who uses it, whether it is run interactively, scripted or both, and where it runs (local terminal, SSH, CI, IDE pane, Windows console).
   - *The product shape*: one-shot command, inline prompt flow, or full-screen session. This decides the display mode ([layout-and-interaction.md](references/layout-and-interaction.md)).
2. **Respect what exists.** Read the project's current output code: palette, symbols, flag style, key bindings, layout patterns, message tone. Keep them unless the user asked for a redesign. Where they break a firm rule (data on stderr mixed into stdout, ignored `NO_COLOR`, a terminal left broken, colour-only meaning), keep the look, fix the breach, and say so.
3. **Commit to a direction** before building a new screen or flow, and state it in a few lines: display mode, visual hierarchy (what the eye hits first), interaction model (keys, prompts, what is scriptable), and the degradation plan (piped, no colour, narrow, no Unicode, screen reader).
4. **Build in the project's stack**, reading only the references the routing table names for this task.
5. **Run the pre-delivery audit** ([audit-checklist.md](references/audit-checklist.md)): run the checks the environment allows, fix every failure, and tell the user which checks need a real terminal and a human.
6. **Report** briefly: what was built, the UX choices that are not obvious from the code, and what the user should check by hand.

In audit mode, do steps 1–2, then go through [audit-checklist.md](references/audit-checklist.md) and report in its format: findings ordered by user harm, each with evidence (file and line, or a command and what it printed) and a fix.

## Principles

1. **stdout is for data.** Everything else (logs, errors, prompts, progress) goes to stderr. A pipe never sees a spinner or a colour code it did not ask for.
2. **Degrade on purpose.** Every feature has a defined behaviour when the output is piped, in CI, under `NO_COLOR` or `TERM=dumb`, in 80 columns, without Unicode, and with a screen reader.
3. **Leave the terminal as you found it**, on every exit path, including Ctrl-C and crashes.
4. **Text first, style second.** The output must make sense with all colour and decoration removed. Colour is a handful of semantic roles on the 16 ANSI colours; it never carries meaning alone.
5. **Keyboard first, and discoverable.** Everything is reachable by keys, and the keys in use are shown.
6. **Respond within 100 ms**, and show progress for anything longer than a moment, without polluting logs.
7. **Words are interface.** Errors say what failed, why and how to fix it; confirmations name the target and the consequence; empty states say what is empty and what to do next.
8. **Scriptable by default.** Every prompt has a flag; every table has a plain or JSON form; nothing interactive runs without a terminal.
9. **Linear before fancy.** Inline output unless the task is a session; full-screen is opt-in and hands its content back on exit.
10. **Restraint.** Fewer boxes, fewer colours, fewer symbols. Density is fine; noise is not.

## Terminal slop

Never ship these:

- nested boxes, and borders around one-shot output;
- rainbow colour, or meaning carried by colour alone;
- emoji as layout or as the only status signal; banners and ASCII art in default output;
- keyboard shortcuts with no legend or help screen;
- layouts that break in an 80-column pane;
- spinners, progress bars or colour codes leaking into piped output and CI logs;
- mouse capture that kills copy-paste, with no way to turn it off;
- vague errors ("Something went wrong") and empty filler ("Successfully…", "Are you sure?");
- a frozen spinner or a broken terminal left behind after exit or Ctrl-C.

The full pass/fail list is in [audit-checklist.md](references/audit-checklist.md).

## Routing table

Read only what the task needs. Most tasks need one or two files.

| The task involves | Read |
|---|---|
| Where output goes, piping, CI, TTY checks, colour switches, signals and Ctrl-C, exit codes, terminal restoration, spinners and progress bars, flicker | [output-and-resilience.md](references/output-and-resilience.md) |
| Colours, themes, bold/dim/reverse, symbols and icons, Unicode and ASCII fallbacks, borders | [visual-style.md](references/visual-style.md) |
| Choosing inline vs full-screen, TUI layout and panes, minimum size and resize, keybindings, legends, command palettes, mouse, paging, tables, trees, diffs, charts | [layout-and-interaction.md](references/layout-and-interaction.md) |
| Interactive prompts, input validation, error and warning messages, success output, empty states, destructive confirmations, help and usage text | [prompts-and-microcopy.md](references/prompts-and-microcopy.md) |
| Screen readers, colour-vision and contrast, animation and motion, an accessible mode, tables for non-visual users | [accessibility.md](references/accessibility.md) |
| The pre-delivery audit, audit mode, the report format | [audit-checklist.md](references/audit-checklist.md) |

A new full-screen screen typically needs `layout-and-interaction.md`, `output-and-resilience.md` and the audit checklist. Rewording an error needs only `prompts-and-microcopy.md`.

## Edge cases

- **The project's conventions conflict with a rule.** Keep the conventions; fix only what breaks a firm rule (principles 1–3, colour-only meaning, accessibility), and name the change.
- **The user asks for a library or framework tutorial.** Decline the tutorial; implement the UX outcome in their code with what their project uses, and explain the outcome, not the library.
- **The task has no human-facing terminal output** (a cron job, pure argument parsing, a library function). This skill does not apply; step aside.
- **No stack chosen yet** in a greenfield project: ask which language and framework before writing code, as part of the context questions.
- **You cannot run the interface** (no terminal, no shell, a full-screen app): check what can be checked statically or with piped runs, and give the user the exact checks that need a person at a real terminal.
- **The field disagrees** (colour-variable precedence, success verbosity, a second Ctrl-C): follow the rule in the references; do not survey the options for the user unless asked.
