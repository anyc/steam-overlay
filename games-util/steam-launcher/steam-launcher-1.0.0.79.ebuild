# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-games in Libera Chat IRC

inherit desktop linux-info pax-utils prefix xdg

DESCRIPTION="Installer, launcher and supplementary files for Valve's Steam client"
HOMEPAGE="https://store.steampowered.com"
SRC_URI="https://repo.steampowered.com/steam/archive/stable/steam_${PV}.tar.gz"

LICENSE="ValveSteamLicense MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+desktop-portal +dialogs +joystick +pulseaudio +steamruntime steamvr trayicon +udev video_cards_nvidia wayland"
RESTRICT="bindist mirror test"

# This can help to determine the dependencies:
# find ~/.steam/root/ -exec readelf -d {} + 2>/dev/null | grep -F NEEDED | sort -u | grep -F -v -f <(ls -1 ~/.steam/root/ubuntu12_32/)

RDEPEND="
	app-arch/tar
	app-arch/xz-utils
	app-shells/bash
	media-libs/fontconfig[abi_x86_32]
	sys-libs/libudev-compat[abi_x86_32]
	sys-process/lsof
	virtual/opengl[abi_x86_32]
	virtual/ttf-fonts
	!x11-misc/virtualgl[-abi_x86_32]

	steamruntime? (
		!sys-apps/dbus[abi_x86_32,-X]
		!x11-libs/cairo[abi_x86_32,-X]
	)

	!steamruntime? (
		>=app-accessibility/at-spi2-core-2.46.0:2[abi_x86_32]
		app-arch/bzip2[abi_x86_32]
		app-i18n/ibus
		dev-libs/dbus-glib[abi_x86_32]
		dev-libs/expat[abi_x86_32]
		dev-libs/glib:2[abi_x86_32]
		dev-libs/nspr[abi_x86_32]
		dev-libs/nss[abi_x86_32]
		media-libs/alsa-lib[abi_x86_32]
		media-libs/freetype[abi_x86_32]
		media-libs/libpng-compat:1.2
		media-libs/libva:0/2[abi_x86_32]
		media-libs/openal[abi_x86_32]
		media-video/pipewire:0/0.4[abi_x86_32]
		net-misc/curl[abi_x86_32]
		net-misc/networkmanager[abi_x86_32]
		net-print/cups
		sys-apps/dbus[abi_x86_32,X]
		sys-libs/zlib[abi_x86_32]
		virtual/libusb[abi_x86_32]
		x11-libs/gdk-pixbuf[abi_x86_32]
		x11-libs/gtk+:2[abi_x86_32]
		x11-libs/libICE[abi_x86_32]
		x11-libs/libSM[abi_x86_32]
		x11-libs/libvdpau[abi_x86_32]
		x11-libs/libX11[abi_x86_32]
		x11-libs/libXcomposite[abi_x86_32]
		x11-libs/libXcursor[abi_x86_32]
		x11-libs/libXdamage[abi_x86_32]
		x11-libs/libXext[abi_x86_32]
		x11-libs/libXfixes[abi_x86_32]
		x11-libs/libXi[abi_x86_32]
		x11-libs/libXinerama[abi_x86_32]
		x11-libs/libXrandr[abi_x86_32]
		x11-libs/libXrender[abi_x86_32]
		x11-libs/libXScrnSaver[abi_x86_32]
		x11-libs/libXtst[abi_x86_32]
		x11-libs/pango[abi_x86_32]

		dialogs? ( || (
			>=gnome-extra/zenity-3
			x11-terms/xterm
		) )

		trayicon? ( dev-libs/libappindicator:2[abi_x86_32] )
	)

	desktop-portal? ( sys-apps/xdg-desktop-portal )
	pulseaudio? ( media-libs/libpulse[abi_x86_32] )
	!pulseaudio? ( media-sound/apulse[abi_x86_32] )
	!steamruntime? ( games-util/esteam )
	steamvr? ( sys-apps/usbutils )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers[abi_x86_32] )

	joystick? (
		udev? ( games-util/game-device-udev-rules )
		wayland? ( || (
			x11-libs/extest[abi_x86_32]
			>=x11-base/xwayland-23.2.1[libei(+)]
		) )
	)

	amd64? (
		>=sys-devel/gcc-4.6.0[multilib]
		>=sys-libs/glibc-2.15[multilib]
	)

	x86? (
		>=sys-devel/gcc-4.6.0
		>=sys-libs/glibc-2.15
	)
