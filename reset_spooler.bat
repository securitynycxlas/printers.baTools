@echo off
CLS

:::   ___              __    ___      _      __            ____               __          ___    ___                    ___
:::  / _ \___ ___ ___ / /_  / _ \____(_)__  / /____ ____  / __/__  ___  ___  / /__ ____  / _/__ <  /__ _// ___ ___ ____/  /
::: / , _/ -_|_-</ -_) __/ / ___/ __/ / _ \/ __/ -_) __/ _\ \/ _ \/ _ \/ _ \/ / -_) __/ / // _ \/ /_ /(_-<(_-</ -_) __// / 
:::/_/|_|\__/___/\__/\__/ /_/  /_/ /_/_//_/\__/\__/_/   /___/ .__/\___/\___/_/\__/_/   / //_//_/_//__/ __/___/\__/\__// /  
:::                                                        /_/                        /__/           //             /__/   
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Escalação de privilégio [n1z$sec]
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"

if '%cmdInvoke%'=='1' goto InvokeCmd 

ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation

:InvokeCmd
ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::

net stop "Spooler"
net start "Spooler"

pause
