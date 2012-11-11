# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils unpacker

DESCRIPTION="Installer for Valve's native Steam client"
HOMEPAGE="https://steampowered.com"
SRC_URI="http://media.steampowered.com/client/installer/steam.deb"
LICENSE="ValveSteamLicense"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND=" amd64? (
			>=app-emulation/emul-linux-x86-baselibs-20121028
			>=app-emulation/emul-linux-x86-xlibs-20121028
			>=sys-devel/gcc-4.6.0[multilib]
			>=sys-libs/glibc-2.15[multilib]
			)
		x86? (
			>=sys-devel/gcc-4.6.0
			>=sys-libs/glibc-2.15
			>=x11-libs/libX11-1.5
			x11-libs/libXau
			x11-libs/libxcb
			x11-libs/libXdmcp
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
	einfo ""
	einfo "To pull in the dependencies for the steam client, emerge:"
	einfo "game-utils/steam-client-meta"

	ewarn "The steam client and the games are not controlled by"
	ewarn "portage. Updates are handled by the client itself."
}
