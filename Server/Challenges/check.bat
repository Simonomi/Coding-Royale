@echo off

REM 1st: location of file
REM 2ns: file name (no extension)
REM 3rd: name of answer (same as check)

set starting=%cd%

cd "%~1"
javac %~2.java > nul 2> nul

if errorlevel 1 goto error
java %~2 | more > output.txt
del Front11.class
fc output.txt "%starting%\%~3" > nul

if errorlevel 1 goto error

echo no errors
del output.txt
goto end

:error
echo errors
echo.

:end
cd %starting%