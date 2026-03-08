#!/bin/bash 
# Note: You need to download a MAME ROM and place it in the same directory as the Containerfile
# and replace "mamerom.zip" in this retro_arcade.sh and in the Containerfile with the filename of the zip ROM file.

# Uncomment if you are running this on a MAME make OS.
# /opt/mame/mame /opt/mame/roms/mamerom.zip

# Comment if you are running this on a Mame make OS. Make sure to place the MAME ROM in /opt/mame/roms and update the filename in the command below.
/usr/bin/flatpak run org.mamedev.MAME /opt/mame/roms/mamerom.zip
