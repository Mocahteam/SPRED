taskkill /im spring.exe

CD Editor_Launcher
SET zip=..\..\..\mods\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn ..\..\..\..\spring-100.0\games\Editor_Launcher.sdz *

REM execution
cd ..\..\..\..\spring-100.0
spring.exe

