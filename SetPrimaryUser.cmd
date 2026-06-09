@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
setlocal enabledelayedexpansion

echo Retrieving Intune Device ID...

for /f "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Enrollments" /s /v DeviceID 2^>nul ^| findstr DeviceID') do (
    set "DEVICE_ID=%%B"
)

if defined DEVICE_ID (
    set "FULL_URL=https://intune.microsoft.com/#view/Microsoft_Intune_Devices/DeviceSettingsMenuBlade/~/properties/mdmDeviceId/!DEVICE_ID!"
    
    echo Device ID: !DEVICE_ID!
    echo.
    echo Opening Intune portal...
    
    start "" "!FULL_URL!"
) else (
    echo ERROR: Device ID not found
    pause
    exit /b 1
)
