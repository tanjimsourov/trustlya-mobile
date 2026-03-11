@echo off
setlocal

powershell -ExecutionPolicy Bypass -File "%~dp0run-android-local.ps1" %*
exit /b %errorlevel%
