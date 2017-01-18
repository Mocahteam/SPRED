taskkill /im spring.exe

rem Build player archive
rem ==================
rem remove existing player archive
del "SPRED test player.sdz"
rem make temporary directory
mkdir build_player_tmp
rem import player src
xcopy player build_player_tmp /S /E
rem import chili src
xcopy usefullFiles\chili_src build_player_tmp\LuaUI\Widgets /S /E
rem import others dependencies
xcopy usefullFiles\commonFiles build_player_tmp /S /E
rem import ModInfo file and others
xcopy usefullFiles\FilesForStandalonePlayer build_player_tmp /S /E
rem build player archive
cd build_player_tmp
..\7za.exe a -r -tzip -y -xr!.svn "..\SPRED test player.sdz" *
rem remove tmp folder
cd ..
rmdir /Q /S build_player_tmp
rem ==================

rem install player archive
del "C:\Users\mmuratet\Downloads\Spring-git\mods\SPRED test player.sdz"
copy "SPRED test player.sdz" "C:\Users\mmuratet\Downloads\Spring-git\mods\SPRED test player.sdz"

REM execution
cd C:\Users\mmuratet\Downloads\Spring-git
spring.exe