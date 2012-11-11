# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils unpacker

DESCRIPTION="Installer for Valve's native Steam client"
HOMEPAGE="https://steampowered.com"
SRC_URI="http://media.steampowered.com/client/installer/steam.deb"
LICENSE="ValveSteamLicense"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="video_cards_intel"

RDEPEND="
		|| ( media-fonts/font-bitstream-100dpi media-fonts/font-adobe-100dpi )
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

S=${WORKDIR}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	# fix QA notice
	sed -r -i "s/^(MimeType=.*)/\1;/" usr/share/applications/steam.desktop
	sed -r -i "s/^(Actions=.*)/\1;/" usr/share/applications/steam.desktop

	epatch "${FILESDIR}/remove-ubuntu-specifics.patch"
}

src_install() {
	dobin "usr/bin/steam"

	insinto "/usr/lib/"
	doins -r usr/lib/steam

	dodoc usr/share/doc/steam/changelog.gz
	doman usr/share/man/man6/steam.6.gz

	insinto /usr/share/applications/
	doins usr/share/applications/steam.desktop

	insinto /usr/share/icons/
	doins -r usr/share/icons/

	doicon usr/share/pixmaps/steam.xpm
}

pkg_postinst() {
	einfo "This ebuild only installs the steam installer."
	einfo "Execute \"steam\" to install the actual client into"
	einfo "your home folder."

	ewarn "The steam client and the games are not controlled by"
	ewarn "portage. Updates are handled by the client itself."
}