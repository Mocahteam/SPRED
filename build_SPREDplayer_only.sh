#!/bin/bash
#Build player archive
#==================
#remove existing player archive
rm ./SPRED_test_player.sdz
#make temporary directory
mkdir ./build_player_tmp
#import player src
cp -r ./player/* ./build_player_tmp
#import chili src
mkdir -p ./build_player_tmp/LuaUI/Widgets
cp -r ./usefullFiles/chili_src/* ./build_player_tmp/LuaUI/Widgets
#import others dependencies
cp -r ./usefullFiles/commonFiles/* ./build_player_tmp
#build player archive
cd build_player_tmp
zip -r ../SPRED_test_player.sdz *
#remove tmp folder
cd ..
rm -rf ./build_player_tmp
#==================
