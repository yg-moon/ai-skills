# ai-skills — 작업 가이드

이 레포는 모든 레포/환경에 설치되는 전역 에이전트 설정의 원본이다. 설치 방법은 README.md, 배경은 docs/background.md, 훅 작성법은 docs/hooks.md 참고.

## 이 레포에서 작업할 때

- 공개 레포다. 토큰, 내부 호스트명, 개인 정보, 로컬 절대경로를 커밋하지 않는다.
- 이 파일은 이 레포 작업용 가이드다. 전역 지시사항 원본은 `global/AGENTS.md` 이고, 모든 세션에 전역으로 로드된다. 짧고 범용적으로 유지하고, 특정 레포 전용 내용은 넣지 않는다.
- 스킬은 `skills/<name>/SKILL.md` 형식. 폴더 이름과 frontmatter `name` 을 일치시킨다.
- 훅 명령은 `hooks/hooks.json` 에 쓰고 레포 경로는 `{{AI_SKILLS_DIR}}` 로 참조한다. 스크립트는 `hooks/scripts/` 에 두고 실행 권한을 준다. 로컬 전용 동작은 `CLAUDE_CODE_REMOTE=true` 일 때 건너뛴다.
- `install.sh` 는 멱등이어야 하고 사용자의 기존 `~/.claude` 설정을 덮어쓰면 안 된다. 수정 후에는 임시 HOME 으로 검증한다:

  ```bash
  T=$(mktemp -d) && HOME=$T ./install.sh && HOME=$T ./install.sh && cat $T/.claude/settings.json
  ```

- 레포 가이드는 이 파일에만 쓴다. `CLAUDE.md` 는 AGENTS.md 를 못 읽는 구버전 Claude Code 호환용으로 `@AGENTS.md` 한 줄만 유지한다.
- 구조나 `install.sh` 동작을 바꾸면 README.md 도 같이 갱신한다.
