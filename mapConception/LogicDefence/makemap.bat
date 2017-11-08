mapconv.exe -i -x 256 -n 10 -t texture.bmp -a heightmap.bmp -m metalmap.bmp -f grassmap.bmp -g geovent.bmp -o "LogicDefenceMap.smf" -c 0 -l

copy mini.dds LogicDefenceMap.sdd\maps\
copy mini.bmp LogicDefenceMap.sdd\maps\
copy LogicDefenceMap.smt LogicDefenceMap.sdd\maps\
copy LogicDefenceMap.smf LogicDefenceMap.sdd\maps\

cd LogicDefenceMap.sdd
SET zip=..\..\..\7za.exe
%zip% a -r -tzip -y -xr!.svn LogicDefenceMap.sdz .
mv LogicDefenceMap.sdz ..

PAUSE