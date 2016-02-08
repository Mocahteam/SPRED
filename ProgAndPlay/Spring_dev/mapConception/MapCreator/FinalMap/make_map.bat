REM creation de la nouvelle archive
DEL ByteBattleMap.sdz
SET zip=..\..\..\spring_88.0\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn ByteBattleMap.sdz maps

REM copie
SET repMaps="C:\Program Files\Spring\maps"
MKDIR %repMaps%
COPY ByteBattleMap.sdz %repMaps%