# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils unpacker

DESCRIPTION="Meta package for Valve's native Steam client"
HOMEPAGE="https://steampowered.com"
SRC_URI=""
LICENSE="steam"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="video_cards_intel"

RDEPEND=" games-util/steam-installer
		virtual/opengl
		
		amd64? (
			>=app-emulation/emul-linux-x86-baselibs-20121028
			>=app-emulation/emul-linux-x86-gtklibs-20121028
			>=app-emulation/emul-linux-x86-opengl-20121028
			>=app-emulation/emul-linux-x86-sdl-20121028
			>=app-emulation/emul-linux-x86-soundlibs-20121028
			>=app-emulation/emul-linux-x86-xlibs-20121028
			>=sys-devel/gcc-4.6.0[multilib]
			>=sys-libs/glibc-2.15[multilib]
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

			video_cards_intel? ( >=media-libs/mesa-9 )
			)"

pkg_postinst() {
	einfo "This is only a meta package that pulls in the required"
	einfo "dependencies for the steam client."
	
	ewarn "The steam client and the games are not controlled by"
	ewarn "portage. Updates are handled by the client itself."
}

