# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit pax-utils

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Valve's native Steam client"
HOMEPAGE="http://steampowered.com"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flash +pulseaudio steamfonts +steamruntime streaming trayicon video_cards_intel video_cards_nvidia"

RDEPEND="
		media-fonts/font-mutt-misc
		|| ( media-fonts/font-bitstream-100dpi media-fonts/font-adobe-100dpi )

		trayicon? ( sys-apps/dbus )

		steamfonts? ( media-fonts/steamfonts )

		amd64? (
			!x11-misc/virtualgl[-abi_x86_32]
			|| (
				app-emulation/emul-linux-x86-opengl
				virtual/opengl[abi_x86_32]
				)
			flash? ( www-plugins/adobe-flash[abi_x86_32] )
			)

		x86? (
			virtual/opengl
			video_cards_intel? ( >=media-libs/mesa-9 )
			flash? ( www-plugins/adobe-flash )
			)

		!steamruntime? (
			video_cards_nvidia? ( || (
						<x11-drivers/nvidia-drivers-332
						>=x11-drivers/nvidia-drivers-340.32
						) )

			amd64? (
				>=sys-devel/gcc-4.6.0[multilib]
				>=sys-libs/glibc-2.15[multilib]
				>=app-emulation/steam-runtime-bin-20131109

				dev-libs/dbus-glib[abi_x86_32]
				|| ( dev-libs/libgcrypt:0/11[abi_x86_32(-)] dev-libs/libgcrypt:11[abi_x86_32(-)] )
				dev-libs/nspr[abi_x86_32]
				dev-libs/nss[abi_x86_32]
				gnome-base/gconf:2[abi_x86_32]
				media-libs/openal[abi_x86_32]
				media-libs/alsa-lib[abi_x86_32]
				media-libs/flac[abi_x86_32]
				media-libs/libvorbis[abi_x86_32]
				media-libs/fontconfig[abi_x86_32]
				media-libs/freetype[abi_x86_32]
				net-misc/curl[abi_x86_32]
				sys-libs/libudev-compat[abi_x86_32]
				virtual/libgudev[abi_x86_32]
				virtual/libusb[abi_x86_32]
				x11-libs/gtk+:2[abi_x86_32,cups]
				x11-libs/gdk-pixbuf[abi_x86_32]
				x11-libs/libXi[abi_x86_32]
				x11-libs/libXinerama[abi_x86_32]
				x11-libs/libXrandr[abi_x86_32]
				x11-libs/libXrender[abi_x86_32]
				x11-libs/libSM[abi_x86_32]
				x11-libs/libICE[abi_x86_32]
				x11-libs/libX11[abi_x86_32]
				x11-libs/libXext[abi_x86_32]
				x11-libs/libXfixes[abi_x86_32]
				x11-libs/libXScrnSaver[abi_x86_32]
				x11-libs/pango[abi_x86_32]

				streaming? ( x11-libs/libva[abi_x86_32] )
				trayicon? ( || (
					dev-libs/libappindicator:2[abi_x86_32]
					dev-libs/libappindicator2[abi_x86_32]
					) )
				pulseaudio? ( media-sound/pulseaudio[abi_x86_32,caps] )
				!pulseaudio? ( media-sound/apulse[abi_x86_32] )
				)
			x86? (
				dev-libs/glib:2
				dev-libs/dbus-glib
				|| ( dev-libs/libgcrypt:0/11 dev-libs/libgcrypt:11 )
				virtual/libgudev
				virtual/libusb
				dev-libs/nspr
				dev-libs/nss
				media-libs/alsa-lib
				media-libs/fontconfig
				media-libs/freetype:2
				media-libs/libpng:1.2
				media-libs/openal
				net-misc/networkmanager
				net-print/cups
				sys-apps/dbus
				sys-libs/libudev-compat
				>=sys-devel/gcc-4.6.0
				>=sys-libs/glibc-2.15
				>=sys-libs/zlib-1.2.4
				x11-libs/cairo
				x11-libs/gdk-pixbuf
				x11-libs/gtk+:2
				x11-libs/libSM
				x11-libs/libICE
				>=x11-libs/libX11-1.5
				x11-libs/libXext
				x11-libs/libXfixes
				x11-libs/libXi
				x11-libs/libXinerama
				x11-libs/libXrandr
				x11-libs/libXrender
				x11-libs/libXScrnSaver
				x11-libs/pango

				streaming? ( x11-libs/libva )
				trayicon? ( || (
					dev-libs/libappindicator:2
					dev-libs/libappindicator2
					) )
				pulseaudio? ( media-sound/pulseaudio[caps] )
				!pulseaudio? ( media-sound/apulse )
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

	if ! use pulseaudio; then
		ewarn "You have disabled pulseaudio which is not supported."
		ewarn "You have to use media-sound/apulse instead to start"
		ewarn "steam. Please add '/usr/lib32/apulse' to your"
		ewarn "LD_LIBRARY_PATH environment variable or start steam"
		ewarn "with:"
		ewarn "# LD_LIBRARY_PATH=/usr/lib32/apulse steam"
		ewarn ""
	fi

	ewarn "The steam client and the games are not controlled by"
	ewarn "portage. Updates are handled by the client itself."
}
