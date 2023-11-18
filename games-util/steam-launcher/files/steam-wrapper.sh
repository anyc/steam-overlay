#!/bin/bash

# Set a default STEAM_RUNTIME value.
: ${STEAM_RUNTIME:=@@STEAM_RUNTIME@@}
export STEAM_RUNTIME

# Gentoo's lsb-release doesn't set this.
export DISTRIB_RELEASE="@@PVR@@"

# Add paths to occasionally needed libraries not found in /usr/lib.
export LD_LIBRARY_PATH+="${LD_LIBRARY_PATH+:}@@GENTOO_LD_LIBRARY_PATH@@"

# Preload the extest library when running in a Wayland session.
[[ -f "@@GENTOO_X86_LIBDIR@@/libextest.so" && ${XDG_SESSION_TYPE} == wayland ]] &&
	export LD_PRELOAD+="${LD_PRELOAD+:}@@GENTOO_X86_LIBDIR@@/libextest.so"

# Preload libstdc++ on default-libcxx systems to avoid crashes. Loading the
# 64-bit library prevents Steam from working at all, so only load the 32-bit
# multlib library. Pure 32-bit systems are untested and may not work.
if grep -Fxqe --stdlib=libc++ /etc/clang/gentoo-runtimes.cfg 2>/dev/null; then
	IFS=:
	for GCC_LIB_DIR in $(gcc-config -L 2>/dev/null); do
		[[ ${GCC_LIB_DIR} == */32 ]] || continue
		export LD_PRELOAD+="${LD_PRELOAD+:}${GCC_LIB_DIR}/libstdc++.so"
	done
	unset IFS GCC_LIB_DIR
fi

# Steam renames LD_LIBRARY_PATH to SYSTEM_LD_LIBRARY_PATH and it then becomes
# ineffective against games. We unfortunately therefore have to force the value
# through via STEAM_RUNTIME_LIBRARY_PATH instead.
export STEAM_RUNTIME_LIBRARY_PATH="${LD_LIBRARY_PATH}"

. "${0%/*}"/../lib/steam/bin_steam.sh
