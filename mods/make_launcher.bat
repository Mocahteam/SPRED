taskkill /im spring.exe

CD Editor_Launcher
SET zip=..\..\..\mods\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn ..\..\..\..\spring-0.82.5.1\mods\Editor_Launcher.sdz *

REM execution
cd ..\..\..\..\spring-0.82.5.1
spring.exe

