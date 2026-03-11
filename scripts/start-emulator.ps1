param(
  [string]$AvdName = 'trustlya_api35',
  [switch]$WipeData,
  [ValidateSet('auto', 'host', 'swiftshader', 'software', 'lavapipe', 'swangle')]
  [string]$GpuMode = 'auto'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-EmulatorDeviceId {
  param([string]$AdbPath)

  $line = & $AdbPath devices | Select-String '^(emulator-\d+)\s+device$' | Select-Object -First 1
  if (-not $line) {
    return $null
  }

  return $line.Matches[0].Groups[1].Value
}

function Stop-EmulatorProcesses {
  Get-Process -ErrorAction SilentlyContinue | Where-Object {
    $_.ProcessName -in @('emulator', 'qemu-system-x86_64', 'crashpad_handler')
  } | Stop-Process -Force -ErrorAction SilentlyContinue
}

function Stop-CrashpadProcesses {
  Get-Process -ErrorAction SilentlyContinue | Where-Object {
    $_.ProcessName -eq 'crashpad_handler'
  } | Stop-Process -Force -ErrorAction SilentlyContinue
}

function Wait-For-EmulatorReady {
  param(
    [string]$AdbPath,
    [string]$AvdName,
    [int]$DiscoveryAttempts = 90,
    [int]$BootAttempts = 120
  )

  for ($attempt = 0; $attempt -lt $DiscoveryAttempts; $attempt++) {
    $deviceId = Get-EmulatorDeviceId -AdbPath $AdbPath
    if ($deviceId) {
      for ($bootAttempt = 0; $bootAttempt -lt $BootAttempts; $bootAttempt++) {
        $bootState = (& $AdbPath -s $deviceId shell getprop sys.boot_completed 2>$null).Trim()
        if ($bootState -eq '1') {
          Write-Host "Android emulator '$AvdName' is ready as $deviceId."
          return
        }

        Start-Sleep -Seconds 2
      }

      throw "Android emulator '$AvdName' did not finish booting in time."
    }

    Start-Sleep -Seconds 2
  }

  throw "Android emulator '$AvdName' was started, but no adb device appeared."
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$AndroidHome = Join-Path $RepoRoot '.android'
$AndroidAvdHome = Join-Path $AndroidHome 'avd'
$AndroidSdkRoot = Join-Path $RepoRoot '.android-sdk'
$EmulatorExe = Join-Path $RepoRoot '.android-sdk\emulator\emulator.exe'
$AdbExe = Join-Path $AndroidSdkRoot 'platform-tools\adb.exe'
$AvdIni = Join-Path $AndroidAvdHome "$AvdName.ini"
$RepairScript = Join-Path $PSScriptRoot 'repair-emulator-avd.ps1'

if (-not (Test-Path $EmulatorExe)) {
  throw "Android emulator was not found at '$EmulatorExe'."
}

if (-not (Test-Path $AdbExe)) {
  throw "adb was not found at '$AdbExe'."
}

if (-not (Test-Path $AvdIni)) {
  throw "AVD '$AvdName' was not found at '$AvdIni'."
}

$env:ANDROID_HOME = $AndroidSdkRoot
$env:ANDROID_SDK_ROOT = $AndroidSdkRoot
$env:ANDROID_USER_HOME = $AndroidHome
$env:ANDROID_EMULATOR_HOME = $AndroidHome
$env:ANDROID_AVD_HOME = $AndroidAvdHome
$env:ANDROID_SDK_HOME = $RepoRoot
$env:HOME = $RepoRoot
$env:USERPROFILE = $RepoRoot
$homeDrive = [System.IO.Path]::GetPathRoot($RepoRoot).TrimEnd('\')
$env:HOMEDRIVE = $homeDrive
$env:HOMEPATH = $RepoRoot.Substring($homeDrive.Length)

Stop-CrashpadProcesses

$existingProcess = Get-Process -ErrorAction SilentlyContinue | Where-Object {
  $_.ProcessName -in @('emulator', 'qemu-system-x86_64')
} | Select-Object -First 1

if ($existingProcess) {
  Write-Host "Android emulator is already running (PID $($existingProcess.Id))."
  try {
    Wait-For-EmulatorReady -AdbPath $AdbExe -AvdName $AvdName -DiscoveryAttempts 15 -BootAttempts 30
    exit 0
  } catch {
    Write-Host 'Existing emulator instance is unhealthy. Restarting it...'
    Stop-EmulatorProcesses
  }
}

if (Test-Path $RepairScript) {
  & $RepairScript -AvdName $AvdName -GpuMode $GpuMode
}

$emulatorArgs = @(
  '-avd', $AvdName,
  '-no-snapshot-load',
  '-no-boot-anim',
  '-no-metrics',
  '-crash-report-mode', 'disabled',
  '-gpu', $GpuMode
)

if ($WipeData) {
  $emulatorArgs += '-wipe-data'
}

$process = Start-Process -FilePath $EmulatorExe -ArgumentList $emulatorArgs -PassThru

Write-Host "Started Android emulator '$AvdName' (PID $($process.Id))."
Wait-For-EmulatorReady -AdbPath $AdbExe -AvdName $AvdName
