#!/bin/bash 
# Note: You need to download a NES ROM and place it in the same directory as the Containerfile
# and replace "nesrom.nes" in this retro_arcade.sh and in the Containerfile with the filename of the nes ROM file.
/usr/bin/flatpak run org.libretro.RetroArch -L /opt/retroarch/cores/nestopia_libretro.so /opt/retroarch/roms/nesrom.nes
