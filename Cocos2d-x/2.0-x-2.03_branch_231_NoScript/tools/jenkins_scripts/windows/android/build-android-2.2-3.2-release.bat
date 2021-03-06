::This script is used to accomplish a android automated compile.
::You should make sure have accomplished the environment settings.
:: Don't change it until you know what you do.

::Here are the environment variables you should set.
::%ANT_HOME% %ANDROID_HOME% %JAVA_HOME% %CYGWIN% %ANDROID_NDK%
if not exist "%CYGWIN%" echo Couldn't find Cygwin at "%CYGWIN%" and you should set it like this "C:\cygwin"& pause & exit 1
if not exist "%ANDROID_HOME%" echo Couldn't find ANDROID_HOME at "%ANDROID_HOME%" and you should set it like this "D:\xx\android-sdk-windows"& pause & exit 2
if not exist "%ANDROID_NDK%" echo Couldn't find Cygwin at "%ANDROID_NDK%" and you should set it like this "D:\xx\android-ndk-r8"& pause & exit 3
if not exist "%JAVA_HOME%" echo Couldn't find Cygwin at "%JAVA_HOME%" and you should set it like it this "C:\xx\jdk1.7.0_05"& pause & exit 4
if not exist "%ANT_HOME%" echo Couldn't find Ant at "%ANT_HOME%" and you should set it like this "D:\xx\apache-ant-1.8.4" $ pause $ exit 5

set _PROJECTNAME=TestCpp
cd ..\..\..\..

:project
::Copy build Configuration files to target directory
copy %cd%\tools\jenkins_scripts\ant.properties %cd%\samples\%_PROJECTNAME%\proj.android
copy %cd%\tools\jenkins_scripts\build.xml %cd%\samples\%_PROJECTNAME%\proj.android
copy %cd%\tools\jenkins_scripts\windows\android\rootconfig.sh %cd%\samples\%_PROJECTNAME%\proj.android

::Modify the configuration files
cd samples\%_PROJECTNAME%\proj.android
rootconfig.sh %_PROJECTNAME%
cd ..
set _PROJECTLOCATION=%cd%

::A command line that make the current user get the ownrship of project.
::cacls proj.android\*.* /T /E /C /P %_USERNAME%:F

::Use cygwin compile the source code.
cygpath "%_PROJECTLOCATION%\proj.android\build_native.sh"|call %CYGWIN%\Cygwin.bat

::cacls proj.android\*.* /T /E /C /P %_USERNAME%:F
::echo "%_PROJECTION%/proj.android/build_native.sh"|call %CYGWIN%\Cygwin.bat

::cacls proj.android\*.* /T /E /C /P %_USERNAME%:F
call android update project -p proj.android
cd proj.android

::Make sure the original android build target is android-8
for /f "delims=" %%a in ('findstr /i "target=android-" ant.properties') do set xx=%%a
echo %xx%
for /f "delims=" %%a in (ant.properties) do (
if "%%a"=="%xx%" (echo/target=android-8)else echo/%%a 
)>>"anttmp.properties"
move anttmp.properties ant.properties

for /f "delims=" %%a in (ant.properties) do set num=%%a&call :lis
move ant1.properties ant.properties

::Android ant build(release,API level:8).
call ant release
set result8=%ERRORLEVEL%
if "%_PROJECTNAME%" NEQ "TestCpp" goto API_10
if %result8% NEQ 0 goto API_10
cd bin
ren TestCpp-release.apk TestCpp-release-8.apk
cd ..

:API_10
::Change API level.(API level:10)
for /f "delims=" %%a in (ant.properties) do (
if "%%a"=="target=android-8" (echo/target=android-10)else echo/%%a 
)>>"ant1.properties"
move ant1.properties ant.properties

for /f "delims=" %%a in (ant.properties) do set num=%%a&call :lis
move ant1.properties ant.properties

::Android ant build(release,API level:10).
call ant release
set result10=%ERRORLEVEL%
if "%_PROJECTNAME%" NEQ "TestCpp" goto API_11
if %result10% NEQ 0 goto API_11
cd bin
ren TestCpp-release.apk TestCpp-release-10.apk
cd ..

:API_11
::Change API level.(API level:11)
for /f "delims=" %%a in (ant.properties) do (
if "%%a"=="target=android-10" (echo/target=android-11)else echo/%%a 
)>>"ant1.properties"
move ant1.properties ant.properties

for /f "delims=" %%a in (ant.properties) do set num=%%a&call :lis
move ant1.properties ant.properties

::Android ant build(release,API level:11).
call ant release
set result11=%ERRORLEVEL%
if "%_PROJECTNAME%" NEQ "TestCpp" goto API_12
if %result11% NEQ 0 goto API_12
cd bin
ren TestCpp-release.apk TestCpp-release-11.apk
cd ..

:API_12
::Change API level.(API level:12)
for /f "delims=" %%a in (ant.properties) do (
if "%%a"=="target=android-11" (echo/target=android-12)else echo/%%a 
)>>"ant1.properties"
move ant1.properties ant.properties

for /f "delims=" %%a in (ant.properties) do set num=%%a&call :lis
move ant1.properties ant.properties

::Android ant build(release,API level:12).
call ant release
set result12=%ERRORLEVEL%
if "%_PROJECTNAME%" NEQ "TestCpp" goto API_13
if %result12% NEQ 0 goto API_13
cd bin
ren TestCpp-release.apk TestCpp-release-12.apk
cd ..

:API_13
::Change API level.(API level:13)
for /f "delims=" %%a in (ant.properties) do (
if "%%a"=="target=android-12" (echo/target=android-13)else echo/%%a 
)>>"ant1.properties"
move ant1.properties ant.properties

for /f "delims=" %%a in (ant.properties) do set num=%%a&call :lis
move ant1.properties ant.properties

::Android ant build(release,API level:13).
call ant release
set result13=%ERRORLEVEL%
if "%_PROJECTNAME%" NEQ "TestCpp" goto NEXTPROJ
if %result13% NEQ 0 goto NEXTPROJ
cd bin
ren TestCpp-release.apk TestCpp-release-13.apk
cd ..

:NEXTPROJ
::After all test versions completed,changed current API level to the original.(API level:8) 
for /f "delims=" %%a in (ant.properties) do (
if "%%a"=="target=android-13" (echo/target=android-8)else echo/%%a 
)>>"ant1.properties"
move ant1.properties ant.properties

for /f "delims=" %%a in (ant.properties) do set num=%%a&call :lis
move ant1.properties ant.properties

::Calculate the errorlevel and change build target.
cd ..\..\..
IF "%_PROJECTNAME%"=="TestCpp" set /a testresult1=(result8+result10+result11+result12+result13) && set _PROJECTNAME=HelloCpp&& goto project
IF "%_PROJECTNAME%"=="HelloCpp" set /a testresult2=(result8+result10+result11+result12+result13) && set _PROJECTNAME=HelloLua&& goto project
IF "%_PROJECTNAME%"=="HelloLua" set /a testresult3=(result8+result10+result11+result12+result13)
set /a testresult=(testresult1+testresult2+testresult3)
IF %testresult% NEQ 0 goto error

goto success

:lis
if "%num%"=="" goto :eof
if "%num:~-1%"==" " set num=%num:~0,-1%&goto lis
echo %num%>>ant1.properties
goto :eof 

:error
echo Compile Error!
echo %Compile_Result%
::git checkout -f
::git clean -df -x
exit 1

:success
echo Compile Success!
echo %Compile_Result%
::git checkout -f
::git clean -df -x
exit 0

::End.