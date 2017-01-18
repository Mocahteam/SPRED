taskkill /im spring.exe

rem Build player archive
rem ==================
rem remove existing player archive
del game.sdz
rem make temporary directory
mkdir build_player_tmp
rem import player src
xcopy player build_player_tmp /S /E
rem import chili src
xcopy usefullFiles\chili_src build_player_tmp\LuaUI\Widgets /S /E
rem import others dependencies
xcopy usefullFiles\commonFiles build_player_tmp /S /E
rem build player archive
cd build_player_tmp
..\7za.exe a -r -tzip -y -xr!.svn ..\game.sdz *
rem remove tmp folder
cd ..
rmdir /Q /S build_player_tmp
rem ==================

rem Build editor archive
rem ==================
rem remove existing editor archive
del editor.sdz
rem make temporary directory
mkdir build_editor_tmp
rem import editor src
xcopy editor build_editor_tmp /S /E
rem import chili src
xcopy usefullFiles\chili_src build_editor_tmp\LuaUI\Widgets /S /E
rem import others dependencies
xcopy usefullFiles\commonFiles build_editor_tmp /S /E
rem import game archive
copy game.sdz build_editor_tmp
rem build editor archive
cd build_editor_tmp
..\7za.exe a -r -tzip -y -xr!.svn ..\editor.sdz *
rem remove tmp folder
cd ..
rmdir /Q /S build_editor_tmp
rem ==================

rem Build launcher archive
rem ==================
rem remove existing editor archive
del SPRED_Launcher.sdz
rem make temporary directory
mkdir build_launcher_tmp
rem import launcher src
xcopy launcher build_launcher_tmp /S /E
rem import chili src
xcopy usefullFiles\chili_src build_launcher_tmp\LuaUI\Widgets /S /E
rem import editor archive
move editor.sdz build_launcher_tmp
rem build archive
cd build_launcher_tmp
..\7za.exe a -r -tzip -y -xr!.svn ..\SPRED_Launcher.sdz *
rem remove tmp folder
cd ..
rmdir /Q /S build_launcher_tmp
rem ==================
