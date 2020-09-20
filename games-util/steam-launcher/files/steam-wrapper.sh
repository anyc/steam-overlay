#!/bin/bash

if [[ -f "${HOME}/.steamrc" ]]; then
	source ${HOME}/.steamrc
fi

if [[ -z "${STEAM_USER}" ]]; then
	# Set a default STEAM_RUNTIME value.
	: ${STEAM_RUNTIME:=@@STEAM_RUNTIME@@}
	export STEAM_RUNTIME

	# Gentoo's lsb-release doesn't set this.
	export DISTRIB_RELEASE="@@PVR@@"

	# Find joystick devices to make Steam's old SDL library use them.
	IFS=$'\n'
	cd # fix find error if run with a different user
	for f in $(find /dev/input -maxdepth 1 -type c | sort --version-sort); do
		if udevadm info --query=property --name="$f" 2>/dev/null | grep --quiet ID_INPUT_JOYSTICK=1; then
			export SDL_JOYSTICK_DEVICE+=${SDL_JOYSTICK_DEVICE+:}$f
		fi
	done
	unset IFS

	# Add paths to occasionally needed libraries not found in /usr/lib.
	export LD_LIBRARY_PATH+="${LD_LIBRARY_PATH+:}@@GENTOO_LD_LIBRARY_PATH@@"

	# Steam appends /usr/lib32 to LD_LIBRARY_PATH. We need to make sure
	# that OpenGL implementation dir goes before that, so we need to
	# append it to user's LD_LIBRARY_PATH ourselves. But that's needed
	# only with the new eselect-opengl that uses 000opengl file.
	if [[ -f "/etc/env.d/000opengl" ]]; then
		. "/etc/env.d/000opengl"
		# Append only when LDPATH is non-empty -- i.e. using nvidia or ati.
		[[ -n "${LDPATH}" ]] && LD_LIBRARY_PATH+=":${LDPATH}"
	fi

	if [[ -n "${STEAM_HOME}" ]]; then
		if [[ -w "${STEAM_HOME}" ]]; then
			HOME="${STEAM_HOME}"
			echo "running steam as user \"$(whoami)\", within \"${HOME}\""
			. "${0%/*}"/../lib/steam/bin_steam.sh
		else
			echo "${STEAM_HOME} is not writeable for user \"$(whoami)\""
			exit 1
		fi
	else
		. "${0%/*}"/../lib/steam/bin_steam.sh
	fi
else
	# check if required commands are available
	[[ $(command -v /usr/bin/sudo) ]] || \
		{ echo "You need \"app-admin/sudo\" installed to run steam as different user"; exit 1; }
	[[ $(command -v /usr/bin/xhost) ]] || \
		{ echo "You need \"x11-apps/xhost\" installed to run steam as different user"; exit 1; }

	echo "executing steam as user \"${STEAM_USER}\""
	/usr/bin/xhost si:localuser:${STEAM_USER}
	/usr/bin/sudo STEAM_HOME=${STEAM_HOME} -u ${STEAM_USER} -- "${0}"
	/usr/bin/xhost -si:localuser:${STEAM_USER}
fi
