# PinkRoosterTerminalUx

The `terminal-ux` agent skill (terminal and console UI/UX design) in the
[Agent Skills](https://agentskills.io/specification) format, packaged as the
`pinkrooster-terminal-ux` plugin. Markdown and bash only: no runtime, no build.

Backwards compatibility: none

## Layout and packaging

- Mirror `../PinkRoosterSkills`: `skills/terminal-ux/SKILL.md` plus `references/`, and the
  native manifests `.claude-plugin/`, `.codex-plugin/`, `.antigravity-plugin/`,
  `.agents/plugins/` and `package.json`, all sharing `skills/`. Copy their shape from there.
- Package identity, version and metadata are canonical in `.claude-plugin/plugin.json`. Edit
  there first, then sync the other manifests.
- `docs/*` is gitignored (work files such as the build brief `docs/task.md`). Track only named
  project docs, re-included with `!docs/<file>`.

## Commands

| Task | Command |
|---|---|
| Check the skill and packages (run before every commit) | `scripts/check-skills.sh` |
| Package/manifest checks alone (needs `jq`) | `scripts/check-packages.sh` |
| Test the checker (plants faults in a scratch copy) | `scripts/test-check-skills.sh` |
| Fresh-session behaviour tests (manual) | `docs/testing.md` |
| Validate against the spec | `npx -y skills-ref validate skills/terminal-ux` (reports `argument-hint`; expected) |
| Validate the Claude plugin | `claude plugin validate .` |

## Skill content rules

- **Stack-agnostic.** Write user-visible behaviour and UX outcomes only. Never name a TUI/CLI
  library or framework (Textual, Ink, Spectre.Console, …) or show language-specific code.
- **Runtime only.** `docs/task.md` PART 1 is what the skill does; PART 2 is the build workflow
  and never goes into `skills/`.
- **Harness-neutral wording.** A Claude-Code-only name (`AskUserQuestion`, `Agent`, …) appears
  only labelled as Claude Code's, next to the fallback for other harnesses.
- **Budgets.** `SKILL.md` under ~500 lines (~5,000 tokens); `references/` holds 3–6 files, each
  reached from a routing table in `SKILL.md`; `description` is 1,024 characters or fewer.
- **Frontmatter** holds `name` (lowercase, hyphens, matching the folder), `description`, a
  quoted `argument-hint` (a Claude Code extension), `license` and `compatibility`. The
  description says what the skill produces, then when to use it and when not to, with no angle
  brackets. Quote values that contain colons.

## Releases

- Update `CHANGELOG.md` and bump `version` in every package manifest and catalog.
