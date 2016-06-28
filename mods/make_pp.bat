taskkill /im spring.exe

rem begin
mkdir editor_launcher_tmp
xcopy Editor_Launcher editor_launcher_tmp /S /E
rem TODO : import usefull game files to editor
rem editor
cd Prog_Play_Level_Editor_0.1
..\7za.exe a -r -tzip -y -xr!.svn ..\editor_launcher_tmp\editor.sdz *
rem player
cd ..\KP_campaign_2.4
..\7za.exe a -r -tzip -y -xr!.svn ..\editor_launcher_tmp\game.sdz *
rem final archive
cd ..\editor_launcher_tmp
..\7za.exe a -r -tzip -y -xr!.svn ..\SPRED.sdz *
cd ..
rmdir /Q /S editor_launcher_tmp

del ..\..\mods\SPRED.sdz
move SPRED.sdz ..\..\mods\SPRED.sdz
cd ..\..
spring.exe