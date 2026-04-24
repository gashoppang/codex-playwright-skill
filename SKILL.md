---
name: playwright-cli
description: Automate real browser workflows from the terminal with playwright-cli. Use when Codex needs to navigate pages, fill forms, inspect UI state, take snapshots or screenshots, extract page data, debug browser flows, manage cookies/storage/sessions, mock network requests, capture traces or video, or work with Playwright tests when explicitly requested.
---

# Playwright CLI

Drive a real browser from the terminal with `playwright-cli`. Prefer the bundled wrapper so the CLI works without requiring a global install.

Treat this skill as CLI-first browser automation. Do not create or edit `@playwright/test` specs unless the user explicitly asks for test files or test debugging.

## Prerequisite Check

Before proposing runnable commands, check that `npx` is available.

PowerShell:

```powershell
Get-Command npx -ErrorAction SilentlyContinue
```

Bash:

```bash
command -v npx >/dev/null 2>&1
```

If `npx` is missing, pause and ask the user to install Node.js/npm. Provide these verification steps:

```bash
node --version
npm --version
npm install -g @playwright/cli@latest
playwright-cli --help
```

## Wrapper Setup

Use the wrapper matching the current shell. The wrapper runs `npx --yes --package @playwright/cli playwright-cli` and injects `PLAYWRIGHT_CLI_SESSION` when the user has not passed `--session` or `-s`.

PowerShell:

```powershell
$env:CODEX_HOME = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { "$HOME\.codex" }
$env:PWCLI = Join-Path $env:CODEX_HOME "skills\playwright-cli\scripts\playwright_cli.ps1"
& $env:PWCLI --help
```

Bash:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export PWCLI="$CODEX_HOME/skills/playwright-cli/scripts/playwright_cli.sh"
"$PWCLI" --help
```

If the repository already standardizes on a global `playwright-cli`, using `playwright-cli ...` directly is acceptable.

## Core Loop

1. Open or attach to a browser.
2. Take a snapshot before interacting with element refs.
3. Interact using refs from the latest snapshot.
4. Re-snapshot after navigation, modal/menu changes, tab switches, or substantial DOM updates.
5. Capture screenshots, PDFs, traces, videos, console output, or network logs when useful.

Minimal flow:

```bash
"$PWCLI" open https://example.com --headed
"$PWCLI" snapshot
"$PWCLI" click e3
"$PWCLI" snapshot
```

PowerShell equivalent:

```powershell
& $env:PWCLI open https://example.com --headed
& $env:PWCLI snapshot
& $env:PWCLI click e3
& $env:PWCLI snapshot
```

## Guardrails

- Always snapshot before using refs such as `e12`.
- Re-snapshot when refs are stale or after the UI changes.
- Prefer explicit CLI commands over `eval` or `run-code`; use code execution only when normal commands cannot inspect or perform the task.
- Use `--headed` when visual confirmation matters.
- Keep artifacts inside `output/playwright/<label>/` when working in a repo.
- Use named sessions for parallel projects or flows that require saved state.
- Be careful with persistent profiles and stored auth; only use them when the task benefits from browser state reuse.
- Prefer CLI workflows over Playwright test specs unless tests are the user's stated goal.

## Common Commands

```bash
"$PWCLI" open https://example.com --headed
"$PWCLI" snapshot
"$PWCLI" fill e1 "user@example.com"
"$PWCLI" click e3
"$PWCLI" screenshot --filename=output/playwright/check/page.png
"$PWCLI" console warning
"$PWCLI" network
"$PWCLI" close
```

For raw extraction, use `--raw`:

```bash
"$PWCLI" --raw eval "document.title"
"$PWCLI" --raw eval "JSON.stringify([...document.querySelectorAll('a')].map(a => a.href))"
```

## References

Open only what is needed:

- CLI command reference: `references/cli.md`
- Practical workflows and troubleshooting: `references/workflows.md`
- Running and debugging Playwright tests: `references/playwright-tests.md`
- Request mocking: `references/request-mocking.md`
- Running Playwright code: `references/running-code.md`
- Browser session management: `references/session-management.md`
- Storage state: `references/storage-state.md`
- Test generation: `references/test-generation.md`
- Tracing: `references/tracing.md`
- Video recording: `references/video-recording.md`
- Inspecting element attributes: `references/element-attributes.md`
