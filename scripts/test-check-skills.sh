#!/usr/bin/env bash
# Exercise checker failures in disposable copies, without changing this checkout.
set -eu
repo=$(cd "$(dirname "$0")/.." && pwd)
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
for item in skills scripts README.md LICENSE AGENTS.md CHANGELOG.md \
  .claude-plugin .codex-plugin .antigravity-plugin .agents package.json assets; do
  [ -e "$repo/$item" ] && cp -R "$repo/$item" "$scratch/"
done
mkdir -p "$scratch/docs"
for doc in testing.md; do
  [ -f "$repo/docs/$doc" ] && cp "$repo/docs/$doc" "$scratch/docs/"
done
cd "$scratch"
bash scripts/check-skills.sh > /dev/null || { echo "FAIL: pristine copy does not pass"; exit 1; }

skill=skills/terminal-ux
expect_failure() {
  if bash scripts/check-skills.sh > "$scratch/output" 2>&1; then
    echo "FAIL: checker accepted $1"; exit 1
  fi
  echo "OK: rejects $1"
}
restore() {
  rm -rf "$skill"; cp -R "$repo/$skill" "$skill"
  for f in .claude-plugin .codex-plugin .antigravity-plugin .agents package.json; do
    rm -rf "$f"; cp -R "$repo/$f" "$f"
  done
}

printf '\n[broken](references/missing.md)\n' >> "$skill/SKILL.md"
expect_failure 'missing local link'
restore

printf '\nBuild it with Ratatui.\n' >> "$skill/references/visual-style.md"
expect_failure 'a framework name in a reference'
restore

printf '\nAsk with AskUserQuestion.\n' >> "$skill/SKILL.md"
expect_failure 'Claude-only tool name without a Claude Code label'
restore

printf '# Extra\n' > "$skill/references/extra.md"
printf '\nSee [extra](references/extra.md).\n' >> "$skill/SKILL.md"
expect_failure 'seven reference files'
restore

for r in output-and-resilience visual-style layout-and-interaction prompts-and-microcopy; do
  rm "$skill/references/$r.md"
  sed -i "s#](references/$r.md)#]($r)#g" "$skill/SKILL.md"
done
expect_failure 'two reference files'
restore

sed -i 's#](references/visual-style.md)#](visual style)#g' "$skill/SKILL.md"
expect_failure 'a reference not linked from SKILL.md'
restore

sed -i 's/^name: terminal-ux$/name: terminal-uxx/' "$skill/SKILL.md"
expect_failure 'name that does not match its directory'
restore

long=$(printf 'x%.0s' $(seq 1 1100))
sed -i "s/^description: .*/description: $long/" "$skill/SKILL.md"
expect_failure 'description over 1,024 characters'
restore

seq 1 600 | sed 's/^/filler /' >> "$skill/SKILL.md"
expect_failure 'SKILL.md over 500 lines'
restore

printf '%25000s\n' 'oversized body' >> "$skill/SKILL.md"
expect_failure 'body over 24,000 bytes'
restore

jq '.version = "9.9.9"' .codex-plugin/plugin.json > changed.json && mv changed.json .codex-plugin/plugin.json
expect_failure 'metadata drift'
restore

printf '{broken' > .antigravity-plugin/plugin.json
expect_failure 'malformed manifest'
restore

jq '.plugins[0].source = "./missing"' .agents/plugins/marketplace.json > changed.json && mv changed.json .agents/plugins/marketplace.json
expect_failure 'marketplace target'
restore

bash scripts/check-skills.sh > /dev/null || { echo "FAIL: restored copy no longer passes"; exit 1; }
echo 'checker regression checks passed'
