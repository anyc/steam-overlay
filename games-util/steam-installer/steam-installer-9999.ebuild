# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

inherit eutils unpacker

DESCRIPTION="Installer for Valve's native Steam client"
HOMEPAGE="https://steampowered.com"

if [[ "${PV}" == "9999" ]] ; then
	SRC_URI="http://repo.steampowered.com/steam/archive/precise/steam_latest.deb"
	KEYWORDS=""
else
	SRC_URI="http://repo.steampowered.com/steam/archive/precise/steam_${PV}_i386.deb"
	KEYWORDS="-* ~amd64 ~x86"
fi

LICENSE="ValveSteamLicense"

RESTRICT="bindist mirror"
SLOT="0"
IUSE=""

RDEPEND="
		gnome-extra/zenity

		amd64? (
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

	# disable ubuntu-specific package installation and use $TERM instead
	# of "xterm"
	epatch "${FILESDIR}/usr_bin_steam.patch"
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

	doicon usr/share/pixmaps/steam.png
}

pkg_postinst() {
	einfo "Execute /usr/bin/steam to install the actual client into"
	einfo "your home folder."
	einfo ""
	einfo "After installing the client, /usr/bin/steam is also used to start"
	einfo "the client. After unmerging the installer, you can start the client"
	einfo "by executing ~/Steam/steam.sh"
	einfo ""
	einfo "To pull in the dependencies for the steam client and games,"
	einfo "emerge: game-utils/steam-meta"

	ewarn "This ebuild _only_ provides the steam installer. The steam client"
	ewarn "and the games are _not_ controlled by portage. Updates are handled"
	ewarn "by the client itself."
}
