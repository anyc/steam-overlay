# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

inherit eutils gnome2-utils fdo-mime

DESCRIPTION="Installer, launcher and supplementary files for Valve's Steam client"
HOMEPAGE="http://steampowered.com"
SRC_URI="http://repo.steampowered.com/steam/pool/steam/s/steam/steam_${PV}.tar.gz"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="ValveSteamLicense"

RESTRICT="bindist mirror"
SLOT="0"
IUSE="+steamruntime"

RDEPEND="
		app-arch/xz-utils
		app-shells/bash
		net-misc/curl
		|| (
			>=gnome-extra/zenity-3
			x11-terms/xterm
			)

		amd64? (
			steamruntime? (
				>=app-emulation/emul-linux-x86-baselibs-20121028
				|| (
					>=app-emulation/emul-linux-x86-xlibs-20121028
					(
						x11-libs/libX11[abi_x86_32]
						x11-libs/libXau[abi_x86_32]
						x11-libs/libxcb[abi_x86_32]
						x11-libs/libXdmcp[abi_x86_32]
					)
				)
			)
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
	if ! use steamruntime; then
		# use system libraries if user has not set the variable otherwise
		sed -i -r "s/(export TEXTDOMAIN=steam)/\1\nif \[ -z \"\$STEAM_RUNTIME\" \]; then export STEAM_RUNTIME=0; fi/" steam || die
		# use violent force to load the system's SDL library
		sed -i '/export STEAM_RUNTIME=0; fi/a if \[ \"$STEAM_RUNTIME\" == "0" \]; then export LD_PRELOAD="/usr/lib32/libSDL2-2.0.so.0"; fi' steam || die
	fi

	# we use our ebuild functions to install the files
	rm Makefile
}

src_install() {
	dobin steam

	insinto /usr/lib/steam/
	doins bootstraplinux_ubuntu12_32.tar.xz

	local udevrulesdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)/rules.d"
	dodir ${udevrulesdir}
	insinto ${udevrulesdir}
	doins lib/udev/rules.d/99-steam-controller-perms.rules

	dodoc debian/changelog steam_install_agreement.txt
	doman steam.6

	domenu steam.desktop

	cd icons/
	for s in * ; do
		doicon -s ${s} ${s}/steam.png
	done

	# tgz archive contains no separate pixmap, see #38
	insinto /usr/share/pixmaps/
	newins 48/steam_tray_mono.png steam_tray_mono.png
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
		ewarn "libraries instead of Gentoo's system libraries."
		ewarn ""
	else
		elog "We disable STEAM_RUNTIME in order to ignore bundled libraries"
		elog "and use installed system libraries instead. If you have problems,"
		elog "try starting steam with: STEAM_RUNTIME=1 steam"
		ewarn ""
		ewarn "Notice: Valve only supports Steam with the runtime enabled!"
		ewarn ""
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
