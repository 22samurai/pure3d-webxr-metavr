@echo off
setlocal

rem Install the Quest APK built by the Android Quest export preset.
rem Pass a different APK path as the first argument if needed.
set "APK=%~dp0build\android-quest\Test-run2.apk"
if not "%~1"=="" set "APK=%~f1"

if not exist "%APK%" (
    echo APK not found: "%APK%"
    echo Export the project with Godot's Android Quest preset first.
    exit /b 1
)

set "ADB="
where adb >nul 2>&1
if not errorlevel 1 set "ADB=adb"
if not defined ADB if defined ANDROID_SDK_ROOT if exist "%ANDROID_SDK_ROOT%\platform-tools\adb.exe" set "ADB=%ANDROID_SDK_ROOT%\platform-tools\adb.exe"
if not defined ADB if defined ANDROID_HOME if exist "%ANDROID_HOME%\platform-tools\adb.exe" set "ADB=%ANDROID_HOME%\platform-tools\adb.exe"
if not defined ADB if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" set "ADB=%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"

if not defined ADB (
    echo adb.exe was not found. Install Android SDK Platform-Tools or add adb to PATH.
    exit /b 1
)

echo Connected Android devices:
"%ADB%" devices
"%ADB%" get-state 2>nul | findstr /R /C:"^device$" >nul
if errorlevel 1 (
    echo No single authorized Quest is available to adb.
    echo Put on the headset and accept the USB debugging prompt, then run this file again.
    exit /b 1
)

echo Installing "%APK%"...
"%ADB%" install -r "%APK%"
if errorlevel 1 (
    echo Installation failed. Check the adb message above.
    exit /b 1
)

echo Installed. Open the app from the Quest's Unknown Sources list.
exit /b 0
