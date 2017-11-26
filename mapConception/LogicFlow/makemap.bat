mapconv.exe -i -x 256 -n 10 -t texture.bmp -a heightmap.bmp -m metalmap.bmp -f grassmap.bmp -g geovent.bmp -o "LogicFlowMap.smf" -c 0 -l

copy mini.dds LogicFlowMap.sdd\maps\
copy mini.bmp LogicFlowMap.sdd\maps\
copy LogicFlowMap.smt LogicFlowMap.sdd\maps\
copy LogicFlowMap.smf LogicFlowMap.sdd\maps\

cd LogicFlowMap.sdd
SET zip=..\..\..\7za.exe
%zip% a -r -tzip -y -xr!.svn LogicFlowMap.sdz .
mv LogicFlowMap.sdz ..

PAUSE