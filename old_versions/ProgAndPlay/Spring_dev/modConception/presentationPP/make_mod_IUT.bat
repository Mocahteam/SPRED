REM creation de la nouvelle archive
CD IUT_PuyEnVelay
DEL IUT_PuyEnVelay.sdz
SET zip=..\..\..\spring_0.82.5.1\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn IUT_PuyEnVelay.sdz *

REM copie et execution
SET repSpring="C:\Program Files (x86)\Spring"
MKDIR %repSpring%\mods\
COPY IUT_PuyEnVelay.sdz %repSpring%\mods\
CD /D %repSpring%
spring.exe