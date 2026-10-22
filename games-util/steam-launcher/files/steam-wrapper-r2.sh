#!/bin/bash

# Disallow overriding STEAM_RUNTIME. Setting it to 0 is unsupported and largely
# ineffective. Setting it to 1 breaks things.
unset STEAM_RUNTIME

# Gentoo's lsb-release doesn't set this.
export DISTRIB_RELEASE="@@PVR@@"

# Force the 64-bit client.
export STEAM_FORCE_CLIENT="steamrt64"

steam="${XDG_DATA_HOME:-${HOME}/.local/share}/Steam"
beta="${steam}/package/beta"

# The 64-bit client currently requires opting into the beta.
[[ -s ${beta} ]] || install -D -m0600 /dev/stdin "${beta}" <<< publicbeta

# Older installations don't check STEAM_FORCE_CLIENT.
touch "${steam}/.steam-enable-steamrt64-client"

. "${0%/*}"/../lib/steam/bin_steam.sh
