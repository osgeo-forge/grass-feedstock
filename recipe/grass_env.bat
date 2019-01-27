@echo off

REM Get parent of this script, converting UNC path to drive letter if needed
if "%LIBRARY_PREFIX%" == "" for %%a in (%~dp0\..) do set LIBRARY_PREFIX=%%~fa
if "%LIBRARY_PREFIX_SHORT%" == "" for %%i in ("%LIBRARY_PREFIX%") do set LIBRARY_PREFIX_SHORT=%%~fsi

if "%ACTIVATED_GRASS_ENV%" == "1" goto :EOF

REM This is a short-name, with no spaces, path
set GRASS_PARENT_DIR=%LIBRARY_PREFIX_SHORT%\apps\grass

if exist %GRASS_PARENT_DIR% (

  REM Should only be one subdirectory, otherwise may result in highest version
  pushd %GRASS_PARENT_DIR%
    for /d %%G in ("grass-*") do (
      set GISBASE_DIR=%%G
      goto continue
    )
    :continue
  popd

  if not "%GISBASE_DIR%"=="" if exist %GRASS_PARENT_DIR%\%GISBASE_DIR% (
    set GRASS_PREFIX_POSIX=%GRASS_PARENT_DIR:\=/%/%GISBASE_DIR%
    call %GRASS_PARENT_DIR%\%GISBASE_DIR%\etc\env.bat
  )

)

set ACTIVATED_GRASS_ENV=1
