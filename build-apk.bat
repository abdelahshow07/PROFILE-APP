@echo off
title ProfitPulse - Native Android APK Builder
echo ========================================================
echo   ProfitPulse — Capacitor Android APK Builder
echo ========================================================
echo.

cd /d "%~dp0"

where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js / npm is not installed on this PC.
    echo Please install Node.js LTS from https://nodejs.org/ or use the included GitHub Actions workflow.
    pause
    exit /b 1
)

echo [1/4] Installing Capacitor dependencies...
call npm install

echo [2/4] Adding / Syncing Capacitor Android platform...
if not exist "android" (
    call npx cap add android
) else (
    call npx cap sync android
)

where java >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Java JDK 21 is not installed locally.
    echo The Capacitor Android project has been generated in .\android\
    echo Push this folder to GitHub to build ProfitPulse.apk automatically via GitHub Actions, or install Android Studio / JDK 21.
    pause
    exit /b 1
)

echo [3/4] Building Debug APK via Gradle...
cd android
call gradlew.bat assembleDebug
cd ..

if exist "android\app\build\outputs\apk\debug\app-debug.apk" (
    copy /Y "android\app\build\outputs\apk\debug\app-debug.apk" "ProfitPulse.apk" >nul
    echo.
    echo [4/4] SUCCESS! Your installable APK is ready at:
    echo       %~dp0ProfitPulse.apk
) else (
    echo [ERROR] Gradle build did not produce app-debug.apk. Check Android SDK / ANDROID_HOME.
)
pause
