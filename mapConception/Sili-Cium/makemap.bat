mapconv.exe -i -x 256 -n 10 -t texture.bmp -a heightmap.bmp -m metalmap.bmp -f grassmap.bmp -g geovent.bmp -o "Sili-CiumMap.smf" -c 0 -l

copy mini.dds Sili-CiumMap.sdd\maps\
copy mini.bmp Sili-CiumMap.sdd\maps\
copy Sili-CiumMap.smt Sili-CiumMap.sdd\maps\
copy Sili-CiumMap.smf Sili-CiumMap.sdd\maps\

cd Sili-CiumMap.sdd
SET zip=..\..\..\tools\7za.exe
%zip% a -r -tzip -y -xr!.svn Sili-CiumMap.sdz .
cp Sili-CiumMap.sdz ..

PAUSE