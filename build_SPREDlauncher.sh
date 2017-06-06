#!/bin/bash
#Build player archive
#==================
#remove existing player archive
rm ./game.sdz
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
zip -r ../game.sdz *
#remove tmp folder
cd ..
rm -rf ./build_player_tmp
#==================

#Build editor archive
#==================
#remove existing editor archive
rm ./editor.sdz
#make temporary directory
mkdir ./build_editor_tmp
#import editor src
cp -r ./editor/* ./build_editor_tmp
#import chili src
mkdir -p ./build_editor_tmp/LuaUI/Widgets
cp -r ./usefullFiles/chili_src/* ./build_editor_tmp/LuaUI/Widgets
#import others dependencies
cp -r ./usefullFiles/commonFiles/* ./build_editor_tmp
#import ModInfo file
cp ./usefullFiles/FilesForStandaloneEditor/ModInfo.lua ./build_editor_tmp
#import game archive
cp ./game.sdz ./build_editor_tmp
#build editor archive
cd ./build_editor_tmp
zip -r ../editor.sdz *
#remove tmp folder
cd ..
rm -rf ./build_editor_tmp
#==================

#Build launcher archive
#==================
#remove existing editor archive
rm ./SPRED_Launcher.sdz
#make temporary directory
mkdir ./build_launcher_tmp
#import launcher src
cp -r ./launcher/* ./build_launcher_tmp
#import chili src
mkdir -p ./build_launcher_tmp/LuaUI/Widgets
cp -r ./usefullFiles/chili_src/* ./build_launcher_tmp/LuaUI/Widgets
#import editor archive
mv ./editor.sdz ./build_launcher_tmp
#build archive
cd ./build_launcher_tmp
zip -r ../SPRED_Launcher.sdz *
#remove tmp folder
cd ..
rm -rf build_launcher_tmp
#==================
