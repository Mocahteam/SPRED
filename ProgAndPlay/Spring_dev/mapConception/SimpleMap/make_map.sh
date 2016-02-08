#! /bin/bash

# creation de la nouvelle archive
rm SimpleMap.sdz
zip -r SimpleMap.sdz maps
zip -d SimpleMap.sdz \*.svn/\*


# copie et execution
mkdir ~/spring/maps/
cp SimpleMap.sdz ~/spring/maps/
