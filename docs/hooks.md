# 훅 추가하기

스크립트는 `hooks/scripts/` 에 두고, `hooks.json` 에서는 `{{AI_SKILLS_DIR}}` 로 레포 경로를 참조한다.

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          { "type": "command", "command": "{{AI_SKILLS_DIR}}/hooks/scripts/example.sh" }
        ]
      }
    ]
  }
}
```

로컬 전용 명령(예: macOS 알림)을 쓰는 훅은 클라우드에서 실패하므로 `CLAUDE_CODE_REMOTE` 환경변수로 분기한다.

```bash
[ "$CLAUDE_CODE_REMOTE" = "true" ] && exit 0
```
