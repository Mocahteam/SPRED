#! /bin/bash

# creation de la nouvelle archive
cd KP_campaign_2.2
rm KP_campaign_2.2.sdz
zip -r KP_campaign_2.2.sdz *
zip -d KP_campaign_2.2.sdz \*.svn/\*

# copie et execution
mkdir ~/spring/mods/
cp KP_campaign_2.2.sdz ~/spring/mods/
cd ~/docs/ProgAndPlay/Spring_dev/spring_0.82.5.1
./spring

# retour au repertoire
cd ~/docs/ProgAndPlay/Spring_dev/modConception/campaign