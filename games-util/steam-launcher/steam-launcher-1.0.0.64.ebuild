# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

inherit linux-info prefix udev xdg-utils

DESCRIPTION="Installer, launcher and supplementary files for Valve's Steam client"
HOMEPAGE="https://steampowered.com"
SRC_URI="https://repo-steampowered-com.steamos.cloud/steam/pool/steam/s/steam/steam_${PV}.tar.gz"

LICENSE="ValveSteamLicense MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+steamruntime"
RESTRICT="bindist mirror test"

RDEPEND="
		app-arch/tar
		app-shells/bash
		net-misc/curl
		|| (
			>=gnome-extra/zenity-3
			x11-terms/xterm
			)

		steamruntime? (
			virtual/opengl[abi_x86_32]
			x11-libs/libX11[abi_x86_32]
			x11-libs/libXau[abi_x86_32]
			x11-libs/libxcb[abi_x86_32]
			x11-libs/libXdmcp[abi_x86_32]
			)
		!steamruntime? (
			>=games-util/steam-client-meta-0-r20190331[steamruntime?]
			)

		amd64? (
			>=sys-devel/gcc-4.6.0[multilib]
			>=sys-libs/glibc-2.15[multilib]
			)
		x86? (
			>=sys-devel/gcc-4.6.0
			>=sys-libs/glibc-2.15
			)"

S="${WORKDIR}/${PN}"

pkg_setup() {
	linux-info_pkg_setup

	if ! { linux_config_exists && linux_chkconfig_present INPUT_UINPUT; }; then
		ewarn "If you want to use the Steam controller, please make sure"
		ewarn "CONFIG_INPUT_UINPUT is enabled in your kernel config."

		# Device Drivers
		#  -> Input device support
		#   -> Miscellaneous devices
		#    -> User level driver support
	fi
}

path_entries() {
	local multilib=${1}
	shift

	while true; do
		echo -n ${EPREFIX}/usr/$(get_libdir)/${1}$(${multilib} && use amd64 && echo :${EPREFIX}/usr/$(ABI=x86 get_libdir)/${1})
		shift

		if [[ -n ${1} ]]; then
			echo -n :
		else
			break
		fi
	done
}

native_path_entries() { path_entries false "${@}"; }
multilib_path_entries() { path_entries true "${@}"; }

src_prepare() {
	xdg_environment_reset
	default

	sed -i 's:TAG+="uaccess":\0, TAG+="udev-acl":g' \
		subprojects/steam-devices/*.rules || die

	sed \
		-e "s#@@PVR@@#${PVR}#g" \
		-e "s#@@GENTOO_LD_LIBRARY_PATH@@#$(multilib_path_entries debiancompat fltk)#g" \
		-e "s#@@STEAM_RUNTIME@@#$(usex steamruntime 1 0)#g" \
		"${FILESDIR}"/steam-wrapper.sh > steam-wrapper.sh || die

	# Still need EPREFIX in the sed replacements above because the
	# regular expression used by hprefixify doesn't match there.
	hprefixify bin_steam.sh steam-wrapper.sh
}

src_install() {
	emake install-{icons,bootstrap,desktop} \
		  DESTDIR="${D}" PREFIX="${EPREFIX}/usr"

	newbin steam-wrapper.sh steam
	exeinto /usr/lib/steam
	doexe bin_steam.sh

	dodoc README debian/changelog
	doman steam.6

	udev_dorules subprojects/steam-devices/60-steam-{input,vr}.rules
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	udev_reload

	elog "Execute ${EPREFIX}/usr/bin/steam to download and install the actual"
	elog "client into your home folder. After installation, the script"
	elog "also starts the client from your home folder."
	elog ""

	if use steamruntime; then
		ewarn "You enabled the Steam runtime environment. Steam will use bundled"
		ewarn "libraries instead of Gentoo's system libraries."
		ewarn ""
	else
		elog "We disable STEAM_RUNTIME in order to ignore bundled libraries"
		elog "and use installed system libraries instead. If you have problems,"
		elog "try starting Steam with: STEAM_RUNTIME=1 steam"
		ewarn ""
		ewarn "Notice: Valve only supports Steam with the runtime enabled!"
		ewarn ""
	fi

	if ! has_version "gnome-extra/zenity"; then
		ewarn "Valve does not provide a xterm fallback for all calls of zenity."
		ewarn "Please install gnome-extra/zenity for full support."
		ewarn ""
	fi

	ewarn "The Steam client and the games are _not_ controlled by Portage."
	ewarn "Updates are handled by the client itself."
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
