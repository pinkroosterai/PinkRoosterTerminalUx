# Changelog

## 0.1.0 — 2026-11-21

- Add the `terminal-ux` skill: designs, builds and audits terminal interfaces (command-line output, inline prompts and full-screen TUIs) in any language or framework. Two modes, build and audit; a classification step tells one-shot commands, prompt flows and full-screen sessions apart.
- Bundle six references, read on demand through a routing table: output and resilience, visual style, layout and interaction, prompts and microcopy, accessibility, and the audit checklist with the terminal-slop list. Rules trace to the project's research corpus or are labelled as opinion.
- Package for Claude Code, Codex, Antigravity and Pi plus the skills CLI, sharing `skills/`. No logo or icon in this release.
- Add `scripts/check-skills.sh`, `scripts/check-packages.sh` and `scripts/test-check-skills.sh`, ported from PinkRoosterSkills, with checks for 3–6 linked references and no named UI frameworks.
- Behaviour in a fresh harness session is checked by hand with `docs/testing.md`; no eval cases are shipped.
