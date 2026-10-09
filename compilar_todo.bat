@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo  COMPILANDO PROYECTOS IMC CON LipeRMI
echo ====================================================

:: Detectar jar.exe
set "JAR_CMD=jar"
where jar >nul 2>nul
if %errorlevel% neq 0 (
    if defined JAVA_HOME if exist "%JAVA_HOME%\bin\jar.exe" (
        set "JAR_CMD=%JAVA_HOME%\bin\jar.exe"
    ) else if exist "C:\Program Files\Java\jdk-21\bin\jar.exe" (
        set "JAR_CMD=C:\Program Files\Java\jdk-21\bin\jar.exe"
    ) else (
        for /d %%D in ("C:\Program Files\Java\jdk*") do (
            if exist "%%D\bin\jar.exe" set "JAR_CMD=%%D\bin\jar.exe"
        )
    )
)

:: Detectar javac.exe
set "JAVAC_CMD=javac"
where javac >nul 2>nul
if %errorlevel% neq 0 (
    if defined JAVA_HOME if exist "%JAVA_HOME%\bin\javac.exe" (
        set "JAVAC_CMD=%JAVA_HOME%\bin\javac.exe"
    ) else if exist "C:\Program Files\Java\jdk-21\bin\javac.exe" (
        set "JAVAC_CMD=C:\Program Files\Java\jdk-21\bin\javac.exe"
    )
)

echo [1/3] Compilando libreria compartida (ImcRmiLib)...
cd /d "%~dp0ImcRmiLib"
if not exist "dist" mkdir dist
if not exist "bin" mkdir bin
"%JAVAC_CMD%" -encoding UTF-8 -d bin src\com\ejemplo\imc\lib\*.java
if %errorlevel% neq 0 (
    echo [ERROR] Error al compilar ImcRmiLib.
    pause
    exit /b %errorlevel%
)
"%JAR_CMD%" -cf dist\ImcRmiLib.jar -C bin .
copy /y dist\ImcRmiLib.jar "..\ImcRmiServidor\lib\" >nul
copy /y dist\ImcRmiLib.jar "..\ImcRmiCliente\lib\" >nul
echo       ImcRmiLib.jar generado correctamente.

echo [2/3] Compilando Servidor (ImcRmiServidor)...
cd /d "%~dp0ImcRmiServidor"
if not exist "dist" mkdir dist
if not exist "bin" mkdir bin
"%JAVAC_CMD%" -encoding UTF-8 -cp "lib\lipermi-1.0.1.jar;lib\ImcRmiLib.jar" -d bin src\com\ejemplo\imc\servidor\*.java
if %errorlevel% neq 0 (
    echo [ERROR] Error al compilar ImcRmiServidor.
    pause
    exit /b %errorlevel%
)
"%JAR_CMD%" -cfe dist\ImcRmiServidor.jar com.ejemplo.imc.servidor.Principal -C bin .
echo       ImcRmiServidor.jar generado correctamente.

echo [3/3] Compilando Cliente (ImcRmiCliente)...
cd /d "%~dp0ImcRmiCliente"
if not exist "dist" mkdir dist
if not exist "bin" mkdir bin
"%JAVAC_CMD%" -encoding UTF-8 -cp "lib\lipermi-1.0.1.jar;lib\ImcRmiLib.jar" -d bin src\com\ejemplo\imc\cliente\*.java src\com\ejemplo\imc\vistas\*.java
if %errorlevel% neq 0 (
    echo [ERROR] Error al compilar ImcRmiCliente.
    pause
    exit /b %errorlevel%
)
"%JAR_CMD%" -cfe dist\ImcRmiCliente.jar com.ejemplo.imc.cliente.Principal -C bin .
echo       ImcRmiCliente.jar generado correctamente.

cd /d "%~dp0"
echo ====================================================
echo  COMPILACION COMPLETADA CON EXITO
echo ====================================================
if "%1"=="/nopause" goto :end
pause
:end
