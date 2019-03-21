@echo off

REM 1st: location of file
REM 2ns: file name (no extension)
REM 3rd: name of answer (full directory)

set starting=%cd%
echo %starting%

cd "%~1"
javac %~2.java > nul 2> nul

if errorlevel 1 goto error
java %~2 | more > output.txt
del Front11.class
fc output.txt "%~3" > nul

if errorlevel 1 goto error

del output.txt
cd %starting%
echo yes> result.txt
goto end

:error
del output.txt
cd %starting%
echo no> result.txt
echo.

:end
