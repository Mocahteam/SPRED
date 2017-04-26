#! /bin/bash

# creation de la nouvelle archive
rm ByteBattleMap.sdz
zip -r ByteBattleMap.sdz maps
zip -d ByteBattleMap.sdz \*.svn/\*

#copie et execution
mkdir ~/spring/maps/
cp ByteBattleMap.sdz ~/spring/maps
