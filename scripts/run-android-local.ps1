param(
  [string]$FlutterBin = '',
  [string]$AvdName = 'trustlya_api35',
  [string]$SystemImage = 'system-images;android-35;google_apis;x86_64',
  [string]$PlatformPackage = 'platforms;android-35',
  [string]$BuildToolsPackage = 'build-tools;35.0.0',
  [switch]$WipeData,
  [ValidateSet('auto', 'host', 'swiftshader', 'software', 'lavapipe', 'swangle')]
  [string]$GpuMode = 'auto'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Require-Command {
  param([string]$Name)

  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Required command '$Name' was not found."
  }
}

function Assert-LastExitCode {
  param([string]$Action)

  if ($LASTEXITCODE -ne 0) {
    throw "$Action failed with exit code $LASTEXITCODE."
  }
}

function Accept-AndroidLicenses {
  param(
    [string]$SdkManager,
    [string]$AndroidSdkRoot
  )

  $sdkManagerEscaped = $SdkManager.Replace('"', '""')
  $androidSdkRootEscaped = $AndroidSdkRoot.Replace('"', '""')
  $acceptCommand = "(for /l %i in (1,1,40) do @echo y) | ""$sdkManagerEscaped"" --sdk_root=""$androidSdkRootEscaped"" --licenses"
  cmd /c $acceptCommand | Out-Null
  Assert-LastExitCode -Action 'Android SDK license acceptance'
}

function Resolve-FlutterBin {
  param([string]$ConfiguredPath)

  if ($ConfiguredPath -and (Test-Path $ConfiguredPath)) {
    return (Resolve-Path $ConfiguredPath).Path
  }

  if ($env:FLUTTER_ROOT) {
    $candidate = Join-Path $env:FLUTTER_ROOT 'bin\flutter.bat'
    if (Test-Path $candidate) {
      return (Resolve-Path $candidate).Path
    }
  }

  $command = Get-Command flutter -ErrorAction SilentlyContinue
  if ($command) {
    return $command.Source
  }

  $defaultPath = 'C:\flutter\bin\flutter.bat'
  if (Test-Path $defaultPath) {
    return (Resolve-Path $defaultPath).Path
  }

  throw "Flutter binary was not found. Pass -FlutterBin or install Flutter."
}

