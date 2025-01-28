@echo off

setlocal EnableDelayedExpansion

rem Update the submodule to the latest commit CMakeLists.txt
copy "%RECIPE_DIR%\patches\Cores-CMakeLists.txt" "%SRC_DIR%\src\Infrastructure\src\Emulator\Cores\CMakeLists.txt"
copy "%RECIPE_DIR%\patches\tlib-CMakeLists.txt" "%SRC_DIR%\src\Infrastructure\src\Emulator\Cores\tlib\CMakeLists.txt"
if %errorlevel% neq 0 exit /b  %errorlevel%


powershell -ExecutionPolicy Bypass -File "${env:RECIPE_DIR}/helpers/renode_build_with_cmake.ps1" --tlib-only --net --no-gui
if %errorlevel% neq 0 exit /b  %errorlevel%

rem Install procedure into a conda path that renode-cli can retrieve
set "ROOT_PATH=%~dp0.."
set "CONFIGURATION=Release"
set "CORES_PATH=%ROOT_PATH%src\Infrastructure\src\Emulator\Cores"
set "CORES_BIN_PATH=%CORES_PATH%\bin\%CONFIGURATION%"

mkdir "%PREFIX%\Library\lib\%PKG_NAME%"
tar -c -C "%CORES_BIN_PATH%\lib" . | tar -x -C "%PREFIX%\Library\lib\%PKG_NAME%"
if %errorlevel% neq 0 exit /b  %errorlevel%

endlocal
