# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

inherit desktop linux-info prefix toolchain-funcs udev xdg-utils

DESCRIPTION="Installer, launcher and supplementary files for Valve's Steam client"
HOMEPAGE="http://steampowered.com"
SRC_URI="http://repo.steampowered.com/steam/pool/steam/s/steam/steam_${PV}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="ValveSteamLicense"

RESTRICT="bindist mirror"
SLOT="0"
IUSE="+steamruntime"

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

S=${WORKDIR}/steam/

PATCHES=(
	"${FILESDIR}"/steam-runtime-default.patch
	"${FILESDIR}"/steam-set-distrib-release.patch
	"${FILESDIR}"/steam-fix-joystick-detection.patch
	"${FILESDIR}"/steam-libraries.patch
	"${FILESDIR}"/steam-libappindicator.patch
)

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
		lib/udev/rules.d/60-steam-input.rules || die

	sed -i \
		-e "s#@@GENTOO_LD_LIBRARY_PATH@@#$(multilib_path_entries debiancompat fltk)#g" \
		-e "s#@@GENTOO_LD_PRELOAD@@#$(native_path_entries libsteam-preload.so)#g" \
		-e "s#@@STEAM_RUNTIME@@#$(usex steamruntime 1 0)#g" \
		steam || die

	# use steam launcher version as release number as it is a bit more helpful than the baselayout version
	sed -i -e "s,export DISTRIB_RELEASE=\"2.2\",export DISTRIB_RELEASE=\"${PVR}\"," steam || die

	# Still need EPREFIX in the sed replacements above because the
	# regular expression used by hprefixify doesn't match there.
	hprefixify steam
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -fPIC -DGLIBDIR="${EPREFIX}/usr/$(get_libdir)" -shared \
				"${FILESDIR}"/libsteam-preload.c -ldl -Wl,-soname=libsteam-preload.so -o libsteam-preload.so || die
}

src_install() {
	dobin steam
	dolib.so libsteam-preload.so

	insinto /usr/lib/steam/
	doins bootstraplinux_ubuntu12_32.tar.xz

	udev_dorules lib/udev/rules.d/60-steam-input.rules lib/udev/rules.d/60-steam-vr.rules

	dodoc debian/changelog steam_subscriber_agreement.txt
	doman steam.6

	domenu steam.desktop

	cd icons/ || die
	for s in * ; do
		doicon -s ${s} ${s}/steam.png
	done

	# tgz archive contains no separate pixmap, see #38
	doicon 48/steam_tray_mono.png
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
		elog ""
		elog "To get the systray to appear,"
		elog "please run steam with: 'STEAM_RUNTIME=1 steam' at least once."
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
