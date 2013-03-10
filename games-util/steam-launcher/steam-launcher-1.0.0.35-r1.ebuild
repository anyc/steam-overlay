# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

inherit eutils gnome2-utils fdo-mime

DESCRIPTION="Supplementary files for Valve's Steam client for Linux"
HOMEPAGE="http://steampowered.com"

if [[ "${PV}" == "9999" ]] ; then
	SRC_URI="http://repo.steampowered.com/steam/archive/precise/steam_latest.deb"
	KEYWORDS=""
else
	SRC_URI="http://repo.steampowered.com/steam/archive/precise/steam_${PV}.tar.gz"
	KEYWORDS="-* ~amd64 ~x86"
fi

LICENSE="ValveSteamLicense"

RESTRICT="bindist mirror"
SLOT="0"
IUSE="-steamruntime"

RDEPEND="
		app-arch/xz-utils
		app-shells/bash
		net-misc/curl
		|| (
			gnome-extra/zenity
			x11-terms/xterm
			)

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

S=${WORKDIR}/steam/

src_prepare() {
	if [[ "${PV}" != "9999" ]] ; then
		if ! use steamruntime; then
			# use system libraries
			sed -i -r 's/#(if \[ -z "\$STEAM_RUNTIME" \]; then)/\1/' steam
			sed -i -r "s/#	STEAM_RUNTIME=1/ export STEAM_RUNTIME=0/" steam
			sed -i -r "s/#(fi)/\1/" steam
		fi

		# we use our ebuild functions to install the files
		rm Makefile
	fi
}

src_install() {
	dobin steam

	insinto /usr/lib/steam/
	doins bootstraplinux_ubuntu12_32.tar.xz

	dodoc debian/changelog steam_install_agreement.txt
	doman steam.6

	domenu steam.desktop

	cd icons/
	for s in * ; do
		doicon -s ${s} ${s}/steam.png
	done
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

	if use steamruntime; then
		ewarn "You enabled the steam runtime environment. Steam will use bundled"
		ewarn "libraries instead of system libraries which is _not_ supported."
		ewarn ""
	else
		elog "We disable STEAM_RUNTIME in order to ignore bundled libraries"
		elog "and use installed system libraries instead. If you have problems,"
		elog "try starting steam with: STEAM_RUNTIME=1 steam"
		elog ""
	fi

	if ! has_version "gnome-extra/zenity"; then
		ewarn "Valve does not provide a xterm fallback for all calls of zenity."
		ewarn "Please install gnome-extra/zenity for full support."
		ewarn ""
	fi

	ewarn "The steam client and the games are _not_ controlled by portage."
	ewarn "Updates are handled by the client itself."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
