# Playwright CLI Command Reference

Assume `PWCLI` points at the wrapper. Use direct `playwright-cli` only when the project already provides it globally.

## Core

```bash
"$PWCLI" open
"$PWCLI" open https://example.com --headed
"$PWCLI" goto https://playwright.dev
"$PWCLI" snapshot
"$PWCLI" click e3
"$PWCLI" dblclick e7
"$PWCLI" type "search query"
"$PWCLI" press Enter
"$PWCLI" fill e5 "user@example.com"
"$PWCLI" fill e5 "user@example.com" --submit
"$PWCLI" drag e2 e8
"$PWCLI" hover e4
"$PWCLI" select e9 "option-value"
"$PWCLI" upload ./document.pdf
"$PWCLI" check e12
"$PWCLI" uncheck e12
"$PWCLI" eval "document.title"
"$PWCLI" eval "el => el.textContent" e5
"$PWCLI" eval "el => el.getAttribute('data-testid')" e5
"$PWCLI" dialog-accept
"$PWCLI" dialog-accept "confirmation text"
"$PWCLI" dialog-dismiss
"$PWCLI" resize 1920 1080
"$PWCLI" close
```

## Navigation

```bash
"$PWCLI" go-back
"$PWCLI" go-forward
"$PWCLI" reload
```

## Keyboard And Mouse

```bash
"$PWCLI" press ArrowDown
"$PWCLI" keydown Shift
"$PWCLI" keyup Shift
"$PWCLI" mousemove 150 300
"$PWCLI" mousedown
"$PWCLI" mouseup
"$PWCLI" mousewheel 0 100
```

## Artifacts

```bash
"$PWCLI" screenshot
"$PWCLI" screenshot e5
"$PWCLI" screenshot --filename=output/playwright/check/page.png
"$PWCLI" pdf --filename=output/playwright/check/page.pdf
```

## Tabs

```bash
"$PWCLI" tab-list
"$PWCLI" tab-new
"$PWCLI" tab-new https://example.com/page
"$PWCLI" tab-close
"$PWCLI" tab-close 2
"$PWCLI" tab-select 0
```

## Storage

```bash
"$PWCLI" state-save
"$PWCLI" state-save auth.json
"$PWCLI" state-load auth.json
"$PWCLI" cookie-list
"$PWCLI" cookie-get session_id
"$PWCLI" cookie-set session_id abc123 --domain=example.com --httpOnly --secure
"$PWCLI" cookie-delete session_id
"$PWCLI" cookie-clear
"$PWCLI" localstorage-list
"$PWCLI" localstorage-get theme
"$PWCLI" localstorage-set theme dark
"$PWCLI" localstorage-delete theme
"$PWCLI" localstorage-clear
"$PWCLI" sessionstorage-list
"$PWCLI" sessionstorage-get step
"$PWCLI" sessionstorage-set step 3
"$PWCLI" sessionstorage-delete step
"$PWCLI" sessionstorage-clear
```

## Network And DevTools

```bash
"$PWCLI" route "**/*.jpg" --status=404
"$PWCLI" route "https://api.example.com/**" --body='{"mock": true}'
"$PWCLI" route-list
"$PWCLI" unroute "**/*.jpg"
"$PWCLI" unroute
"$PWCLI" console
"$PWCLI" console warning
"$PWCLI" network
"$PWCLI" run-code "async page => await page.context().grantPermissions(['geolocation'])"
"$PWCLI" run-code --filename=script.js
```

## Tracing And Video

```bash
"$PWCLI" tracing-start
"$PWCLI" tracing-stop
"$PWCLI" video-start video.webm
"$PWCLI" video-chapter "Chapter Title" --description="Details" --duration=2000
"$PWCLI" video-stop
```

## Sessions

```bash
"$PWCLI" --session todo open https://demo.playwright.dev/todomvc
"$PWCLI" --session todo snapshot
PLAYWRIGHT_CLI_SESSION=todo "$PWCLI" open https://demo.playwright.dev/todomvc
"$PWCLI" list
"$PWCLI" close-all
"$PWCLI" kill-all
```

## Snapshots

Use snapshots to get refs and to inspect the page state.

```bash
"$PWCLI" snapshot
"$PWCLI" snapshot --filename=after-click.yaml
"$PWCLI" snapshot "#main"
"$PWCLI" snapshot --depth=4
"$PWCLI" snapshot e34
```

## Raw Output

Use `--raw` when piping or extracting values.

```bash
"$PWCLI" --raw eval "document.title"
"$PWCLI" --raw snapshot > before.yml
"$PWCLI" click e5
"$PWCLI" --raw snapshot > after.yml
"$PWCLI" --raw cookie-get session_id
```
