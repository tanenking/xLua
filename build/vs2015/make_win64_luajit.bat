@echo off
if exist "%VS140COMNTOOLS%" (
	set VCVARS="%VS140COMNTOOLS%..\..\VC\bin\"
	goto build
	)  else (goto missing)


:build

@set ENV64="%VCVARS%amd64\vcvars64.bat"

call "%ENV64%"

echo Swtich to x64 build env
cd %~dp0\luajit-2.1.0b3\src
call msvcbuild_mt.bat static
cd ..\..

goto :buildxlua

:missing
echo Can't find Visual Studio 2015.
pause
goto :eof

:buildxlua
mkdir build_lj64 & pushd build_lj64
cmake -DUSING_LUAJIT=ON -G "Visual Studio 16 2019" -A x64 ..
IF %ERRORLEVEL% NEQ 0 cmake -DUSING_LUAJIT=ON -G "Visual Studio 16 2019" -A x64 ..
popd
cmake --build build_lj64 --config Release
md plugin_luajit\Plugins\x86_64
copy /Y build_lj64\Release\xlua.dll plugin_luajit\Plugins\x86_64\xlua.dll
pause