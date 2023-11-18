#!/bin/bash

# Set a default STEAM_RUNTIME value.
: ${STEAM_RUNTIME:=@@STEAM_RUNTIME@@}
export STEAM_RUNTIME

# Gentoo's lsb-release doesn't set this.
export DISTRIB_RELEASE="@@PVR@@"

# Add paths to occasionally needed libraries not found in /usr/lib.
export LD_LIBRARY_PATH+="${LD_LIBRARY_PATH+:}@@GENTOO_LD_LIBRARY_PATH@@"

# Preload the extest library when running in wayland session
if [ -f `find "/usr/lib/gcc/x86_64-pc-linux-gnu/$(gcc --version | grep gcc | sed -E 's|[A-Za-z]+\s+\([^)]*\)\s+||' | cut -f 1 -d '.')/32" -type l -name "libstdc++.so"` ] &&
		[ "$(eselect profile list | grep '\*' | grep clang)" != "" ] &&
  		[ -f "@@GENTOO_X86_LIBDIR@@/libextest.so" ] &&
  		[ "$XDG_SESSION_TYPE" = "wayland" ]; then
	export LD_PRELOAD+="${LD_PRELOAD+:}@@GENTOO_X86_LIBDIR@@/libextest.so"
	# Fixes Steam not properly launching on LLVM+Wayland systems
	# Backticks (``) are being used because it captures spaces inside paths; not that there should be. Shellcheck will complain about this.
	export LD_PRELOAD+="${LD_PRELOAD+:}`find "/usr/lib/gcc/x86_64-pc-linux-gnu/$(gcc --version | grep gcc | sed -E 's|[A-Za-z]+\s+\([^)]*\)\s+||' | cut -f 1 -d '.')/32" -type l -name "libstdc++.so"`"
elif [[ -f "@@GENTOO_X86_LIBDIR@@/libextest.so" &&
		${XDG_SESSION_TYPE} == wayland ]]; then
	export LD_PRELOAD+="${LD_PRELOAD+:}@@GENTOO_X86_LIBDIR@@/libextest.so"
fi

# Steam renames LD_LIBRARY_PATH to SYSTEM_LD_LIBRARY_PATH and it then becomes
# ineffective against games. We unfortunately therefore have to force the value
# through via STEAM_RUNTIME_LIBRARY_PATH instead.
export STEAM_RUNTIME_LIBRARY_PATH="${LD_LIBRARY_PATH}"

. "${0%/*}"/../lib/steam/bin_steam.sh
