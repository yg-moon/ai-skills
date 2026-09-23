# 배경

- Claude Code 클라우드 세션은 새 컨테이너에 작업 레포만 clone 해서 시작한다. 로컬 `~/.claude`(전역 CLAUDE.md, 개인 스킬, settings.json 훅)는 넘어오지 않는다.
- 클라우드에서 자동으로 들어오는 것은 (1) 작업 레포 안의 `AGENTS.md` / `CLAUDE.md` / `.claude/`, (2) claude.ai 계정에 켜진 스킬과 커넥터뿐이다. 계정 단위로는 전역 지시사항과 훅을 옮길 방법이 없다.
- 그래서 원본을 이 레포 한 곳에 두고, 로컬과 클라우드 모두 `install.sh` 로 `~/.claude` 를 채운다. 클라우드는 Environment 의 Setup script 에서 실행하므로 그 Environment 를 쓰는 모든 레포 세션에 적용된다.
- 지시사항은 Claude Code, Codex 등이 모두 읽는 `AGENTS.md` 로 쓴다. 레포의 `CLAUDE.md` 는 AGENTS.md 를 못 읽는 구버전 Claude Code 호환용으로 `@AGENTS.md` 한 줄만 둔다.
- 루트 `AGENTS.md` 는 이 레포 작업용 가이드라서, 전역 원본은 `global/AGENTS.md` 로 분리했다. 전역 적용은 `~/.claude/CLAUDE.md` 에서 `@` import 하는 방식으로 한다.

## 확인되지 않은 것

- Setup script 가 Claude Code 가 `~/.claude` 를 읽기 **전에** 실행되는지. 설정 후 새 세션에서 `cat ~/.claude/CLAUDE.md` 와 스킬 호출로 확인할 것.
- 클라우드 하네스가 세션 시작 시 `~/.claude/settings.json` 을 다시 쓰는지 (그렇다면 병합한 훅이 사라진다).

### 확인 방법 (임시)

`global/AGENTS.md` 의 "Install Check", `skills/ai-skills-check`, `hooks/scripts/session-check.sh` 는 설치 확인용 임시 항목이다. Setup script 설정 후 새 세션에서:

1. 응답 끝에 `🧪 ai-skills` 가 붙는지 → 전역 지시사항 적용
2. `/ai-skills-check` 가 호출되는지 → 스킬 적용
3. `/tmp/ai-skills-hook-ran` 에 `cloud` 줄이 있는지 → 훅 적용

확인이 끝나면 세 항목을 지우고 `hooks.json` 을 `{"hooks": {}}` 로 되돌린다.
