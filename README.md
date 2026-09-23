# ai-skills

모든 레포와 환경(로컬 / Claude Code 클라우드)에서 공통으로 쓰는 에이전트 설정 원본. 공개 레포이므로 비밀 정보는 넣지 않는다.

```
global/AGENTS.md        # 전역 지시사항
AGENTS.md               # 이 레포 작업 가이드
skills/<name>/SKILL.md  # 전역 스킬
hooks/hooks.json        # 전역 훅 (docs/hooks.md)
install.sh              # ~/.claude 에 설치
```

## 설치

```bash
# 로컬 (업데이트: git pull 후 install.sh 재실행)
git clone https://github.com/yg-moon/ai-skills ~/.ai-skills && ~/.ai-skills/install.sh

# 클라우드: claude.ai/code → Environment → Setup script
git clone --depth 1 https://github.com/yg-moon/ai-skills ~/.ai-skills && ~/.ai-skills/install.sh
```

`install.sh` 는 `~/.claude` 에 전역 지시사항 import, 스킬 symlink, 훅 병합을 한다. 기존 설정은 유지하고, 여러 번 실행해도 결과가 같다.

배경과 미확인 사항: [docs/background.md](docs/background.md)
