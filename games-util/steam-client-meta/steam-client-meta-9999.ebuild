# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Valve's native Steam client"
HOMEPAGE="https://steampowered.com"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="flash video_cards_intel windows-games"

RDEPEND="
		virtual/opengl

		|| ( media-fonts/font-bitstream-100dpi media-fonts/font-adobe-100dpi )

		windows-games? ( app-emulation/wine )

		amd64? (
			>=sys-devel/gcc-4.6.0[multilib]
			>=sys-libs/glibc-2.15[multilib]

			flash? ( www-plugins/adobe-flash[32bit] )
			video_cards_intel? (
				>=app-emulation/emul-linux-x86-baselibs-20121202
				>=app-emulation/emul-linux-x86-gtklibs-20121202
				>=app-emulation/emul-linux-x86-opengl-20121202
				>=app-emulation/emul-linux-x86-sdl-20121202
				>=app-emulation/emul-linux-x86-soundlibs-20121202
				>=app-emulation/emul-linux-x86-xlibs-20121202
				)
			!video_cards_intel? (
				>=app-emulation/emul-linux-x86-baselibs-20121028
				>=app-emulation/emul-linux-x86-gtklibs-20121028
				>=app-emulation/emul-linux-x86-opengl-20121028
				>=app-emulation/emul-linux-x86-sdl-20121028
				>=app-emulation/emul-linux-x86-soundlibs-20121028
				>=app-emulation/emul-linux-x86-xlibs-20121028
				)
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
			media-libs/libsdl
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

			flash? ( www-plugins/adobe-flash )
			video_cards_intel? ( >=media-libs/mesa-9 )
			)"

pkg_postinst() {
	einfo "This is only a meta package that pulls in the required"
	einfo "dependencies for the steam client."

	if use windows-games; then
		einfo ""
		einfo "To start games automatically with wine, follow"
		einfo "https://wiki.archlinux.org/index.php/Wine#Using_Wine_as_an_interpreter_for_Win16.2FWin32_binaries"
	fi

	if use flash; then
		einfo ""
		einfo "In order to use flash, link the 32bit libflashplayer.so to"
		einfo "\${STEAM_FOLDER}/ubuntu12_32/plugins/"
	fi

	ewarn "The steam client and the games are not controlled by"
	ewarn "portage. Updates are handled by the client itself."
}
