REM creation de la nouvelle archive
CD EIAH_2013
DEL EIAH_2013.sdz
SET zip=..\..\..\spring_0.82.5.1\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn EIAH_2013.sdz *

REM copie et execution
SET repSpring="C:\Program Files (x86)\Spring"
MKDIR %repSpring%\mods\
COPY EIAH_2013.sdz %repSpring%\mods\
CD /D %repSpring%
spring.exe