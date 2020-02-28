mapconv.exe -i -x 256 -n 10 -t texture.bmp -a heightmap.bmp -m metalmap.bmp -f grassmap.bmp -g geovent.bmp -o "FinalBattleMap.smf" -c 0 -l

copy mini.dds FinalBattleMap.sdd\maps\
copy mini.bmp FinalBattleMap.sdd\maps\
copy FinalBattleMap.smt FinalBattleMap.sdd\maps\
copy FinalBattleMap.smf FinalBattleMap.sdd\maps\

cd FinalBattleMap.sdd
SET zip=..\..\..\7za.exe
%zip% a -r -tzip -y -xr!.svn FinalBattleMap.sdz .
mv FinalBattleMap.sdz ..

PAUSE