# Playwright CLI Workflows

Assume the wrapper is available as `PWCLI`. In PowerShell, invoke it as `& $env:PWCLI ...`; in Bash, invoke it as `"$PWCLI" ...`.

Keep generated browser artifacts in `output/playwright/<label>/` when working inside a repository.

## Standard Interaction Loop

```bash
"$PWCLI" open https://example.com --headed
"$PWCLI" snapshot
"$PWCLI" click e3
"$PWCLI" snapshot
```

Snapshot again after navigation, modals, menu changes, tab switches, or any command that substantially changes the DOM.

## Form Submission

```bash
"$PWCLI" open https://example.com/form --headed
"$PWCLI" snapshot
"$PWCLI" fill e1 "user@example.com"
"$PWCLI" fill e2 "password123"
"$PWCLI" click e3
"$PWCLI" snapshot
"$PWCLI" screenshot --filename=output/playwright/form/result.png
```

## Data Extraction

```bash
"$PWCLI" open https://example.com
"$PWCLI" snapshot
"$PWCLI" --raw eval "document.title"
"$PWCLI" --raw eval "JSON.stringify([...document.querySelectorAll('a')].map(a => a.href))"
```

Use `eval "el => ..."` with a snapshot ref when the data belongs to a specific element:

```bash
"$PWCLI" eval "el => el.textContent" e12
"$PWCLI" eval "el => ({ id: el.id, cls: el.className, testid: el.getAttribute('data-testid') })" e12
```

## Debugging UI Flows

```bash
"$PWCLI" open https://example.com --headed
"$PWCLI" tracing-start
"$PWCLI" snapshot
# reproduce the issue with explicit CLI commands
"$PWCLI" console warning
"$PWCLI" network
"$PWCLI" tracing-stop
"$PWCLI" screenshot --filename=output/playwright/debug/final.png
```

Use `run-code` only when a normal command cannot express the action or inspection.

## Multi-Tab Work

```bash
"$PWCLI" open https://example.com
"$PWCLI" tab-new https://example.com/other
"$PWCLI" tab-list
"$PWCLI" tab-select 0
"$PWCLI" snapshot
```

## Sessions And State

Use sessions to isolate work across projects or preserve auth/state for a flow:

```bash
"$PWCLI" --session checkout open https://example.com/checkout --headed
"$PWCLI" --session checkout snapshot
```

Or set the session once:

```bash
export PLAYWRIGHT_CLI_SESSION=checkout
"$PWCLI" open https://example.com/checkout
```

PowerShell:

```powershell
$env:PLAYWRIGHT_CLI_SESSION = "checkout"
& $env:PWCLI open https://example.com/checkout
```

## Request Mocking

```bash
"$PWCLI" route "https://api.example.com/**" --body='{"ok":true}'
"$PWCLI" route-list
"$PWCLI" unroute "https://api.example.com/**"
```

Read `references/request-mocking.md` for richer mocking patterns.

## Troubleshooting

- If an element ref fails, run `snapshot` again and retry with the new ref.
- If the page looks wrong, reopen with `--headed` and resize the viewport.
- If auth or prior state matters, use a named session or `state-save` / `state-load`.
- If wrapper execution fails because `npx` is missing, ask the user to install Node.js/npm.
- If `npx` needs to download packages in a restricted sandbox, request network escalation for the command.
