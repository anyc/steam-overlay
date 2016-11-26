# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit pax-utils

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Valve's native Steam client"
HOMEPAGE="http://steampowered.com"
LICENSE="metapackage"

SLOT="0"
KEYWORDS=""
IUSE="flash +pulseaudio steamfonts +steamruntime streaming trayicon video_cards_intel video_cards_nvidia"

# This can help to determine the dependencies:
# find ~/.steam/root/ -exec readelf -d {} + 2>/dev/null | grep Shared | sort -u | fgrep -v -f <(ls -1 ~/.steam/root/ubuntu12_32/)

RDEPEND="
		media-fonts/font-mutt-misc
		|| ( media-fonts/font-bitstream-100dpi media-fonts/font-adobe-100dpi )

		virtual/opengl[abi_x86_32]

		flash? ( www-plugins/adobe-flash[abi_x86_32] )
		trayicon? ( sys-apps/dbus )
		steamfonts? ( media-fonts/steamfonts )

		amd64? (
			!media-libs/mesa[-abi_x86_32]
			!x11-misc/virtualgl[-abi_x86_32]
			)

		x86? (
			video_cards_intel? ( >=media-libs/mesa-9 )
			)

		!steamruntime? (
			app-arch/bzip2[abi_x86_32]
			dev-libs/atk[abi_x86_32]
			dev-libs/dbus-glib[abi_x86_32]
			dev-libs/expat[abi_x86_32]
			dev-libs/glib:2[abi_x86_32]
			dev-libs/libgcrypt[abi_x86_32]
			dev-libs/nspr[abi_x86_32]
			dev-libs/nss[abi_x86_32]
			gnome-base/gconf:2[abi_x86_32]
			media-libs/alsa-lib[abi_x86_32]
			media-libs/flac[abi_x86_32]
			media-libs/fontconfig[abi_x86_32]
			media-libs/freetype[abi_x86_32]
			media-libs/libpng:1.2[abi_x86_32]
			media-libs/libvorbis[abi_x86_32]
			media-libs/openal[abi_x86_32]
			net-misc/curl[abi_x86_32]
			net-misc/networkmanager[abi_x86_32]
			net-print/cups[abi_x86_32]
			sys-apps/dbus[abi_x86_32]
			sys-libs/libudev-compat[abi_x86_32]
			virtual/libgudev[abi_x86_32]
			virtual/libusb[abi_x86_32]
			x11-libs/cairo[abi_x86_32]
			x11-libs/gdk-pixbuf[abi_x86_32]
			x11-libs/gtk+:2[abi_x86_32,cups]
			x11-libs/libICE[abi_x86_32]
			x11-libs/libSM[abi_x86_32]
			x11-libs/libX11[abi_x86_32]
			x11-libs/libXScrnSaver[abi_x86_32]
			x11-libs/libXcomposite[abi_x86_32]
			x11-libs/libXcursor[abi_x86_32]
			x11-libs/libXdamage[abi_x86_32]
			x11-libs/libXext[abi_x86_32]
			x11-libs/libXfixes[abi_x86_32]
			x11-libs/libXi[abi_x86_32]
			x11-libs/libXinerama[abi_x86_32]
			x11-libs/libXrandr[abi_x86_32]
			x11-libs/libXrender[abi_x86_32]
			x11-libs/libXtst[abi_x86_32]
			x11-libs/pango[abi_x86_32]

			streaming? ( x11-libs/libva[abi_x86_32] )
			trayicon? ( dev-libs/libappindicator:2[abi_x86_32] )
			pulseaudio? ( media-sound/pulseaudio[abi_x86_32,caps] )
			!pulseaudio? ( media-sound/apulse[abi_x86_32] )

			video_cards_nvidia? ( || (
						<x11-drivers/nvidia-drivers-358
						>=x11-drivers/nvidia-drivers-361.18
						) )

			amd64? (
				>=sys-devel/gcc-4.6.0[multilib]
				>=sys-libs/glibc-2.15[multilib]
				)

			x86? (
				>=sys-devel/gcc-4.6.0
				>=sys-libs/glibc-2.15
				)
			)
		"

pkg_postinst() {
	elog "This is only a meta package that pulls in the required"
	elog "dependencies for the steam client."
	elog ""

	if use flash; then
		elog "In order to use flash, link the 32bit libflashplayer.so to"
		elog "\${STEAM_FOLDER}/ubuntu12_32/plugins/"
		elog ""
	fi

	if host-is-pax; then
		elog "If you're using PAX, please see:"
		elog "http://wiki.gentoo.org/wiki/Steam#Hardened_Gentoo"
		elog ""
	fi

	if ! use steamfonts; then
		elog "If the Steam client shows no or misaligned text, then"
		elog "please enable the steamfonts use flag."
	fi

	if ! use pulseaudio; then
		ewarn "You have disabled pulseaudio which is not supported."
		ewarn "You have to use media-sound/apulse instead to start"
		ewarn "steam. Please add '/usr/lib32/apulse' to your"
		ewarn "LD_LIBRARY_PATH environment variable or start steam"
		ewarn "with:"
		ewarn "# LD_LIBRARY_PATH=/usr/lib32/apulse steam"
		ewarn ""
	fi

	if has_version ">=media-libs/mesa-13.0.0[openssl]"; then
		ewarn "You have installed \">=mesa-13\" with openssl use flag."
		ewarn "If you are experiencing crashes please rebuild mesa with"
		ewarn "the nettle use flag enabled."
	fi

	ewarn "The steam client and the games are not controlled by"
	ewarn "portage. Updates are handled by the client itself."
}
