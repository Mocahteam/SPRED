taskkill /im spring.exe

rem begin
mkdir editor_launcher_tmp
xcopy Editor_Launcher editor_launcher_tmp /S /E
rem TODO : import usefull game files to editor
rem editor
cd Prog_Play_Level_Editor_0.1
..\7za.exe a -r -tzip -y -xr!.svn ..\editor_launcher_tmp\editor_files.sdz *
rem player
cd ..\KP_campaign_2.4
..\7za.exe a -r -tzip -y -xr!.svn ..\editor_launcher_tmp\game_files.sdz *
rem final archive
cd ..\editor_launcher_tmp
..\7za.exe a -r -tzip -y -xr!.svn ..\PPLE_Launcher.sdz *
cd ..
rmdir /Q /S editor_launcher_tmp

del ..\..\mods\PPLE_Launcher.sdz
move PPLE_Launcher.sdz ..\..\mods\PPLE_Launcher.sdz
cd ..\..
spring.exe