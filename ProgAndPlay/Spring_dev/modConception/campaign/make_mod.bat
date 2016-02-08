REM creation de la nouvelle archive
CD KP_campaign_2.2
DEL KP_campaign_2.2.sdz
SET zip=..\..\..\spring_0.82.5.1\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn KP_campaign_2.2.sdz *

REM copie et execution
SET repSpring="C:\Program Files\Spring"
MKDIR %repSpring%\mods\
COPY KP_campaign_2.2.sdz %repSpring%\mods\
REM CD /D %repSpring%
REM spring.exe --safemode

REM retour au repertoire
REM CD /D F:\Mathieu\These\ProgAndPlay\Spring_dev\modConception\campaign