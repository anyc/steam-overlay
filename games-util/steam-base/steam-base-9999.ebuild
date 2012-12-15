# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

inherit eutils unpacker

DESCRIPTION="Supplementary files for Valve's Steam client for Linux"
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

	if [[ "${PV}" != "9999" ]] ; then
		# disable ubuntu-specific package installation and use $TERM instead
		# of "xterm"
		epatch "${FILESDIR}/usr_bin_steam.patch"
	fi
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
	elog "Execute /usr/bin/steam to download and install the actual"
	elog "client into your home folder. After installation, the script"
	elog "also starts the client from your home folder."

	ewarn "The steam client and the games are _not_ controlled by portage."
	ewarn "Updates are handled by the client itself."
}
