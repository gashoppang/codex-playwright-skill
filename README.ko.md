# playwright-cli Codex Skill

[한국어](./README.ko.md) | [English](./README.md)

Codex가 터미널에서 실제 브라우저를 자동화할 수 있도록 만든 `playwright-cli` 스킬입니다. OpenAI curated `playwright` 스킬의 Codex용 guardrail과 기존 `playwright-cli` 스킬의 상세 명령 레퍼런스를 합쳐, 스냅샷 기반 브라우저 조작과 디버깅 흐름을 바로 사용할 수 있게 정리했습니다.

## 지원하는 작업

- 페이지 열기, 이동, 새로고침, 뒤로/앞으로 이동
- 스냅샷 기반 요소 선택과 클릭, 입력, 선택, 체크, 드래그
- 폼 입력과 제출
- 스크린샷, PDF, trace, video 저장
- 콘솔 경고와 네트워크 요청 확인
- 쿠키, localStorage, sessionStorage, storage state 관리
- named session 기반 브라우저 세션 분리
- 요청 모킹과 라우팅
- Playwright 테스트 실행/디버깅/생성 보조

## 요구 사항

- Node.js와 npm
- `npx` 사용 가능 환경
- Codex 스킬 디렉터리

확인:

```bash
node --version
npm --version
npx --version
```

`npx`가 없다면 Node.js/npm을 먼저 설치한 뒤 다시 확인합니다.

## 설치

이 폴더 전체를 Codex 스킬 디렉터리 아래에 복사합니다.

Windows 기본 경로:

```text
C:\Users\<사용자명>\.codex\skills\playwright-cli
```

macOS/Linux 기본 경로:

```text
~/.codex/skills/playwright-cli
```

최종 구조:

```text
playwright-cli/
├─ SKILL.md
├─ README.md
├─ README.ko.md
├─ SUMMARY.md
├─ agents/
│  └─ openai.yaml
├─ scripts/
│  ├─ playwright_cli.ps1
│  └─ playwright_cli.sh
└─ references/
   ├─ cli.md
   ├─ workflows.md
   └─ ...
```

설치 후 Codex를 재시작하면 스킬이 감지됩니다.

## 빠른 시작

PowerShell:

```powershell
$env:CODEX_HOME = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { "$HOME\.codex" }
$env:PWCLI = Join-Path $env:CODEX_HOME "skills\playwright-cli\scripts\playwright_cli.ps1"
& $env:PWCLI open https://example.com --headed
& $env:PWCLI snapshot
```

Bash:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export PWCLI="$CODEX_HOME/skills/playwright-cli/scripts/playwright_cli.sh"
"$PWCLI" open https://example.com --headed
"$PWCLI" snapshot
```

래퍼는 내부적으로 다음 명령을 사용합니다.

```bash
npx --yes --package @playwright/cli playwright-cli
```

따라서 전역 `playwright-cli` 설치가 없어도 동작합니다.

## 기본 워크플로

1. 브라우저를 엽니다.
2. `snapshot`으로 현재 페이지 상태와 element ref를 얻습니다.
3. 최신 snapshot의 ref로 클릭, 입력, 선택 같은 조작을 합니다.
4. 화면 전환, 모달, 메뉴, 탭 변경, 큰 DOM 변경 뒤에는 다시 snapshot을 찍습니다.
5. 필요한 경우 스크린샷, trace, console, network 결과를 저장합니다.

예시:

```bash
"$PWCLI" open https://example.com --headed
"$PWCLI" snapshot
"$PWCLI" click e3
"$PWCLI" snapshot
"$PWCLI" screenshot --filename=output/playwright/example/final.png
```

PowerShell에서는 이렇게 호출합니다.

```powershell
& $env:PWCLI open https://example.com --headed
& $env:PWCLI snapshot
& $env:PWCLI click e3
& $env:PWCLI snapshot
& $env:PWCLI screenshot --filename=output/playwright/example/final.png
```

## 세션 사용

여러 작업을 분리하거나 로그인 상태를 유지해야 할 때 named session을 사용합니다.

```bash
"$PWCLI" --session checkout open https://example.com/checkout --headed
"$PWCLI" --session checkout snapshot
```

환경 변수로 기본 세션을 지정할 수도 있습니다.

PowerShell:

```powershell
$env:PLAYWRIGHT_CLI_SESSION = "checkout"
& $env:PWCLI open https://example.com/checkout
```

Bash:

```bash
export PLAYWRIGHT_CLI_SESSION=checkout
"$PWCLI" open https://example.com/checkout
```

## 참고 문서

- `references/cli.md`: 주요 `playwright-cli` 명령 모음
- `references/workflows.md`: 실무 워크플로와 문제 해결
- `references/playwright-tests.md`: Playwright 테스트 실행/디버깅
- `references/request-mocking.md`: 요청 모킹
- `references/running-code.md`: Playwright 코드 실행
- `references/session-management.md`: 브라우저 세션 관리
- `references/storage-state.md`: 쿠키와 storage state 관리
- `references/test-generation.md`: 테스트 생성
- `references/tracing.md`: trace 캡처
- `references/video-recording.md`: 비디오 기록
- `references/element-attributes.md`: 요소 속성 확인

## 배포할 때 제외할 것

다음 파일이나 폴더는 배포하지 않는 편이 좋습니다.

- `node_modules/`
- `.playwright-cli/`
- `output/playwright/`
- trace, screenshot, video 같은 실행 산출물
- 로그인 쿠키, auth state, storage state 등 개인 인증 정보

## Bash 실행 권한

macOS/Linux 사용자를 위해 Git에서 Bash 래퍼 실행 권한을 보존하려면:

```bash
git update-index --chmod=+x playwright-cli/scripts/playwright_cli.sh
```

리포 안에서 `skills/playwright-cli/` 형태로 배포한다면 경로를 맞춰 실행합니다.

```bash
git update-index --chmod=+x skills/playwright-cli/scripts/playwright_cli.sh
```
