[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$CliArgs
)

$npxCommand = Get-Command npx -ErrorAction SilentlyContinue
if (-not $npxCommand) {
    Write-Error "Error: npx is required but was not found on PATH."
    exit 1
}

$hasSessionFlag = $false
foreach ($arg in $CliArgs) {
    if ($arg -eq "--session" -or $arg -like "--session=*" -or $arg -eq "-s" -or $arg -like "-s=*") {
        $hasSessionFlag = $true
        break
    }
}

$npxArgs = @("--yes", "--package", "@playwright/cli", "playwright-cli")
if (-not $hasSessionFlag -and -not [string]::IsNullOrWhiteSpace($env:PLAYWRIGHT_CLI_SESSION)) {
    $npxArgs += @("--session", $env:PLAYWRIGHT_CLI_SESSION)
}

$npxArgs += $CliArgs
& npx @npxArgs
exit $LASTEXITCODE
