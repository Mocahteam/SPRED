SET VERSION=0.1
taskkill /im spring.exe

copy Prog_Play_Level_Editor_%VERSION%\82\ModInfo.lua Prog_Play_Level_Editor_%VERSION%
CD Prog_Play_Level_Editor_%VERSION%
..\7za.exe a -r -tzip -y -xr!.svn ..\..\..\mods\Prog_Play_Level_Editor_%VERSION%.sdz *

REM execution
cd ..\..\..
spring.exe
