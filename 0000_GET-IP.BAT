@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
COLOR 0F
REM ============================================================
REM Author:  brya-n
REM Coded:   24/08/2018   
REM Version  1.0.0  (Standardising return codes)
REM
REM Previous:0.0.2  (Works as standalone batch file)
REM Tested:  Windows 7, 10
REM To do:   Refactor :IF_FOUND into :CONTINUE
REM
REM Purpose: For modular construction of batch files
REM          and/or standalone testing. Requires:
REM Input 1: Character (4 or 6) or ? for help
REM Input 2: String (logical_network_name)
REM Output:  CODE#VALUE#NUL
REM          Output can be delimited using #
REM          
REM ============================================================
REM
:CHECK INPUT
IF [%1] == [] GOTO ERROR_NO_ARG
IF %1 == ^? GOTO SHOW_HELP
IF [%2] == [] GOTO ERROR_NO_DEFINED_NETWORK
IF %1 EQU 4 GOTO CONTINUE
IF %1 EQU 6 GOTO CONTINUE
GOTO ERROR_IP_PROTOCOL

REM -----------------------------------------------------------
REM Will the IP protocol return a responce?
REM -----------------------------------------------------------
:CONTINUE
PING -n 1 -l 32 %2 -%1 >NUL
IF %ERRORLEVEL%==0 (
	GOTO IP_FOUND
) ELSE (
	GOTO FEEDBACK_NETWORK_NOT_RECOGNISED
)

REM -----------------------------------------------------------
REM Return the IP address
REM 0#IP Address#NUL
REM -----------------------------------------------------------
:IP_FOUND
FOR /F "tokens=1,2,3,4 delims=: " %%B IN ('PING -n 1 -l 65000 %2 -%1 ^| FINDSTR /C:"Ping statistics"') DO (
   @ECHO 1#%%E#"IPv%1 ADDRESS"#NUL
)

:EOF
EXIT /B


REM -----------------------------------------------------------
REM Code to echo help file
REM -----------------------------------------------------------
:SHOW_HELP
CLS
COLOR 0B
@ECHO ============================================================
@ECHO 0000_GET-IP.BAT
@ECHO Author:  bray-n
@ECHO Version: 1.0.0
@ECHO ============================================================
@ECHO Returns the IP address for a network which is accessible
@ECHO as a delimited string, or an error code 
@ECHO.
@ECHO Use of script:
@ECHO.
@ECHO    0000_GET-IP.BAT CHARACTER STRING
@ECHO.
@ECHO    CHARACTER:   ?  For this help display
@ECHO                 4  For IPv4
@ECHO                 6  For IPv6
@ECHO.
@ECHO    STRING:      "Enclosed in quotes the logical network name"
@ECHO.
@ECHO    OUTPUT:      ECHO back as:
@ECHO                 CODE#VALUE#NUL
@ECHO.
@ECHO    Delimiter:   #  (allows string processing)
@ECHO    Where
@ECHO         CODE=   0  Exception raised
@ECHO         CODE=   1  VALUE= Result of network found
@ECHO.
@ECHO    Exception examples
@ECHO         0#0#"No supplied argument."#NUL
@ECHO.   
@ECHO         NUL=    To avoid extra spaces being returned
@ECHO.
@ECHO   Press any key to quit.
@ECHO.
@ECHO ============================================================
PAUSE>NUL       
GOTO EOF


REM -----------------------------------------------------------
REM Code to echo feedback for network not found
REM 1#Information#NUL
REM -----------------------------------------------------------
:FEEDBACK_NETWORK_NOT_RECOGNISED
CLS
COLOR 1B
@ECHO 0#2#"IPv%1 PING COULD NOT FIND %2"#NUL
GOTO EOF


REM -----------------------------------------------------------
REM Code to echo errors from input
REM 2#Error#NUL
REM -----------------------------------------------------------
:ERROR_NO_ARG
CLS
COLOR 0F
@ECHO 0#0#"NO ARGUMENTS GIVEN"#NUL
GOTO EOF

:ERROR_NO_DEFINED_NETWORK
CLS
COLOR 0F
@ECHO 0#3#"NO NETWORK SUPPLIED"#NUL
GOTO EOF

:ERROR_IP_PROTOCOL
CLS
COLOR 0F
@ECHO 0#4#"IPv%1 NOT RECOGNISED"#NUL
GOTO EOF
