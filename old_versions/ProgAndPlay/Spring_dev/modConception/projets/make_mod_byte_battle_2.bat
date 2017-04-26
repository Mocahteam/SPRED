REM creation de la nouvelle archive
CD Byte_Battle_2
DEL Byte_Battle_2.sdz
SET zip=..\..\..\spring_0.82.5.1\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn Byte_Battle_2.sdz *

REM copie et execution
SET repSpring="C:\Program Files (x86)\Spring"
MKDIR %repSpring%\mods\
COPY Byte_Battle_2.sdz %repSpring%\mods\
CD /D %repSpring%
spring.exe

REM retour au repertoire
REM CD /D F:\Mathieu\These\ProgAndPlay\Spring_dev\modConception\projets