#!/usr/bin/env bash
# ai-skills installer: links this repo's global agent config into ~/.claude.
# Idempotent — safe to re-run after `git pull`.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

log() { printf '[ai-skills] %s\n' "$*"; }
warn() { printf '[ai-skills] WARN: %s\n' "$*" >&2; }

mkdir -p "$CLAUDE_DIR/skills"

# 1. CLAUDE.md -> import AGENTS.md
#    Claude Code reads CLAUDE.md, not AGENTS.md, so add an @import line.
#    An existing CLAUDE.md is kept; the import line is appended once.
claude_md="$CLAUDE_DIR/CLAUDE.md"
import_line="@$REPO_DIR/AGENTS.md"
if [ -f "$claude_md" ] && grep -qxF "$import_line" "$claude_md"; then
  log "CLAUDE.md already imports AGENTS.md"
else
  [ -s "$claude_md" ] && printf '\n' >> "$claude_md"
  printf '%s\n' "$import_line" >> "$claude_md"
  log "CLAUDE.md -> $import_line"
fi

# 2. Skills -> symlink each skills/<name>/ into ~/.claude/skills/<name>
#    Links left behind by skills since removed from this repo are cleaned up.
for link in "$CLAUDE_DIR"/skills/*; do
  if [ -L "$link" ] && [ ! -e "$link" ] && [[ "$(readlink "$link")" == "$REPO_DIR/skills/"* ]]; then
    rm "$link"
    log "removed stale skill: $(basename "$link")"
  fi
done
for skill in "$REPO_DIR"/skills/*/; do
  [ -f "$skill/SKILL.md" ] || continue
  name="$(basename "$skill")"
  target="$CLAUDE_DIR/skills/$name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    warn "skip skill '$name': $target exists and is not a symlink"
    continue
  fi
  ln -sfn "${skill%/}" "$target"
  log "skill: $name"
done

# 3. Hooks -> merge hooks/hooks.json into ~/.claude/settings.json
#    Hook groups from a previous install (any command under $REPO_DIR) are
#    replaced; everything else in settings.json is left untouched.
#    Use {{AI_SKILLS_DIR}} in hooks.json commands to reference this repo.
if ! command -v jq >/dev/null 2>&1; then
  warn "jq not found; skipping hooks merge"
else
  settings="$CLAUDE_DIR/settings.json"
  [ -s "$settings" ] || echo '{}' > "$settings"
  new_hooks="$(sed "s|{{AI_SKILLS_DIR}}|$REPO_DIR|g" "$REPO_DIR/hooks/hooks.json")"
  tmp="$(mktemp)"
  jq --argjson new "$new_hooks" --arg dir "$REPO_DIR/" '
    def ours: any(.hooks[]?; (.command // "") | contains($dir));
    .hooks = ((.hooks // {}) | map_values(map(select(ours | not))))
    | reduce (($new.hooks // {}) | to_entries[]) as $e (.;
        .hooks[$e.key] = ((.hooks[$e.key] // []) + $e.value))
    | .hooks |= with_entries(select(.value | length > 0))
    | if .hooks == {} then del(.hooks) else . end
  ' "$settings" > "$tmp"
  mv "$tmp" "$settings"
  log "hooks merged into $settings"
fi

log "done"
