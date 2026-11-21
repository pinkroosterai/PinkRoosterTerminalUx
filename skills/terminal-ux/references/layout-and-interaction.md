# Layout and interaction

Choosing a display mode, laying out full-screen interfaces, keyboard and mouse, and presenting data. Covers one-shot commands, inline prompt flows and full-screen sessions.

## Contents

- [Choose the display mode](#choose-the-display-mode)
- [Full-screen layout](#full-screen-layout)
- [Size and resize](#size-and-resize)
- [Keyboard](#keyboard)
- [Discoverability](#discoverability)
- [Mouse](#mouse)
- [Paging long output](#paging-long-output)
- [Tables](#tables)
- [Trees, diffs and charts](#trees-diffs-and-charts)

## Choose the display mode

| The task | Display mode |
|---|---|
| Produce a result and exit | Inline. Print, then return the prompt. |
| Ask a few questions | Inline prompt flow, linear and scrollback-friendly. |
| Pick one item from many, then exit | Inline or partial-height picker below the cursor; keep the shell context visible. |
| A session the user lives in (dashboard, manager, editor) | Full-screen, on the alternate screen. |

- Full-screen costs scrollback and native find: whatever was on screen vanishes on exit. Offer a way to hand content back (print the result or a transcript on exit, or open it in `$PAGER`/`$EDITOR`).
- Never switch an existing tool to full-screen by default without an opt-out. It breaks screen readers and workflows that rely on scrollback (see [accessibility.md](accessibility.md)).
- The app must still work if the terminal refuses the alternate screen.

## Full-screen layout

- Commit to one layout before building: which regions exist, which is primary, where focus starts, where the key legend sits.
- Typical shape: a primary list or content pane, an optional detail pane, a one-line status or legend bar at the bottom. One level of panel borders at most.
- Give the focused pane more room or a clearly different title/border; the user must always know where keystrokes go.
- Adapt to shape, not only size: stack panes vertically in tall, narrow terminals; collapse the detail pane in narrow ones. Thresholds are per tool (one tool switches at 84 columns); pick and document yours.
- Keep a couple of lines of context around the cursor when scrolling lists.
- Dense is fine; cramped is not. Truncate secondary columns before primary ones. *(Opinion.)*

## Size and resize

- Design for an 80×24 terminal at minimum: nothing crashes, overlaps or garbles there.
- Below your minimum, replace the interface with a centred message giving the current and the needed size in numbers, and resume drawing as soon as the terminal is big enough.
- Redraw completely on resize; coalesce bursts of resize events. *(Opinion: not sourced beyond common practice.)*
- One-shot output must read well in an 80-column split pane: wrap prose, and let tables truncate rather than wrap mid-cell.

## Keyboard

- Everything is reachable by keyboard. The mouse is an extra, never the only way.
- Arrows always work; offer vim keys (`j/k/h/l`) as aliases where the project's audience expects them. Tab and Shift+Tab move focus between panes or fields.
- Esc backs out one level (closes a dialog, clears a filter, leaves a mode); `q` quits or pops a view; Ctrl-C quits from anywhere, following [output-and-resilience.md](output-and-resilience.md#ctrl-c-and-signals).
- Enter acts on the selection; Esc cancels a dialog and Enter accepts it.
- `/` filters or searches the current view; `?` shows help for the current context; `:` (or a palette key) opens a command line or palette.
- Function keys get letter alternatives: SSH clients and terminals often swallow F-keys.
- Destructive keys ask for confirmation consistently: two similar actions must not differ in whether they confirm.
- Provide a read-only mode for tools that can change remote state.

## Discoverability

- A persistent, context-sensitive legend on the bottom line lists the keys that matter in the focused pane. Hidden shortcuts with no legend are terminal slop.
- `?` opens a full help overlay listing every binding for the current context.
- A command palette (a fuzzy list of all commands) lets users find commands without memorising keys; show the key next to each command where it has one. *(Opinion: showing keys is common but unsourced.)*
- Show items that need more input with a trailing "…".

## Mouse

- Mouse support is additive. Capturing the mouse breaks native text selection: name the modifier that restores it (often Shift, Option on macOS) in help, and offer a setting to turn mouse capture off.
- If you capture the mouse, provide in-app selection and copy.
- Clickable elements are the same ones the keyboard reaches.

## Paging long output

- Page only when stdout is a terminal. Never page into a pipe.
- Use the user's pager: a tool-specific variable first, then `PAGER`, then `less`. If `LESS` is unset, set it to `FRX` for the pager process; never override a `LESS` the user set.
- `F` quits at once when output fits one screen (so short output behaves like plain printing), `R` keeps colour, `X` keeps the text in scrollback after quitting. Emit colour as standard SGR sequences so it survives.
- Provide `--no-pager` and honour a pager of `cat` as "never page".

## Tables

- Offer a header-less, script-friendly form (plain or tab-separated, or `--json`) and use it automatically when piped. *(Opinion: tools differ on switching automatically.)*
- Keep extra columns behind a wide mode (`-o wide`) and let users pick columns.
- Right-align numbers, left-align text, keep a single header row with an attribute (bold or underline) rather than colour. *(Opinion: no primary source opened.)*
- Truncate with an ellipsis rather than wrapping inside a cell; truncate paths in the middle so the file name stays visible; offer `--no-trunc`. *(Opinion.)*
- Honour a width override (`COLUMNS` or a flag) for layouts that reflow; a table that cannot shrink should fall back to the script-friendly form or to horizontal scrolling in the pager rather than wrapping into an unreadable block.
- Tables are hard for screen readers: offer one-record-per-line output too.

## Trees, diffs and charts

- Trees: one item per line, indentation plus line glyphs with an ASCII set available, collapsed by default beyond a sensible depth in full-screen apps. *(Opinion.)*
- Diffs: side by side only when the terminal is wide enough; fall back to unified below a minimum width, and keep add-only or remove-only hunks in one column. Make the mode overridable by flag and environment variable.
- Sparklines and small charts sit inline next to the number they explain, without axes, and always beside the number itself so they are not the only carrier of the value.

Based on the project research topics: full-screen TUI patterns; terminal data presentation; terminal accessibility (alternate screen).
