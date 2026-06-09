@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

setlocal enabledelayedexpansion

echo Retrieving Intune Device ID...

set "DEVICE_ID="
set "BASE_KEY=HKLM\SOFTWARE\Microsoft\Enrollments"

for /f "tokens=*" %%a in ('reg query "%BASE_KEY%" 2^>nul') do (

    for /f "tokens=1,2,*" %%b in ('reg query "%%a\DMClient\MS DM Server" /v "EntDMID" 2^>nul ^| findstr "REG_SZ"') do (
        set "DEVICE_ID=%%d"
        set "FOUND_IN=%%a\DMClient\MS DM Server"
    )
)


if defined DEVICE_ID (
    set "FULL_URL=https://intune.microsoft.com/#view/Microsoft_Intune_Devices/DeviceSettingsMenuBlade/~/properties/mdmDeviceId/!DEVICE_ID!"
    
    echo Location  = !FOUND_IN!
    echo Device ID = !DEVICE_ID!
    echo.
    echo Opening Intune portal...
    
    start "" "!FULL_URL!"
) else (
    echo ERROR: Device ID not found
    pause
    exit /b 1
)
