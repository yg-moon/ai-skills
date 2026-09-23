---
name: ai-skills-check
description: ai-skills 설치 확인용 임시 스킬. 사용자가 /ai-skills-check 를 호출하거나 ai-skills 설치 상태를 물을 때 사용.
---

아래 명령을 실행하고 결과를 요약한다. 모두 확인되면 "ai-skills 설치 확인 완료" 라고 답한다.

```bash
cat ~/.claude/CLAUDE.md
ls -l ~/.claude/skills
jq .hooks ~/.claude/settings.json
cat /tmp/ai-skills-hook-ran 2>/dev/null || echo "SessionStart hook: NOT RUN"
```
