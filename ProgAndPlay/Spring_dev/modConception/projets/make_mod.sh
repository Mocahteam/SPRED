#! /bin/bash

# creation de la nouvelle archive
cd Byte_Battle_2
rm Byte_Battle_2.sdz
zip -r Byte_Battle_2.sdz *
zip -d Byte_Battle_2.sdz \*.svn/\*

# copie et execution
mkdir ~/spring/mods/
cp Byte_Battle_2.sdz ~/spring/mods/
cd ~/docs/ProgAndPlay/Spring_dev/spring_0.82.5.1
./spring

# retour au repertoire
cd ~/docs/ProgAndPlay/Spring_dev/modConception/projets/