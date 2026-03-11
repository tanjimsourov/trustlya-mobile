param(
  [string]$AvdName = 'trustlya_api35',
  [ValidateSet('auto', 'host', 'swiftshader', 'software', 'lavapipe', 'swangle')]
  [string]$GpuMode = 'auto'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Set-IniValue {
  param(
    [string]$Path,
    [string]$Key,
    [string]$Value,
    [switch]$CreateIfMissing
  )

  if (-not (Test-Path $Path)) {
    if (-not $CreateIfMissing) {
      return
    }

    $parent = Split-Path -Parent $Path
    if ($parent) {
      New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $lines = @()
  } else {
    $lines = @(Get-Content $Path)
  }

  $escapedKey = [regex]::Escape($Key)
  $updated = $false

  for ($index = 0; $index -lt $lines.Count; $index++) {
    if ($lines[$index] -match "^\s*$escapedKey\s*=") {
      $lines[$index] = "$Key=$Value"
      $updated = $true
    }
  }

  if (-not $updated) {
    $lines += "$Key=$Value"
  }

  Set-Content -Path $Path -Value $lines
}

function Remove-IniValue {
  param(
    [string]$Path,
    [string]$Key
  )

  if (-not (Test-Path $Path)) {
    return
  }

  $escapedKey = [regex]::Escape($Key)
  $lines = @(Get-Content $Path) | Where-Object {
    $_ -notmatch "^\s*$escapedKey\s*="
  }

  Set-Content -Path $Path -Value $lines
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$AvdRoot = Join-Path $RepoRoot ".android\avd\$AvdName.avd"
$ConfigPath = Join-Path $AvdRoot 'config.ini'
$HardwareConfigPath = Join-Path $AvdRoot 'hardware-qemu.ini'
$UserConfigPath = Join-Path $AvdRoot 'emulator-user.ini'

if (-not (Test-Path $AvdRoot)) {
  exit 0
}

Set-IniValue -Path $ConfigPath -Key 'hw.device.manufacturer' -Value 'Generic'
Set-IniValue -Path $ConfigPath -Key 'hw.device.name' -Value 'medium_phone'
Set-IniValue -Path $ConfigPath -Key 'showDeviceFrame' -Value 'no'
Set-IniValue -Path $ConfigPath -Key 'fastboot.forceColdBoot' -Value 'yes'
Set-IniValue -Path $ConfigPath -Key 'fastboot.forceFastBoot' -Value 'no'
Set-IniValue -Path $ConfigPath -Key 'firstboot.bootFromDownloadableSnapshot' -Value 'no'
Set-IniValue -Path $ConfigPath -Key 'firstboot.bootFromLocalSnapshot' -Value 'no'
Set-IniValue -Path $ConfigPath -Key 'firstboot.saveToLocalSnapshot' -Value 'no'
Set-IniValue -Path $ConfigPath -Key 'hw.gpu.enabled' -Value 'yes'
Set-IniValue -Path $ConfigPath -Key 'hw.gpu.mode' -Value $GpuMode

Set-IniValue -Path $HardwareConfigPath -Key 'hw.device.name' -Value 'medium_phone'
Set-IniValue -Path $HardwareConfigPath -Key 'hw.gpu.enabled' -Value 'true'
Set-IniValue -Path $HardwareConfigPath -Key 'hw.gpu.mode' -Value $GpuMode

Set-IniValue -Path $UserConfigPath -Key 'window.scale' -Value '0.300000' -CreateIfMissing
Remove-IniValue -Path $UserConfigPath -Key 'window.x'
Remove-IniValue -Path $UserConfigPath -Key 'window.y'

$cleanupPaths = @(
  (Join-Path $AvdRoot 'snapshots'),
  (Join-Path $AvdRoot 'quickbootChoice.ini'),
  (Join-Path $AvdRoot 'read-snapshot.txt')
)

foreach ($cleanupPath in $cleanupPaths) {
  if (Test-Path $cleanupPath) {
    Remove-Item $cleanupPath -Recurse -Force -ErrorAction SilentlyContinue
  }
}
