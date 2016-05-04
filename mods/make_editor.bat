SET VERSION=0.1
taskkill /im spring.exe

copy 82\ModInfo.lua Prog_Play_Level_Editor_%VERSION%
CD Prog_Play_Level_Editor_%VERSION%
SET zip=..\..\..\mods\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn ..\..\..\mods\Prog_Play_Level_Editor_%VERSION%.sdz *

REM execution
cd ..\..\..
spring.exe

