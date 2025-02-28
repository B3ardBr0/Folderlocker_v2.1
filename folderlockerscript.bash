@ECHO OFF
SETLOCAL EnableDelayedExpansion
TITLE Secure Folder Locker
COLOR 0A

:: Define variables
SET "CURRENT_DIR=%CD%"
SET "LOCKERNAME=%CURRENT_DIR%\Locker"
SET "HIDDENNAME=%CURRENT_DIR%\Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
SET "PASSWORDFILE=%CURRENT_DIR%\.config.dat"
SET "DEFAULTMSG=Secure Folder System"

:: Check if running with admin privileges
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Administrative privileges required.
    ECHO Please run this script as administrator.
    PAUSE
    EXIT /B 1
)

:: Create a cleaner interface
:MAIN
CLS
ECHO ========================================
ECHO         SECURE FOLDER LOCKER v2.0
ECHO ========================================
ECHO.

:: Check if password file exists or needs to be created
IF NOT EXIST "%PASSWORDFILE%" GOTO SETPASSWORD

:: Check status of locker
IF EXIST "%HIDDENNAME%" (
    ECHO Status: LOCKED
    ECHO.
    ECHO [1] Unlock Folder
) ELSE IF EXIST "%LOCKERNAME%" (
    ECHO Status: UNLOCKED
    ECHO.
    ECHO [1] Lock Folder
) ELSE (
    ECHO Status: NOT SETUP
    ECHO.
    ECHO [1] Create Secure Folder
)

ECHO [2] Change Password
ECHO [3] Exit
ECHO.

SET "choice="
SET /P "choice=Enter your choice (1-3): "

IF "%choice%"=="1" (
    IF EXIST "%HIDDENNAME%" GOTO UNLOCKPROMPT
    IF EXIST "%LOCKERNAME%" GOTO LOCKPROMPT
    GOTO CREATELOCKER
)
IF "%choice%"=="2" GOTO SETPASSWORD
IF "%choice%"=="3" EXIT /B 0

ECHO Invalid choice. Please try again.
TIMEOUT /T 2 >NUL
GOTO MAIN

:CREATELOCKER
CLS
ECHO Creating secure folder...
MD "%LOCKERNAME%"
ATTRIB +R "%LOCKERNAME%"
ECHO.
ECHO Secure folder created successfully.
ECHO You can now place files inside the "%LOCKERNAME%" folder.
ECHO When ready, return to the main menu to lock it.
ECHO.
PAUSE
GOTO MAIN

:LOCKPROMPT
CLS
ECHO ========================================
ECHO                 LOCK FOLDER
ECHO ========================================
ECHO.
ECHO This will hide and lock your "%LOCKERNAME%" folder.
ECHO.
ECHO [Y] Yes, lock it now
ECHO [N] No, return to menu
ECHO.

SET "confirm="
SET /P "confirm=Are you sure you want to lock the folder? (Y/N): "

IF /I "%confirm%"=="Y" GOTO LOCK
IF /I "%confirm%"=="N" GOTO MAIN

ECHO Invalid choice. Please try again.
TIMEOUT /T 2 >NUL
GOTO LOCKPROMPT

:LOCK
CLS
ECHO Checking password...

:: Verify password before locking
CALL :CHECKPASSWORD
IF !PASSWORDOK! NEQ 1 (
    ECHO Invalid password. Cannot lock folder.
    PAUSE
    GOTO MAIN
)

:: Lock the folder
ATTRIB +H +S "%LOCKERNAME%"
REN "%LOCKERNAME%" "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}"

ECHO.
ECHO Folder locked successfully.
TIMEOUT /T 2 >NUL
GOTO MAIN

:UNLOCKPROMPT
CLS
ECHO ========================================
ECHO                UNLOCK FOLDER
ECHO ========================================
ECHO.

CALL :CHECKPASSWORD
IF !PASSWORDOK! NEQ 1 (
    ECHO Invalid password. Access denied.
    PAUSE
    GOTO MAIN
)

:: Unlock the folder
ATTRIB -H -S "%HIDDENNAME%"
REN "%HIDDENNAME%" "Locker"

ECHO.
ECHO Folder unlocked successfully!
TIMEOUT /T 2 >NUL
GOTO MAIN

:SETPASSWORD
CLS
ECHO ========================================
ECHO              PASSWORD SETUP
ECHO ========================================
ECHO.

:: If already has a password, verify it first
IF EXIST "%PASSWORDFILE%" (
    ECHO Please enter your current password to continue:
    CALL :CHECKPASSWORD
    IF !PASSWORDOK! NEQ 1 (
        ECHO Invalid password. Cannot change password.
        PAUSE
        GOTO MAIN
    )
)

ECHO Please set a new password for your secure folder.
ECHO Password should be at least 6 characters long.
ECHO.

SET "pass1="
SET "pass2="
SET /P "pass1=Enter new password: "

:: Simple password validation
IF "%pass1%"=="" (
    ECHO Password cannot be empty.
    PAUSE
    GOTO SETPASSWORD
)
IF "%pass1:~5%"=="" (
    ECHO Password is too short. Please use at least 6 characters.
    PAUSE
    GOTO SETPASSWORD
)

ECHO.
SET /P "pass2=Confirm password: "

IF NOT "%pass1%"=="%pass2%" (
    ECHO.
    ECHO Passwords do not match. Please try again.
    PAUSE
    GOTO SETPASSWORD
)

:: Store password with basic obfuscation (not actual encryption)
SET "obfpass="
FOR /L %%i IN (0,1,!pass1:~0,1024!) DO (
    SET "char=!pass1:~%%i,1!"
    IF NOT "!char!"=="" (
        SET /A "ascii=!char:~0,1!"
        SET "obfpass=!obfpass!!ascii!"
    )
)

ECHO !obfpass!>"%PASSWORDFILE%"
ATTRIB +H +S "%PASSWORDFILE%"

ECHO.
ECHO Password set successfully.
TIMEOUT /T 2 >NUL
GOTO MAIN

:CHECKPASSWORD
:: Retrieve stored password and validate user input
SET "PASSWORDOK=0"
SET "inputpass="
SET /P "inputpass=Enter password: "

IF "%inputpass%"=="" GOTO :EOF

:: Convert input to same format for comparison
SET "obfinput="
FOR /L %%i IN (0,1,!inputpass:~0,1024!) DO (
    SET "char=!inputpass:~%%i,1!"
    IF NOT "!char!"=="" (
        SET /A "ascii=!char:~0,1!"
        SET "obfinput=!obfinput!!ascii!"
    )
)

:: Read stored password
FOR /F "usebackq delims=" %%a IN ("%PASSWORDFILE%") DO (
    SET "storedpass=%%a"
)

IF "!obfinput!"=="!storedpass!" (
    SET "PASSWORDOK=1"
)
GOTO :EOF

ENDLOCAL