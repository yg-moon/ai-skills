# ai-skills

모든 레포와 환경(로컬 / Claude Code 클라우드)에서 공통으로 쓰는 에이전트 설정 원본.

```
ai-skills/
├── global/AGENTS.md        # 전역 지시사항 원본 (install.sh 로 전역 적용)
├── AGENTS.md               # 이 레포 자체를 수정할 때의 작업 가이드 (Codex 등)
├── CLAUDE.md               # @AGENTS.md — Claude Code 용 진입점
├── skills/<name>/SKILL.md  # 전역 스킬
├── hooks/
│   ├── hooks.json          # settings.json 에 병합될 hooks
│   └── scripts/            # 훅 스크립트
└── install.sh              # ~/.claude 에 설치
```

> 공개 레포다. 토큰, 내부 경로, 개인 정보는 넣지 않는다.

## 배경

- Claude Code 클라우드 세션은 새 컨테이너에 작업 레포만 clone 해서 시작한다. 로컬 `~/.claude`(전역 CLAUDE.md, 개인 스킬, settings.json 훅)는 넘어오지 않는다.
- 클라우드에서 자동으로 들어오는 것은 (1) 작업 레포 안의 `CLAUDE.md` / `.claude/`, (2) claude.ai 계정에 켜진 스킬과 커넥터뿐이다. 계정 단위로는 전역 지시사항과 훅을 옮길 방법이 없다.
- 그래서 원본을 이 레포 한 곳에 두고, 로컬과 클라우드 모두 `install.sh` 로 `~/.claude` 를 채운다. 클라우드는 Environment 의 Setup script 에서 실행하므로 그 Environment 를 쓰는 모든 레포 세션에 적용된다.
- Claude Code 는 `AGENTS.md` 를 직접 읽지 않고 `CLAUDE.md` 를 읽는다. 원본은 다른 도구와도 호환되도록 `AGENTS.md` 형식으로 두고, `~/.claude/CLAUDE.md` 에서 `@` import 한다.
- 루트 `AGENTS.md` 는 이 레포 작업용 가이드라서, 전역 원본은 `global/AGENTS.md` 로 분리했다. 루트 `CLAUDE.md` 는 `@AGENTS.md` 한 줄로 Claude Code 도 같은 가이드를 읽게 한다.

### 확인되지 않은 것

- Setup script 가 Claude Code 가 `~/.claude` 를 읽기 **전에** 실행되는지. 설정 후 새 세션에서 `cat ~/.claude/CLAUDE.md` 와 스킬 호출로 확인할 것.
- 클라우드 하네스가 세션 시작 시 `~/.claude/settings.json` 을 다시 쓰는지 (그렇다면 병합한 훅이 사라진다).

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
| `global/AGENTS.md` | `~/.claude/CLAUDE.md` 에 `@<repo>/global/AGENTS.md` import 한 줄 추가. 기존 내용은 유지 |
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
