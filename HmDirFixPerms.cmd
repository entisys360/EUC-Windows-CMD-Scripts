REM Permissions Script - DMM Entisys360 3/15/17
REM Run against home directory share to set permissions
REM First set correct permissions on the root of the share per article: https://blogs.technet.microsoft.com/migreene/2008/03/24/ntfs-permissions-for-redirected-folders-or-home-directories/

REM !!Do not run when users are on the system!!

REM Set home directory share location (can also be local drive if executed on HMDir Server)
SET HMSHAREROOT=\\SERVER\SHARE


REM Do for each folder at the root of the home share

for /f "tokens=* delims= " %%G in ('dir /b %HMSHAREROOT%\*.') do call :proc1 "%%G"

goto end

:proc1
REM Get username
Set THEUSER=%~1

REM Reset all permissions to inherited on root
ICACLS "%HMSHAREROOT%\%THEUSER%" /reset /C /L /Q

REM Reset all permissions to inherited on subfolders and files
ICACLS "%HMSHAREROOT%\%THEUSER%" /reset /T /C /L /Q


REM Set the owner on the root to the user
ICACLS "%HMSHAREROOT%\%THEUSER%" /setowner %USERDOMAIN%\%THEUSER% /C /L /Q

REM Set the owner on the subfolders and files to the user
ICACLS "%HMSHAREROOT%\%THEUSER%" /setowner %USERDOMAIN%\%THEUSER% /T /C /L /Q

REM Set Explicit Permissions for user on the root
ICACLS "%HMSHAREROOT%\%THEUSER%" /grant:R %USERDOMAIN%\%THEUSER%:F /C /L /Q

REM Set Explicit Permissions for user on the subfolders and files
ICACLS "%HMSHAREROOT%\%THEUSER%" /grant:R %USERDOMAIN%\%THEUSER%:F /T /C /L /Q

REM !!! Insert "pause" statement here for first run to ensure everything functions as desired before processing all users
REM pause

:end
