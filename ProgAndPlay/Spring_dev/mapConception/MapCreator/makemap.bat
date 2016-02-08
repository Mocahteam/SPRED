mapconv.exe -i -x 10 -n 10 -t texture.bmp -a heightmap.bmp -m metalmap.bmp -f features.bmp -o "ByteBattleMap.smf" -c 0 -l

copy mini.dds FinalMap\maps\
copy mini.bmp FinalMap\maps\
copy ByteBattleMap.smt FinalMap\maps\
copy ByteBattleMap.smf FinalMap\maps\

PAUSE