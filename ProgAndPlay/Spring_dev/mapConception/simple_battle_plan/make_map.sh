#! /bin/bash

# creation de la nouvelle archive
rm simple_battle_plan.sdz
zip -r simple_battle_plan.sdz maps
zip -d simple_battle_plan.sdz \*.svn/\*


# copie et execution
mkdir ~/spring/maps/
cp simple_battle_plan.sdz ~/spring/maps/
