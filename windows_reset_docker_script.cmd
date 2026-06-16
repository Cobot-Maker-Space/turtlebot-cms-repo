@echo off
REM Wrapper to launch the PowerShell reset script from cmd.exe
SET SCRIPT_DIR=%~dp0
SET PS_SCRIPT=%SCRIPT_DIR%windows_reset_docker_script.ps1
IF NOT EXIST "%PS_SCRIPT%" (
  echo Cannot find %PS_SCRIPT%
  exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %*
