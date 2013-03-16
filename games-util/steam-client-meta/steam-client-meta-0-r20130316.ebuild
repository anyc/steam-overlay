# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Valve's native Steam client"
HOMEPAGE="http://steampowered.com"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="flash trayicon video_cards_intel"

RDEPEND="
		virtual/opengl

		media-fonts/font-mutt-misc
		|| ( media-fonts/font-bitstream-100dpi media-fonts/font-adobe-100dpi )

		amd64? (
			>=sys-devel/gcc-4.6.0[multilib]
			>=sys-libs/glibc-2.15[multilib]
			>=media-libs/libsdl-2.0.0_pre6964:2[abi_x86_32]

			>=app-emulation/emul-linux-x86-baselibs-20121202
			>=app-emulation/emul-linux-x86-gtklibs-20121202
			>=app-emulation/emul-linux-x86-opengl-20121202
			>=app-emulation/emul-linux-x86-sdl-20121202
			>=app-emulation/emul-linux-x86-soundlibs-20121202
			|| (
				>=app-emulation/emul-linux-x86-xlibs-20121202
				(
					x11-libs/libX11[abi_x86_32]
					x11-libs/libXcomposite[abi_x86_32]
					x11-libs/libXcursor[abi_x86_32]
					x11-libs/libXdamage[abi_x86_32]
					x11-libs/libXext[abi_x86_32]
					x11-libs/libXfixes[abi_x86_32]
					media-libs/fontconfig[abi_x86_32]
					media-libs/freetype[abi_x86_32]
					x11-libs/libXi[abi_x86_32]
					x11-libs/libXinerama[abi_x86_32]
					x11-libs/libXrandr[abi_x86_32]
					x11-libs/libXrender[abi_x86_32]
				)
			)

			trayicon? ( >=dev-libs/libappindicator-12.10.0-r1[-gtk3,abi_x86_32] )

			flash? ( www-plugins/adobe-flash[32bit] )
			)
		x86? (
			dev-libs/glib:2
			dev-libs/libgcrypt
			dev-libs/nspr
			dev-libs/nss
			media-libs/alsa-lib
			media-libs/fontconfig
			media-libs/freetype:2
			media-libs/libjpeg-turbo
			media-libs/libogg
			media-libs/libpng:1.2
			>=media-libs/libsdl-2.0.0_pre6964
			media-libs/libtheora
			media-libs/libvorbis
			media-libs/openal
			media-sound/pulseaudio
			net-misc/curl
			net-print/cups
			sys-apps/dbus
			>=sys-devel/gcc-4.6.0
			>=sys-libs/glibc-2.15
			>=sys-libs/zlib-1.2.4
			x11-libs/cairo
			x11-libs/gdk-pixbuf
			x11-libs/gtk+:2
			>=x11-libs/libX11-1.5
			x11-libs/libXext
			x11-libs/libXfixes
			x11-libs/libXi
			x11-libs/libXrandr
			x11-libs/libXrender
			x11-libs/pango
			>=x11-libs/pixman-0.24.4

			trayicon? ( =dev-libs/libappindicator-12.10.0-r1[-gtk3] )
			flash? ( www-plugins/adobe-flash )
			video_cards_intel? ( >=media-libs/mesa-9 )
			)"

pkg_postinst() {
	elog "This is only a meta package that pulls in the required"
	elog "dependencies for the steam client."

	if use flash; then
		elog ""
		elog "In order to use flash, link the 32bit libflashplayer.so to"
		elog "\${STEAM_FOLDER}/ubuntu12_32/plugins/"
	fi

	ewarn "The steam client and the games are not controlled by"
	ewarn "portage. Updates are handled by the client itself."
}
