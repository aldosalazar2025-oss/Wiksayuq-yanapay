@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo No se encontro Flutter. Agrega flutter\bin al PATH.
  exit /b 1
)
call flutter pub get
if errorlevel 1 exit /b 1
call flutter analyze
if errorlevel 1 exit /b 1
call flutter test
if errorlevel 1 exit /b 1
call flutter build apk --release
if errorlevel 1 exit /b 1
echo APK: build\app\outputs\flutter-apk\app-release.apk
endlocal