function Get-JavaMajorVersion {
  param([string]$JavaExe)

  if (-not (Test-Path $JavaExe)) {
    return $null
  }

  $versionOutput = cmd /c "`"$JavaExe`" -version 2>&1" | Out-String
  $match = [regex]::Match($versionOutput, 'version "(\d+)(?:\.(\d+))?')
  if (-not $match.Success) {
    return $null
  }

  $major = [int]$match.Groups[1].Value
  if ($major -eq 1 -and $match.Groups[2].Success) {
    return [int]$match.Groups[2].Value
  }

  return $major
}

function Find-SystemJavaHome {
  $candidates = @()

  if ($env:JAVA_HOME) {
    $candidates += $env:JAVA_HOME
  }

  $javaCommand = Get-Command java -ErrorAction SilentlyContinue
  if ($javaCommand) {
    $candidates += (Split-Path (Split-Path $javaCommand.Source -Parent) -Parent)
  }

  $candidates += @(
    'C:\Program Files\Microsoft',
    'C:\Program Files\Eclipse Adoptium',
    'C:\Program Files\Java'
  )

  foreach ($candidate in $candidates | Select-Object -Unique) {
    if (-not (Test-Path $candidate)) {
      continue
    }

    if (Test-Path (Join-Path $candidate 'bin\java.exe')) {
      $major = Get-JavaMajorVersion -JavaExe (Join-Path $candidate 'bin\java.exe')
      if ($major -ge 17) {
        return $candidate
      }
      continue
    }

    foreach ($directory in (Get-ChildItem $candidate -Directory -ErrorAction SilentlyContinue)) {
      $javaExe = Join-Path $directory.FullName 'bin\java.exe'
      $major = Get-JavaMajorVersion -JavaExe $javaExe
      if ($major -ge 17) {
        return $directory.FullName
      }
    }
  }

  return $null
}

function Install-LocalJdk17 {
  param([string]$JdkRoot)

  $targetHome = Join-Path $JdkRoot 'microsoft-jdk-17'
  $targetJava = Join-Path $targetHome 'bin\java.exe'
  if (Test-Path $targetJava) {
    return $targetHome
  }

  $zipPath = Join-Path $JdkRoot 'microsoft-jdk-17-windows-x64.zip'
  $extractRoot = Join-Path $JdkRoot 'extract'
  $downloadUrl = 'https://aka.ms/download-jdk/microsoft-jdk-17-windows-x64.zip'

  New-Item -ItemType Directory -Force $JdkRoot | Out-Null

  Write-Host 'Downloading JDK 17...'
  curl.exe -L $downloadUrl -o $zipPath
  Assert-LastExitCode -Action 'JDK 17 download'

  if (-not (Test-Path $zipPath)) {
    throw 'Failed to download JDK 17.'
  }

  if (Test-Path $extractRoot) {
    Remove-Item $extractRoot -Recurse -Force
  }
  Expand-Archive -Path $zipPath -DestinationPath $extractRoot -Force

  $extractedHome = Get-ChildItem $extractRoot -Directory | Select-Object -First 1
  if (-not $extractedHome) {
    throw 'Failed to extract JDK 17.'
  }

  if (Test-Path $targetHome) {
    Remove-Item $targetHome -Recurse -Force
  }
  Move-Item $extractedHome.FullName $targetHome
  Remove-Item $extractRoot -Recurse -Force

  return $targetHome
}

function Set-JavaHome {
  param([string]$RepoRoot)

  $javaHome = Find-SystemJavaHome
  if (-not $javaHome) {
    $javaHome = Install-LocalJdk17 -JdkRoot (Join-Path $RepoRoot '.jdk')
  }

  $env:JAVA_HOME = $javaHome
  $env:PATH = "$javaHome\bin;$env:PATH"

  $major = Get-JavaMajorVersion -JavaExe (Join-Path $javaHome 'bin\java.exe')
  if ($major -lt 17) {
    throw "Java 17 or higher is required, but '$javaHome' resolved to Java $major."
  }
}

function Wait-For-Boot {
  param([string]$AdbPath)

  & $AdbPath wait-for-device | Out-Null

  for ($attempt = 0; $attempt -lt 120; $attempt++) {
    $bootState = (& $AdbPath shell getprop sys.boot_completed 2>$null).Trim()
    if ($bootState -eq '1') {
      return
    }
    Start-Sleep -Seconds 2
  }

  throw 'Android emulator did not finish booting within the timeout.'
}

function Get-EmulatorDeviceId {
  param([string]$AdbPath)

  $line = & $AdbPath devices | Select-String '^(emulator-\d+)\s+device$' | Select-Object -First 1
  if (-not $line) {
    return $null
  }

  return ($line.Matches[0].Groups[1].Value)
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$FlutterBin = Resolve-FlutterBin -ConfiguredPath $FlutterBin
$AndroidSdkRoot = Join-Path $RepoRoot '.android-sdk'
$AndroidUserHome = Join-Path $RepoRoot '.android'
$AndroidAvdHome = Join-Path $AndroidUserHome 'avd'
$JdkRoot = Join-Path $RepoRoot '.jdk'
$PubCache = Join-Path $RepoRoot '.pub-cache'
$GradleUserHome = Join-Path $RepoRoot '.gradle'
$CmdlineToolsRoot = Join-Path $AndroidSdkRoot 'cmdline-tools'
$CmdlineToolsLatest = Join-Path $CmdlineToolsRoot 'latest'
$SdkManager = Join-Path $CmdlineToolsLatest 'bin\sdkmanager.bat'
$AvdManager = Join-Path $CmdlineToolsLatest 'bin\avdmanager.bat'
$EmulatorExe = Join-Path $AndroidSdkRoot 'emulator\emulator.exe'
$AdbExe = Join-Path $AndroidSdkRoot 'platform-tools\adb.exe'
$CmdlineToolsZip = Join-Path $AndroidSdkRoot 'commandlinetools-win.zip'
$CmdlineToolsUrl = 'https://dl.google.com/android/repository/commandlinetools-win-14742923_latest.zip'
$FlutterRoot = Split-Path (Split-Path $FlutterBin -Parent) -Parent
$DartExe = Join-Path $FlutterRoot 'bin\cache\dart-sdk\bin\dart.exe'
$StartEmulatorScript = Join-Path $PSScriptRoot 'start-emulator.ps1'
$RepairAvdScript = Join-Path $PSScriptRoot 'repair-emulator-avd.ps1'

Require-Command curl.exe
Set-JavaHome -RepoRoot $RepoRoot

if (-not (Test-Path $DartExe)) {
  throw "Bundled Dart SDK not found at '$DartExe'."
}

New-Item -ItemType Directory -Force $AndroidSdkRoot, $AndroidUserHome, $AndroidAvdHome, $JdkRoot, $PubCache, $GradleUserHome | Out-Null

$env:ANDROID_HOME = $AndroidSdkRoot
$env:ANDROID_SDK_ROOT = $AndroidSdkRoot
$env:ANDROID_USER_HOME = $AndroidUserHome
$env:ANDROID_EMULATOR_HOME = $AndroidUserHome
$env:ANDROID_AVD_HOME = $AndroidAvdHome
$env:ANDROID_SDK_HOME = $RepoRoot
$env:HOME = $RepoRoot
$env:USERPROFILE = $RepoRoot
$homeDrive = [System.IO.Path]::GetPathRoot($RepoRoot).TrimEnd('\')
$env:HOMEDRIVE = $homeDrive
$env:HOMEPATH = $RepoRoot.Substring($homeDrive.Length)
$env:PUB_CACHE = $PubCache
$env:GRADLE_USER_HOME = $GradleUserHome
$env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
$env:FLUTTER_ROOT = $FlutterRoot

if (-not (Test-Path $CmdlineToolsLatest)) {
  Write-Host 'Downloading Android command-line tools...'
  curl.exe -L $CmdlineToolsUrl -o $CmdlineToolsZip
  Assert-LastExitCode -Action 'Android command-line tools download'

  if (-not (Test-Path $CmdlineToolsZip)) {
    throw 'Failed to download Android command-line tools.'
  }

  $ExtractRoot = Join-Path $CmdlineToolsRoot 'extract'
  if (Test-Path $ExtractRoot) {
    Remove-Item $ExtractRoot -Recurse -Force
  }
  Expand-Archive -Path $CmdlineToolsZip -DestinationPath $ExtractRoot -Force

  if (Test-Path $CmdlineToolsLatest) {
    Remove-Item $CmdlineToolsLatest -Recurse -Force
  }

  Move-Item (Join-Path $ExtractRoot 'cmdline-tools') $CmdlineToolsLatest
  Remove-Item $ExtractRoot -Recurse -Force
}

if (-not (Test-Path $SdkManager)) {
  throw "sdkmanager not found at '$SdkManager'."
}

Write-Host 'Installing Android SDK packages...'
Accept-AndroidLicenses -SdkManager $SdkManager -AndroidSdkRoot $AndroidSdkRoot
& $SdkManager --sdk_root=$AndroidSdkRoot 'platform-tools' 'emulator' $PlatformPackage $BuildToolsPackage $SystemImage
Assert-LastExitCode -Action 'Android SDK package installation'

if (-not (Test-Path $AdbExe)) {
  throw "adb not found at '$AdbExe'."
}

if (-not (Test-Path $EmulatorExe)) {
  throw "emulator not found at '$EmulatorExe'."
}

$AvdIni = Join-Path $AndroidAvdHome "$AvdName.ini"
if (-not (Test-Path $AvdIni)) {
  Write-Host "Creating AVD '$AvdName'..."
  cmd /c "echo no|`"$AvdManager`" create avd -n $AvdName -k `"$SystemImage`" --device medium_phone"
  Assert-LastExitCode -Action 'AVD creation'
}

if (Test-Path $RepairAvdScript) {
  & $RepairAvdScript -AvdName $AvdName -GpuMode $GpuMode
}

$DeviceId = Get-EmulatorDeviceId -AdbPath $AdbExe
if (-not $DeviceId) {
  Write-Host 'Starting Android emulator...'
  & $StartEmulatorScript -AvdName $AvdName -GpuMode $GpuMode -WipeData:$WipeData
  $DeviceId = Get-EmulatorDeviceId -AdbPath $AdbExe
}

if (-not $DeviceId) {
  throw 'No Android emulator device was found after startup.'
}

if (-not (Test-Path (Join-Path $RepoRoot 'android'))) {
  Write-Host 'Generating missing Flutter Android project files...'
  & $FlutterBin create --platforms=android --no-pub $RepoRoot
}

Push-Location $RepoRoot
try {
  & $DartExe pub get
  Assert-LastExitCode -Action 'dart pub get'
  & $FlutterBin run -d $DeviceId
  Assert-LastExitCode -Action 'flutter run'
} finally {
  Pop-Location
}
