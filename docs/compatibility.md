# Compatibility

What has been checked in which harness. A row is only as good as its date: harnesses
change, so re-run the checks after a harness update or a change to the skill.

## 0.1.0

Checked 2026-11-21 on Linux.

| Check | Result |
|---|---|
| `bash scripts/check-skills.sh` | Pass: name, description (590 chars), compatibility, SKILL.md 87 lines and a 7,600-byte body, 6 references all linked from SKILL.md, no UI library named, Claude Code labels, links, package metadata |
| `bash scripts/test-check-skills.sh` | Pass: rejects 13 planted faults in a scratch copy |
| `claude plugin validate .` | Pass with warnings: no plugin icon; the root `CLAUDE.md` is not loaded as plugin context (it is the contributor file) |
| `npx -y skills-ref validate skills/terminal-ux` | Fails only on `argument-hint`, a Claude Code extension kept on purpose |
| Claude Code, local-checkout plugin, dogfooded by the author | The skill loaded and behaved as intended in the author's own use (reported "works perfectly"); not a scripted run of every `docs/testing.md` prompt |

### Installation from the public repository

Checked 2026-11-21 on Linux, user scope, from `pinkroosterai/PinkRoosterTerminalUx` at v0.1.0.

| Harness | Command | Result |
|---|---|---|
| Claude Code | `claude plugin marketplace add pinkroosterai/PinkRoosterTerminalUx`, `claude plugin install pinkrooster-terminal-ux@pinkrooster-terminal-ux` | Pass; listed 0.1.0, enabled |
| Codex CLI | `codex plugin marketplace add pinkroosterai/PinkRoosterTerminalUx`, `codex plugin add pinkrooster-terminal-ux@pinkrooster-terminal-ux` | Pass; listed 0.1.0, installed and enabled |
| Antigravity CLI | `agy plugin install https://github.com/pinkroosterai/PinkRoosterTerminalUx` | Pass; 1 skill installed (terminal-ux), listed 0.1.0, enabled |
| Pi | `pi install git:github.com/pinkroosterai/PinkRoosterTerminalUx` | Pass; listed as a git package |

These establish installation and discovery by each CLI, not model-driven loading or behaviour.

Not checked: behaviour in Codex, Antigravity and Pi sessions (only installation, above);
app and IDE surfaces; Windows and macOS.
