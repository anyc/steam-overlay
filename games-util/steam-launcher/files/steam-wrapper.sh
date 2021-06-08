#!/bin/bash

# Set a default STEAM_RUNTIME value.
: ${STEAM_RUNTIME:=@@STEAM_RUNTIME@@}
export STEAM_RUNTIME

# Gentoo's lsb-release doesn't set this.
export DISTRIB_RELEASE="@@PVR@@"

# Find joystick devices to make Steam's old SDL library use them.
IFS=$'\n'
for f in $(find /dev/input -maxdepth 1 -type c | sort --version-sort); do
	if udevadm info --query=property --name="$f" 2>/dev/null | grep --quiet ID_INPUT_JOYSTICK=1; then
		export SDL_JOYSTICK_DEVICE+=${SDL_JOYSTICK_DEVICE+:}$f
	fi
done
unset IFS

# Add paths to occasionally needed libraries not found in /usr/lib.
export LD_LIBRARY_PATH+="${LD_LIBRARY_PATH+:}@@GENTOO_LD_LIBRARY_PATH@@"

. "${0%/*}"/../lib/steam/bin_steam.sh
