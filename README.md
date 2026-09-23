# ai-skills

모든 레포와 환경(로컬 / Claude Code 클라우드)에서 공통으로 쓰는 에이전트 설정 원본.

```
ai-skills/
├── AGENTS.md               # 전역 지시사항 원본
├── skills/<name>/SKILL.md  # 전역 스킬
├── hooks/
│   ├── hooks.json          # settings.json 에 병합될 hooks
│   └── scripts/            # 훅 스크립트
└── install.sh              # ~/.claude 에 설치
```

> 공개 레포다. 토큰, 내부 경로, 개인 정보는 넣지 않는다.

## 설치

### 로컬

```bash
git clone https://github.com/yg-moon/ai-skills ~/.ai-skills
~/.ai-skills/install.sh
```

업데이트는 `git -C ~/.ai-skills pull && ~/.ai-skills/install.sh`.

### Claude Code 클라우드

claude.ai/code → Environment 설정 → Setup script 에 추가:

```bash
git clone --depth 1 https://github.com/yg-moon/ai-skills ~/.ai-skills && ~/.ai-skills/install.sh
```

## install.sh 가 하는 일

| 대상 | 동작 |
|---|---|
| `AGENTS.md` | `~/.claude/CLAUDE.md` 에 `@<repo>/AGENTS.md` import 한 줄 추가. 기존 내용은 유지 |
| `skills/*` | `~/.claude/skills/<name>` 으로 symlink. 레포에서 지운 스킬의 링크는 정리 |
| `hooks/hooks.json` | `~/.claude/settings.json` 의 `hooks` 에 병합 (jq 필요). 이전 설치분만 교체하고 나머지 설정은 유지 |

여러 번 실행해도 결과가 같다.

## 훅 추가하기

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
