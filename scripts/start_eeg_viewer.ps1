param(
    [string]$Recording = "",
    [double]$Seconds = 90,
    [string]$LslStreamName = "Unicorn"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$python = Join-Path $root ".venv\Scripts\python.exe"
$frontend = Join-Path $root "frontend"
$serverScript = Join-Path $root "scripts\10_eeg_wave_server.py"

if (-not (Test-Path $python)) {
    throw "Missing .venv Python environment. Install requirements.txt first."
}
if (-not (Test-Path (Join-Path $frontend "node_modules"))) {
    throw "Missing frontend dependencies. Run npm install in frontend first."
}
if ($Recording -eq "") {
    $Recording = Join-Path $root "EEG_flipcup\Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt"
}
if (-not (Test-Path $Recording -PathType Leaf)) {
    throw "EEG recording does not exist: $Recording"
}
if ($Seconds -le 0) {
    throw "Seconds must be positive."
}

$serverArguments = @(
    "`"$serverScript`"",
    "--file", "`"$Recording`"",
    "--seconds", $Seconds,
    "--lsl-stream-name", "`"$LslStreamName`""
)
$server = Start-Process -FilePath $python -ArgumentList $serverArguments -PassThru
$web = Start-Process -FilePath "npm.cmd" -ArgumentList @("run", "dev") `
    -WorkingDirectory $frontend -PassThru

try {
    $deadline = (Get-Date).AddSeconds(15)
    do {
        if ($server.HasExited) {
            throw "EEG replay server exited before becoming ready."
        }
        if ($web.HasExited) {
            throw "Frontend server exited before becoming ready."
        }
        $webReady = Get-NetTCPConnection -LocalPort 5173 -State Listen `
            -ErrorAction SilentlyContinue
        $eegReady = Get-NetTCPConnection -LocalPort 8765 -State Listen `
            -ErrorAction SilentlyContinue
        $ready = $null -ne $webReady -and $null -ne $eegReady
        if (-not $ready) {
            Start-Sleep -Milliseconds 250
        }
    } until ($ready -or (Get-Date) -ge $deadline)

    if (-not $ready) {
        throw "Frontend did not become ready on http://127.0.0.1:5173."
    }
    Start-Process "http://127.0.0.1:5173"
    Wait-Process -Id $web.Id
}
finally {
    if (-not $server.HasExited) {
        taskkill /PID $server.Id /T /F | Out-Null
    }
    if (-not $web.HasExited) {
        taskkill /PID $web.Id /T /F | Out-Null
    }
}
