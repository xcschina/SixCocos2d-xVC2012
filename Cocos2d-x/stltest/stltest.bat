set name=%~n0
Set VC2013ROOT=D:\Program Files\Program Files (x86)\Microsoft Visual Studio 12.0
Set VCROOT=C:\Program Files (x86)\Microsoft Visual Studio 11.0
Set PATH=%VCROOT%\VC\bin;%VCROOT%\Common7\IDE;%PATH%
Set INCLUDE=%VCROOT%\VC\atlmfc\include;%VCROOT%\VC\include;%INCLUDE%
Set LIB=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib;%VCROOT%\VC\lib;%LIB%
cl  /nologo /c /GX /MT /IInclude "%name%.cpp"
link kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib  /nologo /opt:noref /SUBSYSTEM:CONSOLE /LIBPATH:Lib /OUT:"%name%.exe" "%name%.obj"
%name%.exe
pause