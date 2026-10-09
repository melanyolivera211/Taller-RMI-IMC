@echo off
setlocal enabledelayedexpansion
title Servidor IMC (LipeRMI)
echo ====================================================
echo  INICIANDO SERVIDOR RMI IMC EN PUERTO 9007...
echo ====================================================

set "JAVA_CMD=java"
where java >nul 2>nul
if %errorlevel% neq 0 (
    if defined JAVA_HOME if exist "%JAVA_HOME%\bin\java.exe" (
        set "JAVA_CMD=%JAVA_HOME%\bin\java.exe"
    ) else if exist "C:\Program Files\Java\jdk-21\bin\java.exe" (
        set "JAVA_CMD=C:\Program Files\Java\jdk-21\bin\java.exe"
    ) else (
        for /d %%D in ("C:\Program Files\Java\jdk*") do (
            if exist "%%D\bin\java.exe" set "JAVA_CMD=%%D\bin\java.exe"
        )
    )
)

cd /d "%~dp0ImcRmiServidor"
"%JAVA_CMD%" -cp "dist\ImcRmiServidor.jar;lib\lipermi-1.0.1.jar;lib\ImcRmiLib.jar" com.ejemplo.imc.servidor.Principal
pause
