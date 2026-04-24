# playwright-cli Codex Skill

English | [한국어](./README.ko.md)

This `playwright-cli` skill enables Codex to automate a real browser from the terminal. It combines guardrails from OpenAI's curated `playwright` skill with the detailed command reference from the existing `playwright-cli` skill so you can immediately use snapshot-based browser control and debugging workflows.

## Supported Tasks

- Open, navigate, refresh, and move back/forward in pages
- Snapshot-based element targeting with click, type, select, check, and drag actions
- Fill and submit forms
- Save screenshots, PDFs, traces, and videos
- Inspect console warnings and network requests
- Manage cookies, localStorage, sessionStorage, and storage state
- Separate browser contexts with named sessions
- Route and mock network requests
- Assist with Playwright test run/debug/generation workflows

## Requirements

- Node.js and npm
- Environment with `npx` available
- Codex skills directory

Check:

```bash
node --version
npm --version
npx --version
```

If `npx` is missing, install Node.js/npm first and check again.

## Installation

Copy this entire folder under your Codex skills directory.

Default Windows path:

```text
C:\Users\<username>\.codex\skills\playwright-cli
```

Default macOS/Linux path:

```text
~/.codex/skills/playwright-cli
```

Final structure:

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

Restart Codex after installation so the skill is detected.

## Quick Start

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

The wrappers call the command below internally:

```bash
npx --yes --package @playwright/cli playwright-cli
```

So it works without a global `playwright-cli` install.

## Basic Workflow

1. Open a browser.
2. Run `snapshot` to get current page state and element refs.
3. Use refs from the latest snapshot for actions like click/type/select.
4. Re-run `snapshot` after major DOM changes (navigation, modal/menu/tab changes, etc.).
5. Save screenshots/traces/console/network outputs when needed.

Example:

```bash
"$PWCLI" open https://example.com --headed
"$PWCLI" snapshot
"$PWCLI" click e3
"$PWCLI" snapshot
"$PWCLI" screenshot --filename=output/playwright/example/final.png
```

PowerShell equivalent:

```powershell
& $env:PWCLI open https://example.com --headed
& $env:PWCLI snapshot
& $env:PWCLI click e3
& $env:PWCLI snapshot
& $env:PWCLI screenshot --filename=output/playwright/example/final.png
```

## Using Sessions

Use named sessions when you need isolated flows or persistent login state.

```bash
"$PWCLI" --session checkout open https://example.com/checkout --headed
"$PWCLI" --session checkout snapshot
```

You can also set a default session via environment variable.

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

## References

- `references/cli.md`: Key `playwright-cli` commands
- `references/workflows.md`: Practical workflows and troubleshooting
- `references/playwright-tests.md`: Run/debug Playwright tests
- `references/request-mocking.md`: Request mocking
- `references/running-code.md`: Execute Playwright code
- `references/session-management.md`: Browser session management
- `references/storage-state.md`: Cookies and storage state
- `references/test-generation.md`: Test generation
- `references/tracing.md`: Trace capture
- `references/video-recording.md`: Video recording
- `references/element-attributes.md`: Element attributes

## What to Exclude When Packaging

It is generally best to exclude:

- `node_modules/`
- `.playwright-cli/`
- `output/playwright/`
- Runtime artifacts such as trace/screenshot/video outputs
- Sensitive auth data such as login cookies/auth state/storage state

## Bash Execute Permission

To preserve Bash wrapper execute permission in Git on macOS/Linux:

```bash
git update-index --chmod=+x playwright-cli/scripts/playwright_cli.sh
```

If you package it under `skills/playwright-cli/` inside a repo, run with that path:

```bash
git update-index --chmod=+x skills/playwright-cli/scripts/playwright_cli.sh
```
