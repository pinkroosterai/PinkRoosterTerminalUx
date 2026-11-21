# Testing terminal-ux

How to check the skill in a real harness. Run every test in a **fresh session** in a **scratch project outside this repository**, so neither this repository's instructions nor its research files influence the result.

## 1. Install into a scratch project

Make an empty directory, `git init` it, and install from your local checkout of this repository (replace `/path/to/PinkRoosterTerminalUx`).

**Claude Code**, native plugin:

```bash
claude plugin marketplace add /path/to/PinkRoosterTerminalUx
claude plugin install pinkrooster-terminal-ux@pinkrooster-terminal-ux --scope local
claude plugin list
```

**Codex CLI**, native plugin:

```bash
codex plugin marketplace add /path/to/PinkRoosterTerminalUx
codex plugin add pinkrooster-terminal-ux@pinkrooster-terminal-ux
codex plugin list
```

**Either, through the skills CLI** (project install, from inside the scratch project):

```bash
npx skills add /path/to/PinkRoosterTerminalUx -a claude-code -a codex --skill terminal-ux
```

Use one method per harness.

## 2. Confirm the skill is registered

Start a **new** session in the scratch project. In Claude Code, type `/` and look for `pinkrooster-terminal-ux:terminal-ux` (plugin) or `terminal-ux` (skills CLI). In Codex, open the skill picker and look for `terminal-ux`. If it is missing, restart the session; do not test in the session where you installed it.

## 3. Run the four prompts

Run each prompt in its own fresh session, without naming the skill, so you also test that it loads by itself.

### a. New inline CLI flow

> Create a small command-line tool in Python called `tidy` that renames the files in a folder to `YYYY-MM-DD_name` using each file's modification date.

Good behaviour:

- The skill loads.
- Because this is greenfield, it asks a short batch of context questions (who runs it, interactive or scripted, where) before building.
- It states a direction: one-shot command, what goes to stdout, the degradation plan.
- The tool: results on stdout and messages on stderr; `--dry-run`; a confirmation that names how many files will be renamed, with `--yes` for scripts; no colour when piped or under `NO_COLOR`; errors that name the file, the cause and the fix; exit code 0 when there is nothing to rename.
- It runs the checks it can (piped, `NO_COLOR=1`, `< /dev/null`) and lists what needs a human.

### b. New full-screen TUI view

> Build a full-screen terminal dashboard in Go that lists running processes, with a detail pane for the selected process and a way to kill one.

Good behaviour:

- The skill loads and picks full-screen, saying why.
- A committed layout: list, detail pane, bottom key legend; focus is visible.
- Keys: arrows (and `j/k`), `/` filter, `?` help, Esc backs out, `q` quits; killing a process asks for confirmation that names the process.
- Works at 80×24 and shows a "terminal too small" message with current and needed size below its minimum.
- Restores the terminal on quit, Ctrl-C and crash; mouse, if any, can be turned off.
- It says which checks need a person at a real terminal (interrupt handling, resize, rendering).

### c. Audit an existing interface

Save this as `report.py` in the scratch project:

```python
import sys, time
print("\033[1;35m╔══════════╗\n║  REPORT  ║\n╚══════════╝\033[0m")
for i in range(20):
    print(f"\r\033[33m⠋ working {i}\033[0m", end="")
    time.sleep(0.1)
try:
    data = open(sys.argv[1]).read()
except Exception:
    print("\033[31mSomething went wrong\033[0m")
    sys.exit(0)
print("\033[32m✅ Successfully processed!\033[0m", len(data))
```

> Review the terminal UX of report.py.

Good behaviour:

- The skill loads in audit mode and changes no code.
- Findings are ordered by user harm, starting with the spinner and colour codes on stdout (they pollute pipes and logs) and the failure that exits 0.
- Each finding cites evidence (a line number, or a command such as `python report.py x | cat` and what it printed) and gives a fix.
- It flags the box banner, the colour-only status, the emoji and the vague error, and lists what it could not check.

### d. Headless task (should not trigger)

> Write a bash script for cron that deletes log files older than 7 days in /var/log/myapp and writes nothing to the terminal.

Good behaviour: the skill does **not** load, and the agent just writes the script.

## 4. Check progressive disclosure

The skill should read only the reference files a task needs. After each positive test, look at the tool calls:

- **Claude Code**: open the transcript view (Ctrl+O) and look for the skill invocation and the file reads under `skills/terminal-ux/references/`.
- **Codex**: read the tool-call entries in the session log.

Expected reads (one or two extra is acceptable; all six for a single test is a failure):

| Test | Expected references |
|---|---|
| a. inline CLI | `output-and-resilience.md`, `prompts-and-microcopy.md`, `audit-checklist.md` |
| b. full-screen TUI | `layout-and-interaction.md`, `output-and-resilience.md`, `audit-checklist.md` |
| c. audit | `audit-checklist.md`, plus `output-and-resilience.md` or `visual-style.md` for detail |
| d. headless | none (the skill does not load) |

Record the results (loaded or not, files read, notable behaviour) and report them back.
