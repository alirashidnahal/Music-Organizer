@echo off
SETLOCAL enabledelayedexpansion

@REM This script organizes .mp3 files from a source directory into subdirectories in a target directory based on the singer's name.
@REM The singer's name is assumed to be the part of the file name before the first '-' character.
@REM Usage: script_name.bat source_directory target_directory


@REM This variable is used throughout the script to prefix log messages with a timestamp.
set "dateLog=[101;93m %date%%time% [0m"

@REM Check if both a source and a target directory were provided as arguments. If not, display usage and exit.
if "%~1"=="" (    
    echo %dateLog% Usage: %0 source_directory target_directory
    exit /b 1
)

if "%~2"=="" (
    echo %dateLog% Usage: %0 source_directory target_directory
    exit /b 1
)

@REM Assign directories to variables based on command-line arguments.
set "sourceDir=%~1"
set "targetDir=%~2"

@REM Change to the source directory. Exit the script if the directory change fails.
cd /d "%sourceDir%" || exit /b

@REM Loop through all .mp3 files in the source directory.
for %%F in (*.mp3) do (
    @REM Extract the singer's name by cutting the filename up to the first '-'.
    for /f "tokens=1 delims=-" %%A in ("%%~nF") do (
        set "singer_name=%%A"
        @REM Trim the last space from the singer's name if it exists.
        if "!singer_name:~-1!"==" " set "singer_name=!singer_name:~0,-1!"
        
        @REM Check if a directory for the singer exists in the target directory. If it does, move the file there.
        if exist "%targetDir%\!singer_name!" (
            move "%%F" "%targetDir%\!singer_name!\%%F"
            echo %dateLog% Moved "%%F" to "%targetDir%\!singer_name!\"
        ) else (
            @REM If the singer's directory does not exist, skip moving this file.
            echo %dateLog% Directory for "!singer_name!" does not exist in "%targetDir%", skipping "%%F"
        )
    )
)

@REM Indicate that all applicable music files have been organized.
echo %dateLog% All applicable music files have been organized.
ENDLOCAL