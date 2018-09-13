@ECHO OFF
REM ------------------------------------------------------------
REM Function echoing the supplied file maximum offset in bytes
REM for support automating WinHex scripting
REM 
REM Author:  brya-n  (https://github.com/brya-n)
REM Date:    13/09/2018
REM Version: 1.0.0
REM 
REM Function uses Microsoft command line interface only.
REM
REM Input must be a single argument of file or ? 
REM Otherwise generates exception string with reason
REM
REM Defensive programming: 
REM   Output is either a fixed delimited string or display help
REM   Delimited String:  four tokens delimited by #
REM   Token 1:  
REM     0# Exception  
REM     1# Calculated value
REM   Exception String Codes:  
REM     0#0#"No supplied argument."#NUL
REM     0#1#"More than one argument and enlose file paths with quotes."#NUL
REM     0#2#"Directory only found."#NUL
REM     0#3#"Invalid file argument."#NUL
REM   
REM   Calculated Value String Codes  **OFFSET** represents value
REM     1#**OFFSET**#"EOF Offset in Bytes (Decimal)"#NUL
REM
REM   Where **OFFSET** = (FILE_SIZE -1)
REM
REM   Token 3 for human readable text, enclosed in ""
REM   Token 4 defined as NUL 
REM     This means easier to pass back and not worry about any
REM     potential extra spaces at the end of the ECHO 
REM     within your code
REM
REM   Checked as working on Windows 7 Pro SP1
REM
REM ------------------------------------------------------------

REM Check for exceptions or help
REM
:CHECK_FOR_FILE
SETLOCAL ENABLEDELAYEDEXPANSION
IF [%1]==[] (GOTO EXCEPTION_NO_ARGUMENT)
IF NOT [%2]==[] (GOTO EXCEPTION_TOO_MANY_ARGUMENTS)
IF %1 EQU ? (GOTO :HELP)
SET "_fileSizeInBytes=%~z1"
IF !_fileSizeInBytes! EQU 0 (GOTO EXCEPTION_NO_VALID_FILE)

REM Solution adapted from:
REM https://stackoverflow.com/questions/8666225/how-to-test-if-a-path-is-a-file-or-directory-in-windows-batch-file
REM Author: community
REM Date:   23/05/2017
REM To check the argument supplied is not a directory
REM 
SET _isDirectory=0
for /f "tokens=1,2 delims=d" %%A in ("-%~a1") do if "%%B" neq "" (
  SET _isDirectory=1
)
IF %_isDirectory% EQU 1 (GOTO EXCEPTION_DIRECTORY_ONLY)

REM If not filtered out then it must be a file
REM Lets find the end offset
REM
:FILE_NOT_DIRECTORY
SET /A _fileSizeInBytes-=1
@ECHO 1#%_fileSizeInBytes%#"EOF Offset in Bytes (Decimal)"#NUL
EXIT /B

ENDLOCAL

REM Defensive programming to supply help to calling program
REM Return exception if the function detects no argument supplied
:EXCEPTION_NO_ARGUMENT
CLS
@ECHO 0#0#"No supplied argument."#NUL
EXIT /B

REM Return exception if the function detects more than one argument
:EXCEPTION_TOO_MANY_ARGUMENTS
CLS
@ECHO 0#1#"More than one argument and enlose file paths with quotes."#NUL
EXIT /B

REM Return exception if the function detects a valid directory only
:EXCEPTION_DIRECTORY_ONLY
CLS
@ECHO 0#2#"Directory only found."#NUL
EXIT /B

REM Return exception if the function determines the file does
REM not exist, or is zero bytes
:EXCEPTION_NO_VALID_FILE
CLS
@ECHO 0#3#"Invalid file argument."#NUL
EXIT /B

:HELP
REM Standardised help page for information on how to use
REM this module.
CLS
COLOR F0
@ECHO INPUT:  
@ECHO     Single string representing file ^& Path
@ECHO     Or a ? to echo this help
@ECHO.
@ECHO OUTPUT: 
@ECHO     String delimited by a hash
@ECHO.
@ECHO     First Token (passed for coding):
@ECHO        0  =  Exception raised
@ECHO        1  =  Value obtained
@ECHO.
@ECHO     Second Token (passed for coding):
@ECHO        Error code or
@ECHO        One less than the file size in units of bytes
@ECHO.
@ECHO     Third Token (passed for validation):
@ECHO        Human readable text enclosed in ""
@ECHO.
@ECHO     Fourth Token:
@ECHO        NUL
@ECHO.
@ECHO EXAMPLE:
@ECHO     brya-n_file_offset.BAT c:\
@ECHO.
@ECHO RETURNS: 
@ECHO     0#2#"Directory only found"#NUL 
@ECHO.
@ECHO Checked as working on Windows 7 Pro SP1
@ECHO Batch file downloaded from:
@ECHO     https://github.com/brya-n
@ECHO.     
@ECHO.
EXIT /B
