# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

inherit eutils unpacker gnome2-utils fdo-mime

DESCRIPTION="Supplementary files for Valve's Steam client for Linux"
HOMEPAGE="http://steampowered.com"

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
		app-shells/bash
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
	if [[ "${PV}" != "9999" ]] ; then
		# remove carriage return
		sed -i "s/\r//g" usr/share/applications/steam.desktop || die "Patching steam.desktop failed"

		# use system libraries
		epatch "${FILESDIR}/steam-base-1.0.0.25-disable_runtime.patch"
	fi
}

src_install() {
	dobin usr/bin/steam

	insinto /usr/lib/
	doins -r usr/lib/steam

	dodoc usr/share/doc/steam/changelog.gz
	doman usr/share/man/man6/steam.6.gz

	domenu usr/share/applications/steam.desktop

	insinto /usr/share/icons/
	doins -r usr/share/icons/

	doicon usr/share/pixmaps/steam.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	elog "Execute /usr/bin/steam to download and install the actual"
	elog "client into your home folder. After installation, the script"
	elog "also starts the client from your home folder."
	elog ""
	elog "We disable STEAM_RUNTIME in order to ignore packaged libraries"
	elog "and use installed system libraries instead. If you have problems,"
	elog "try starting steam with: STEAM_RUNTIME=1 steam"

	ewarn "The steam client and the games are _not_ controlled by portage."
	ewarn "Updates are handled by the client itself."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
