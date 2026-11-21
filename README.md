# PinkRooster Terminal UX

An [Agent Skill](https://agentskills.io/specification) that makes coding agents design, build and audit terminal interfaces (command-line output, interactive prompts and full-screen TUIs) to a high UX standard, in whatever language and framework the project already uses.

The skill is opinionated about behaviour and restrained about looks. It enforces clean stdout/stderr separation, graceful degradation (pipes, CI, `NO_COLOR`, narrow panes, no Unicode, screen readers), terminal restoration on exit, discoverable keys, and error messages that say how to fix the problem. It keeps the project's own visual style and never teaches a UI library: it applies the outcome in your code.

## What it does

- **Build mode**: designs and builds a new command, prompt flow or TUI screen, or changes an existing one. It asks a few context questions for greenfield or ambiguous work, proceeds directly on small edits, commits to a direction before building, and runs a pre-delivery audit.
- **Audit mode**: reviews an existing terminal interface and reports findings ordered by user harm, each with evidence (file and line, or a command and its output) and a fix.

The skill loads a short `SKILL.md` and then only the reference files a task needs:

| File | Covers |
|---|---|
| `skills/terminal-ux/references/output-and-resilience.md` | streams, TTY and CI, colour switches, Ctrl-C, terminal restoration, exit codes, progress |
| `skills/terminal-ux/references/visual-style.md` | colour roles, depth, backgrounds, attributes, glyphs, fallbacks, borders |
| `skills/terminal-ux/references/layout-and-interaction.md` | display modes, TUI layout, size, keys, legends, mouse, paging, tables, diffs |
| `skills/terminal-ux/references/prompts-and-microcopy.md` | prompts, validation, errors, success, empty states, confirmations, help |
| `skills/terminal-ux/references/accessibility.md` | screen readers, colour, motion, the accessible mode |
| `skills/terminal-ux/references/audit-checklist.md` | the pass/fail audit, terminal slop, the audit report |

## Installation

Install from the public repository once it is published, or from a local checkout by replacing `pinkroosterai/PinkRoosterTerminalUx` with the checkout's absolute path. Start a new session after installing.

**Claude Code** (native plugin):

```bash
claude plugin marketplace add pinkroosterai/PinkRoosterTerminalUx
claude plugin install pinkrooster-terminal-ux@pinkrooster-terminal-ux
```

Invoke it as `/pinkrooster-terminal-ux:terminal-ux`, or just ask for terminal UI work and let it load.

**Codex CLI** (native plugin):

```bash
codex plugin marketplace add pinkroosterai/PinkRoosterTerminalUx
codex plugin add pinkrooster-terminal-ux@pinkrooster-terminal-ux
```

**Antigravity CLI**:

```bash
agy plugin install https://github.com/pinkroosterai/PinkRoosterTerminalUx
```

**Pi**:

```bash
pi install git:github.com/pinkroosterai/PinkRoosterTerminalUx
```

**Any harness the skills CLI supports** (project install; add `-g` for user-wide, `--copy` where symlinks are unavailable):

```bash
npx skills add pinkroosterai/PinkRoosterTerminalUx -a claude-code -a codex --skill terminal-ux
```

Keep the whole `skills/terminal-ux/` directory, including `references/`.

## Testing

See `docs/testing.md` for fresh-session test prompts and how to check that only the needed reference files are read.

## Development

| Task | Command |
|---|---|
| Check the skill and packages (run before every commit; needs `jq`) | `bash scripts/check-skills.sh` |
| Package/manifest checks alone | `bash scripts/check-packages.sh` |
| Test the checker | `bash scripts/test-check-skills.sh` |
| Validate against the spec | `npx -y skills-ref validate skills/terminal-ux` (reports `argument-hint`; expected) |
| Validate the Claude plugin | `claude plugin validate .` |

## License

MIT
