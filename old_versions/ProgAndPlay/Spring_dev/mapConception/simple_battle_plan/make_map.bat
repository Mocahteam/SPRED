REM creation de la nouvelle archive
DEL simple_battle_plan.sdz
SET zip=..\..\spring_0.82.5.1\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn simple_battle_plan.sdz maps

REM copie
SET repMaps="C:\Program Files\Spring\maps"
MKDIR %repMaps%
COPY simple_battle_plan.sdz %repMaps%
