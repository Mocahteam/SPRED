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
del "SPRED test editor.sdz"
rem make temporary directory
mkdir build_editor_tmp
rem import editor src
xcopy editor build_editor_tmp /S /E
rem import chili src
xcopy usefullFiles\chili_src build_editor_tmp\LuaUI\Widgets /S /E
rem import others dependencies
xcopy usefullFiles\commonFiles build_editor_tmp /S /E
rem import ModInfo file
copy usefullFiles\FilesForStandaloneEditor\ModInfo.lua build_editor_tmp
rem import game archive
copy game.sdz build_editor_tmp
rem build editor archive
cd build_editor_tmp
..\7za.exe a -r -tzip -y -xr!.svn "..\SPRED test editor.sdz" *
rem remove tmp folder
cd ..
rmdir /Q /S build_editor_tmp
rem ==================

rem install editor archive
del "C:\Users\mmuratet\Downloads\Spring-git\mods\SPRED test editor.sdz"
copy "SPRED test editor.sdz" "C:\Users\mmuratet\Downloads\Spring-git\mods\SPRED test editor.sdz"

REM execution
cd C:\Users\mmuratet\Downloads\Spring-git
spring.exe