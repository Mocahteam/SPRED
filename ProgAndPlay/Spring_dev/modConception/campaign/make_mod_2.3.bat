REM creation de la nouvelle archive
CD KP_campaign_2.3
DEL KP_campaign_2.3.sdz
SET zip=..\..\..\spring_0.82.5.1\mingwlibs\bin\7za.exe
%zip% a -r -tzip -y -xr!.svn KP_campaign_2.3.sdz *

REM copie et execution
SET repSpring="C:\Program Files (x86)\Spring"
REM MKDIR %repSpring%\mods\
COPY KP_campaign_2.3.sdz %repSpring%\mods
CD /D %repSpring%
spring.exe

REM retour au repertoire
REM CD /D C:\Users\Mathieu\Documents\INSHEA\Recherche\Projets\ProgAndPlay\Spring_dev\modConception\campaign
