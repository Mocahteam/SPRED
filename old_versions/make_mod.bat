SET VERSION=2.4
taskkill /im spring.exe
REM creation de la nouvelle archive
DEL KP_campaign_%VERSION%.sdz
CD KP_campaign_%VERSION%
SET zip=..\7za.exe
%zip% a -r -tzip -y -xr!.svn ..\KP_campaign_%VERSION%.sdz *
CD ..

REM execution
del C:\Users\mmuratet\Downloads\Spring-git\mods\KP_campaign_%VERSION%.sdz
move KP_campaign_%VERSION%.sdz C:\Users\mmuratet\Downloads\Spring-git\mods\KP_campaign_%VERSION%.sdz
cd C:\Users\mmuratet\Downloads\Spring-git
spring.exe

