#!/usr/bin/env bash
# ai-skills 설치 확인용 임시 SessionStart 훅. 확인 후 hooks.json 에서 빼고 이 파일을 지운다.
env_name=local
[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] && env_name=cloud
printf '%s %s\n' "$(date -u +%FT%TZ)" "$env_name" >> /tmp/ai-skills-hook-ran
echo "ai-skills SessionStart hook ran ($env_name)"
