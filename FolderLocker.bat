@ECHO OFF
title Folder Locker

:START
cls
echo 1. Lock Folder
echo 2. Unlock Folder
echo 3. Lock Existing Folder
echo 4. Exit
set /p choice="Enter your choice (1/2/3/4): "

if "%choice%"=="" goto START
if "%choice%"=="1" goto LOCK
if "%choice%"=="2" goto UNLOCK
if "%choice%"=="3" goto LOCK_EXISTING
if "%choice%"=="4" goto EXIT

:LOCK
cls
set /p "foldername=Enter folder name to create: "
set /p "password=Enter password for the folder: "
set /p "recipient_email=Enter recipient's email address: "
set /p "destination=Enter the path to save the folder (leave blank for the current directory): "

:: If the destination is empty, set it to the current directory
if "%destination%"=="" set "destination=."

:: Create the folder in the specified destination
md "%destination%\%foldername%"
echo %password%>"%destination%\%foldername%\password.txt"
attrib +h +s "%destination%\%foldername%"
echo Folder locked successfully.

:: Send an email with folder name and password
python.exe send_email.py "%recipient_email%" "%destination%\%foldername%" "%password%"
goto START

:UNLOCK
cls
set /p "foldername=Enter folder name to unlock: "
set /p "location=Enter the location of the folder (leave blank for the current directory): "

:: If the location is empty, set it to the current directory
if "%location%"=="" set "location=."

if EXIST "%location%\%foldername%" (
    set /p "pass=Enter the password: "
    type "%location%\%foldername%\password.txt" | find /i "%pass%" >nul
    if errorlevel 1 (
        echo Invalid password.
        pause
    ) else (
        attrib -h -s "%location%\%foldername%"
        echo Folder Unlocked successfully.
        pause
    )
) else (
    echo Folder does not exist in the specified location.
    pause
)
goto START

:LOCK_EXISTING
cls
set /p "foldername=Enter the name of the folder to lock: "
set /p "location=Enter the location of the folder (leave blank for the current directory): "

:: If the location is empty, set it to the current directory
if "%location%"=="" set "location=."

if EXIST "%location%\%foldername%" (
    attrib +h +s "%location%\%foldername%"
    echo Folder locked successfully.
    pause
) else {
    echo Folder does not exist in the specified location.
    pause
}
goto START

:EXIT
exit /b
