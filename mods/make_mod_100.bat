SET VERSION=2.4
taskkill /im spring.exe
REM creation de la nouvelle archive
DEL KP_campaign_%VERSION%.sdz
CD KP_campaign_%VERSION%
SET zip=..\..\..\mods\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn ..\..\..\..\spring-100.0\games\KP_campaign_%VERSION%.sdz *

REM execution
cd ..\..\..\..\spring-100.0
spring.exe
