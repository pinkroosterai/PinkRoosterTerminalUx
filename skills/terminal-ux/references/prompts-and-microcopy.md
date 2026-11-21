# Prompts and microcopy

How interactive prompts behave, and how every message reads. Microcopy is design: most terminal UX failures a user meets are words.

## Contents

- [When to prompt](#when-to-prompt)
- [The prompt line](#the-prompt-line)
- [Selection and search](#selection-and-search)
- [Validation and cancel](#validation-and-cancel)
- [Error messages](#error-messages)
- [Success, warnings and empty states](#success-warnings-and-empty-states)
- [Confirming destructive actions](#confirming-destructive-actions)
- [Help text](#help-text)

## When to prompt

- Prompt only for input that is missing, only when stdin is a terminal, and never for what a flag, argument or config already supplied.
- Every prompt has a flag, argument or stdin equivalent. Without a terminal (or with `--no-input`), fail immediately and name the flag in the error.
- Do not prompt for repetitive actions or in CI. Do not add a prompt to a command that was previously non-interactive.
- Keep chains short: ask one concept per prompt. Offer an explicit guided mode for long multi-step flows.
- After an interactive choice, optionally print the equivalent non-interactive command for next time.
- Render prompts on stderr.

## The prompt line

- State the expected input, the choices and the default in text: `Language (js, py, go) [py]:`, `Enable autoscaling? (Y/n)`.
- The capital letter is the default; Enter accepts it. Destructive confirmations default to No: `(y/N)`.
- Ask a direct question; say when an answer is optional; offer inline help where useful.
- Echo the chosen value after the answer, even when it was the default.

## Selection and search

- Show the keys in a footer: arrows to move, Enter to confirm, Space to toggle in a multi-select.
- Add type-to-filter above about ten choices; filtering may be fuzzy but the selection is exact. Show the match count.
- An empty required multi-select is refused with a message, not silently accepted.
- Offer a numbered, typed alternative to arrow menus (screen readers, dumb terminals). See [accessibility.md](accessibility.md).

## Validation and cancel

- Validate at entry; show the rule that failed (`Must be at least 8 characters`), say plainly that the input was invalid, and re-ask in place.
- Keep non-sensitive input on failure; say when a secret must be re-entered. Never echo passwords.
- Suggest corrections for typos as a question (`Did you mean --version?`); never run the correction silently.
- Ctrl-C and Esc cancel a prompt flow; Esc never means "back" in a linear flow. Offer an explicit Back choice in multi-step flows.
- A cancellation says what was and was not done: `Cancelled: 2 of 5 files uploaded. The remaining 3 were not started.`

## Error messages

Every error states **what failed, why, and the exact fix**:

```
Error: Can't deploy without a team in non-interactive mode.
3 teams are available. Pass one with --scope:
  tool deploy --scope <team>
```

- Name the action and the object; show the offending value (truncated if long).
- Give a cause in plain words, then a recovery step, ideally a command. Never end on a bare "try again".
- The first line names the failure; the last line carries the fix, where the eye lands.
- Do not blame the user. Distinguish "you passed something wrong" from "something failed on our side".
- Ban the empty phrases: "An error occurred", "Something went wrong", "Unable to…" with no reason. *(Opinion, following one CLI design manual.)*
- Group repeated errors instead of printing one per item.
- Partial failure: say what changed, what did not, and whether a retry is safe. Unknown remote state: say so ("may still be running; check its status before retrying").
- Stack traces and internals only behind `--debug`; for unexpected failures, write the details to a log file and print where it is and how to report it.
- A status word goes with any symbol: `Error:`, `Warning:`. Do not prefix ordinary log lines with level tags unless verbose.

## Success, warnings and empty states

- **State changes** get a terse receipt: past-tense verb and target, `Deleted acme-web`, one line per completed operation. Never "Successfully…", "Done!", "Success!". *(Opinion on the banned words.)*
- **Pure queries** print the answer and nothing else.
- **No-ops** say so plainly and exit 0: `example.com is already assigned to acme-web.`
- Suggest the next command after a state change where there is an obvious one.
- **Warnings** state the consequence and what happened instead: `Warning: port 3000 is in use; using 3001.` Never print a warning and an error for the same condition.
- **Deprecations** carry a removal date and the replacement.
- **Empty states**: zero results is a successful answer (exit 0). Name the noun and scope and give the next step: `No domains in acme/web. Add one with: tool domains add <domain>`. A filtered empty result says how to widen it. Machine output stays machine output (`[]` in JSON, nothing when piped). Empty must look different from loading, filtered, failed and permission-denied (which is an error, not empty).

## Confirming destructive actions

- Tier by severity: mild actions run without asking; moderate ones ask `(y/N)` and accept `--yes` non-interactively; severe ones require typing the target's name, with a scriptable `--confirm=<name>`.
- Name the target and the consequence, and count what is affected: `Remove 5 DNS records from acme.com?`, `Revoke token deploy-ci? Deployments using it will fail.`
- Say "This cannot be undone." only when true.
- Never "Continue?" or "Are you sure?". Never ask the user to type a generic word; ask for the specific resource name.
- Keep the expected confirmation string stable: scripts depend on it.
- Never confirm ordinary writes.

## Help text

- No arguments (for a command that needs some): concise help: one-line description, one or two examples, the common flags, and a pointer to `--help`.
- `--help`: examples first, most common flags first, each flag with its type and default, booleans without a value (`--force`, not `--force=true`). No hidden flags.
- Usage synopsis notation: `<placeholder>`, `[optional]`, `{a|b}` for a required choice, `...` for repeatable.
- Link to fuller documentation.
- Help must fit an 80-column pane.

Based on the project research topics: CLI prompts and microcopy; terminal accessibility (prompts).