"

S="${WORKDIR}/${PN}"

pkg_setup() {
	linux-info_pkg_setup

	if ! { linux_config_exists && linux_chkconfig_present INPUT_UINPUT; }; then
		ewarn "If you want to use Steam Input's virtual controller"
		ewarn "implementation, please make sure CONFIG_INPUT_UINPUT"
		ewarn "is enabled in your kernel config."

		# Device Drivers
		#  -> Input device support
		#   -> Miscellaneous devices
		#    -> User level driver support
	fi
}

lib_path_entries() {
	while true; do
		echo -n ${EPREFIX}/usr/\\\\\${LIB}/${1}
		shift

		if [[ -n ${1} ]]; then
			echo -n :
		else
			break
		fi
	done
}

src_prepare() {
	default

	sed \
		-e "s#@@PVR@@#${PVR}#g" \
		-e "s#@@GENTOO_LD_LIBRARY_PATH@@#$(lib_path_entries debiancompat fltk)#g" \
		-e "s#@@GENTOO_X86_LIBDIR@@#${EPREFIX}/usr/$(ABI=x86 get_libdir)#g" \
		-e "s#@@STEAM_RUNTIME@@#$(usex steamruntime 1 0)#g" \
		"${FILESDIR}"/steam-wrapper.sh > steam-wrapper.sh || die

	# Still need EPREFIX in the sed replacements above because the
	# regular expression used by hprefixify doesn't match there.
	hprefixify bin_steam.sh steam-wrapper.sh
}

src_install() {
	emake install-{icons,bootstrap} \
		  DESTDIR="${D}" PREFIX="${EPREFIX}/usr"

	newbin steam-wrapper.sh steam
	exeinto /usr/lib/steam
	doexe bin_steam.sh
	domenu steam.desktop

	dodoc README debian/changelog
	doman steam.6
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Execute ${EPREFIX}/usr/bin/steam to download and install the actual"
	elog "client into your home folder. After installation, the script"
	elog "also starts the client from your home folder."
	elog ""

	ewarn "The Steam client and the games are _not_ controlled by Portage."
	ewarn "Updates are handled by the client itself."
	ewarn ""

	if use steamruntime; then
		elog "You have enabled the Steam runtime environment by default."
		elog "Steam will use bundled libraries if they are missing from"
		elog "your Gentoo system. Try disabling the runtime with the"
		elog "steamruntime USE flag if you have issues."
		elog ""
	else
		elog "You have disabled the Steam runtime environment by default."
		elog "Steam will not use bundled libraries if they are missing from"
		elog "your Gentoo system. Use games-util/esteam to install addiitonal"
		elog "dependencies needed by your games. Try setting STEAM_RUNTIME=1"
		elog "to temporarily enable the runtime if you have issues."
		elog ""
		ewarn "Notice: Valve only supports Steam with the runtime enabled!"
		ewarn ""
	fi

	if ! use desktop-portal; then
		ewarn "You have disabled desktop-portal, which is not supported."
		ewarn "An xdg-desktop-portal backend is needed for file pickers"
		ewarn "and other desktop components to work, e.g. when adding a"
		ewarn "non-Steam game or a new library folder."
		ewarn ""
	fi

	if ! has_version "gnome-extra/zenity"; then
		ewarn "Valve does not provide a xterm fallback for all calls of zenity."
		ewarn "Please install gnome-extra/zenity for full support."
		ewarn ""
	fi

	if host-is-pax; then
		elog "If you're using PAX, please see:"
		elog "https://wiki.gentoo.org/wiki/Steam#Hardened_Gentoo"
		elog ""
	fi
}
