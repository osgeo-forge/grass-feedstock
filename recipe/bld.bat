:: Build using ming64 via msys2 (libs later converted to VS-compatible)

:: Some workflow culled from conda-forge::gettext Win recipe approach
::   (though that compiles directly with VS)
:: Delegate to the packaging script. We need to translate the key path variables
:: to be Unix-y rather than Windows-y, though.

:: No support for 32-bit anything here!
set MSYSTEM=MINGW64
:: Uncomment when conda-internal msys2 can be used
:: set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1

set "saved_recipe_dir=%RECIPE_DIR%"

set "msys_64=C:\msys64"
if not exist "%msys_64%" (
  echo "'%msys_64%' portable install of MSYS2 not found!"
  echo "See: https://trac.osgeo.org/grass/wiki/CompileOnWindows"
  exit 1
)

set "msys_64_bin=C:\msys64\usr\bin"

pushd "%msys_64_bin%"
  :: NOTE: cygpath.exe -u will prefix with /cygdrive *outside* of msys2
  FOR /F "delims=" %%i IN ('cygpath.exe -u -p "%PATH%"') DO set "PATH_OVERRIDE=%%i"
  :: BUILD_PREFIX=/q/osgf/conda-bld/_build_env
  FOR /F "delims=" %%i IN ('cygpath.exe -u "%BUILD_PREFIX%"') DO set "BUILD_PREFIX=%%i"
  :: LIBRARY_PREFIX_M=Q:/osgf/conda-bld/_h_env/Library
  FOR /F "delims=" %%i IN ('cygpath.exe -m "%LIBRARY_PREFIX%"') DO set "LIBRARY_PREFIX_M=%%i"
  :: LIBRARY_PREFIX_U=/q/osgf/conda-bld/_h_env/Library
  FOR /F "delims=" %%i IN ('cygpath.exe -u "%LIBRARY_PREFIX%"') DO set "LIBRARY_PREFIX_U=%%i"
  :: PREFIX=/q/osgf/conda-bld/_h_env
  FOR /F "delims=" %%i IN ('cygpath.exe -u "%PREFIX%"') DO set "PREFIX=%%i"
  :: Not set now?
  :: FOR /F "delims=" %%i IN ('cygpath.exe -u "%PYTHON%"') DO set "PYTHON=%%i"
  :: RECIPE_DIR=/c/conda/osgeo-forge/feedstocks/grass/recipe
  FOR /F "delims=" %%i IN ('cygpath.exe -u "%RECIPE_DIR%"') DO set "RECIPE_DIR=%%i"
  :: SP_DIR=/q/osgf/conda-bld/_h_env/Lib/site-packages
  FOR /F "delims=" %%i IN ('cygpath.exe -u "%SP_DIR%"') DO set "SP_DIR=%%i"
  :: SRC_DIR=/q/osgf/conda-bld/work
  FOR /F "delims=" %%i IN ('cygpath.exe -u "%SRC_DIR%"') DO set "SRC_DIR=%%i"
  :: STDLIB_DIR=/q/osgf/conda-bld/_h_env/Lib
  FOR /F "delims=" %%i IN ('cygpath.exe -u "%STDLIB_DIR%"') DO set "STDLIB_DIR=%%i"
popd

:: set OSGEO4W-specific env vars
set "OSGEO4W_POSTFIX=64"

:: Ancillary env vars
set "PKG_CONFIG_PATH=%LIBRARY_PREFIX_U%/lib/pkgconfig:%LIBRARY_PREFIX_U%/share/pkgconfig"
set "ACLOCAL_PATH=%LIBRARY_PREFIX_U%/share/aclocal:/usr/share/aclocal"

:: Use -l (--login) here
:: package.sh MUST be called from root directory of GRASS src tree
"%msys_64_bin%\bash.exe" -lxc "mswindows\package.sh"
if %errorlevel% neq 0 exit /b %errorlevel%
exit 0
