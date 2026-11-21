# Output and resilience

Rules for where output goes, how the tool behaves when it is not talking to a person, how it ends, and how it shows progress. These apply to every terminal program, one-shot or full-screen.

## Contents

- [Streams](#streams)
- [Detecting the environment](#detecting-the-environment)
- [Colour switches](#colour-switches)
- [Ctrl-C and signals](#ctrl-c-and-signals)
- [Leaving the terminal usable](#leaving-the-terminal-usable)
- [Broken pipes](#broken-pipes)
- [Exit codes](#exit-codes)
- [Destructive actions](#destructive-actions)
- [Progress and redraw](#progress-and-redraw)

## Streams

- The primary result and anything machine-readable go to **stdout**. Logs, warnings, errors, prompts, spinners and progress go to **stderr**. A pipe must receive only data.
- Never mix status chatter into stdout "just for this one message". The next person pipes it into `jq`.
- Offer a machine-readable form (`--json` or a plain one-record-per-line mode) whenever output is tabular or structured.

## Detecting the environment

- Gate every interactive or animated feature on **the stream it uses**: a prompt checks that stdin is a terminal; a spinner drawn on stderr checks stderr. Do not gate stderr animation on stdout.
- Degrade in this order: not a terminal → no animation, no prompts, no colour; then treat `TERM=dumb` and a set `CI` variable as extra hints that mean the same.
- When input is required and stdin is not a terminal (or `--no-input` is given), fail at once and name the flag or argument that supplies it. Never hang waiting for a keypress in CI.
- Provide a way to force the interactive rendering when redirected (a flag or environment variable) for users who want it.

## Colour switches

Apply this precedence, highest first, and document it in the help text:

1. An explicit flag or the user's config (`--color=always|never|auto`).
2. `NO_COLOR` set to any non-empty value → no colour. It removes colour only; bold, underline and reverse stay.
3. `FORCE_COLOR` or `CLICOLOR_FORCE` non-empty → colour even when piped. `FORCE_COLOR=0` means off.
4. `CLICOLOR=0` → off (the reading most modern tools use).
5. Otherwise, colour only when the stream being written is a terminal and `TERM` is not `dumb`.

Empty variables count as unset. Detect per stream: stdout may be piped while stderr is a terminal.

## Ctrl-C and signals

- On Ctrl-C, say something immediately, then clean up, with a timeout on clean-up so it cannot hang.
- In raw-mode programs Ctrl-C arrives as a keystroke, not a signal. Handle the key and a real interrupt signal on the same quit path.
- **A second Ctrl-C** during slow clean-up skips the clean-up. Terminal restoration is never skipped or interrupted. The first press says what a second press will do.
- When Ctrl-C means "abort the program", restore the terminal, then terminate by the interrupt signal itself (reset the handler to default and re-send it). A plain exit with code 130 does not tell a calling script to stop.
- When Ctrl-C only cancels an inner action (a prompt, a running sub-task inside a full-screen app), return to the previous state; do not exit the program.
- Keep Ctrl-C working while blocked on network or disk.
- Expect to start after a previous run whose clean-up never happened.

## Leaving the terminal usable

On **every** exit path (normal exit, error, crash, interrupt, termination signal), undo every mode the program turned on:

- leave the alternate screen;
- show the cursor;
- restore the saved line mode (echo, line buffering) from the snapshot taken at start-up, not from assumed defaults;
- turn off mouse reporting, focus events and bracketed paste (bracketed paste outlives the program in that terminal window if left on);
- end any synchronized-output frame;
- pop any keyboard-protocol flags pushed, the same number pushed, before leaving the alternate screen;
- reset colours and attributes, and end on a fresh line.

On a crash: restore first, then print the error, with line endings that stay readable even if raw mode is still on. Keep catching signals while restoring, so a second interrupt cannot kill the process half-way. Verify by interrupting the program at its busiest point and checking the shell prompt is normal.

## Broken pipes

When the reader of stdout goes away (`tool | head`), stop quietly: no error message, no stack trace. Languages and runtimes that ignore the broken-pipe signal by default need this handled explicitly: treat the write failure as a silent exit.

## Exit codes

- 0 on success, including "zero results" and "already in the desired state".
- Non-zero on failure, with distinct codes for the few failure modes a script would branch on (bad usage, not found, permission, network). Document them.
- Avoid 126, 127 and 128+n for your own meanings; those mean "not executable", "not found" and "killed by signal n".

## Destructive actions

- Offer `--dry-run` that describes what would change, for anything that modifies many things or anything remote.
- Confirm before destructive actions when interactive; require `--yes`/`--force` when not. For severe actions require typing the target's name, with a scriptable `--confirm=<name>` equivalent.
- Wording of confirmations is in [prompts-and-microcopy.md](prompts-and-microcopy.md).

## Progress and redraw

- Print something within 100 ms of starting. Silence reads as a hang.
- Use a spinner for work of unknown length and a determinate bar (count, percentage, ETA) for work of known size. Label both with what is happening, not "Loading…".
- For parallel work, one line per task, never interleaved fragments.
- When finished, replace the live display with a one-line result, or remove it. Never leave a frozen spinner in the scrollback.
- If progress output hides log lines, print the logs when the work fails.
- When not a terminal, emit occasional plain status lines to stderr (or nothing) instead of animation.
- For full-screen redraws, draw only what changed, write each frame in one write, cap the frame rate, and wrap frames in synchronized output where the terminal supports it. Flicker over SSH is the symptom of skipping these.
- Animation has accessibility costs: see [accessibility.md](accessibility.md).

Based on the project research topics: terminal output streams and feedback; terminal colour and glyphs (colour switches).
