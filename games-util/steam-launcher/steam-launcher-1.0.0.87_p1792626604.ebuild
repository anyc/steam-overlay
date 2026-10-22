# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-games in Libera Chat IRC

inherit desktop linux-info prefix xdg

DESCRIPTION="Installer, launcher and supplementary files for Valve's Steam client"
HOMEPAGE="https://store.steampowered.com"

# emerge -u dev-python/{requests,vdf}
# python <<EOF | sort
# import requests, vdf
# platform = "steamrt64"
# req = requests.get(f"https://client-update.steamstatic.com/steam_client_publicbeta_{platform}")
# for k, v in vdf.loads(req.text)[platform].items():
# 	if (
# 		isinstance(v, dict) and
# 		k[-10:] == f"_{platform}" and
# 		k[0:-10] in ("bins_sdk", "bins", "runtime_steamrt", "steam", "steam_steamrt")
# 	):
# 		print("https://client-update.steamstatic.com/" + v['file'])
# EOF

SRC_URI="
	https://client-update.steamstatic.com/bins_sdk_steamrt64.zip.c82ce39cc507aa05036b8b3adf3faa71601677b7
	https://client-update.steamstatic.com/bins_steamrt64.zip.4f2d8fa70ba6a6c8702662b8e07e183a74715dc7
	https://client-update.steamstatic.com/runtime_steamrt_steamrt64.zip.50a00038c668b880bcfd470ffbb805df2f3521a7
	https://client-update.steamstatic.com/steam_steamrt64.zip.4475e8d914f6ccc1a9f8a065a41f5b1e8f943c75
	https://client-update.steamstatic.com/steam_steamrt_steamrt64.zip.78baaa4354cedff63d38b4eae692c140196afe7f
	https://repo.steampowered.com/steam/archive/stable/steam_${PV%_p*}.tar.gz
"
S="${WORKDIR}/${PN}"

LICENSE="ValveSteamLicense MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+desktop-portal +dialogs +joystick +pulseaudio steamvr trayicon +udev udisks video_cards_nvidia +vulkan wayland"
RESTRICT="bindist mirror test"

BDEPEND="
	app-arch/libarchive
	app-misc/pax-utils
"
RDEPEND="
	app-alternatives/tar
	app-arch/xz-utils
	app-shells/bash
	media-libs/fontconfig
	sys-apps/dbus
	sys-process/lsof
	virtual/libudev
	virtual/ttf-fonts

	desktop-portal? ( sys-apps/xdg-desktop-portal )
	pulseaudio? ( media-libs/libpulse )
	!pulseaudio? ( media-sound/apulse )
	steamvr? ( sys-apps/usbutils )
	udisks? ( sys-fs/udisks:2 )

	joystick? (
		udev? ( games-util/game-device-udev-rules )
		wayland? ( >=x11-base/xwayland-23.2.1[libei(+)] )
	)

	media-libs/libglvnd[abi_x86_32,X]
	sys-devel/gcc[multilib]
	sys-libs/glibc[multilib]
	vulkan? ( media-libs/vulkan-loader[abi_x86_32,wayland?,X] )

	!video_cards_nvidia? (
		media-libs/mesa[abi_x86_32,opengl,X]
	)
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers[abi_x86_32,X]
		vulkan? ( media-libs/vulkan-layers[abi_x86_32,wayland?,X] )
	)
"

PATCHES=(
	"${FILESDIR}"/apply-steam-non-gtar.patch
)

pkg_setup() {
	local CONFIG_CHECK="~IA32_EMULATION"
	local ERROR_IA32_EMULATION="CONFIG_IA32_EMULATION is still required for the 64-bit client."

	use joystick && CONFIG_CHECK+=" ~INPUT_UINPUT"
	local ERROR_INPUT_UINPUT="CONFIG_INPUT_UINPUT is required for virtual controller support."

	linux-info_pkg_setup
}

src_unpack() {
	unpack steam_${PV%_p*}.tar.gz
	mkdir -p "${S}"/bootstrap || die
	cd "${S}"/bootstrap || die

	local zip
	for zip in ${A}; do
		[[ ${zip} == *.zip.* ]] || continue
		echo ">>> Unpacking ${zip} to ${PWD}"
		# Valve's zip files have backslashes instead of forward slashes.
		bsdtar -cf - "@${DISTDIR}/${zip}" | gtar -xf - --xform='s:\\:/:g' || die
	done
}

src_prepare() {
	default

	sed "s#@@PVR@@#${PVR}#g" "${FILESDIR}"/steam-wrapper-r2.sh > steam-wrapper.sh || die
	hprefixify bin_steam.sh steam-wrapper.sh

	# Allow the desktop launcher to use wrappers from the PATH.
	sed -i "s:/usr/bin/::g" steam.desktop || die

	cd bootstrap || die

	# Reduce the size of the new bootstrap tarball.
	rm -r linux32/ ubuntu12_32/ ubuntu12_64/{fossilize_replay,steamwebhelper,streaming_client} || die

	# Some of Valve's zip files lack executable bits.
	scanelf -Rqi . | cut -d" " -f3 | xargs chmod a+x || die
	find -type f -exec awk '/^#!/ {print FILENAME} {nextfile}' {} + | xargs chmod a+x || die
}

src_compile() {
	cd bootstrap || die
	ebegin "Recreating bootstraplinux_ubuntu12_32.tar.xz for the 64-bit client"
	tar -Jcf "${S}"/bootstraplinux_ubuntu12_32.tar.xz * || die
	eend $?
}

src_install() {
	emake install-{appdata,bootstrap,icons} \
		  DESTDIR="${D}" PREFIX="${EPREFIX}/usr"

	newbin steam-wrapper.sh steam
	exeinto /usr/lib/steam
	doexe bin_steam.sh
	domenu steam.desktop

	insinto /usr/lib/steam
	doins "${FILESDIR}"/steam-non-gtar.patch

	dodoc README debian/changelog
	doman steam.6
}

pkg_postinst() {
	xdg_pkg_postinst
	echo

	elog "Execute ${EPREFIX}/usr/bin/steam to download and install the actual"
	elog "client into your home folder. After installation, the script also"
	elog "starts the client from your home folder."
	echo

	ewarn "The Steam client and the games are _not_ controlled by Portage."
	ewarn "Updates are handled by the client itself."
	echo

	if ! use desktop-portal; then
		ewarn "You have disabled desktop-portal, which is not supported. An"
		ewarn "xdg-desktop-portal backend is needed for file pickers and other desktop"
		ewarn "components to work, e.g. adding a non-Steam game or new library folder."
		echo
	fi

	if ! has_version "gnome-extra/zenity"; then
		ewarn "Valve does not provide a xterm fallback for all calls of zenity."
		ewarn "Please install gnome-extra/zenity for full support."
		echo
	fi
}
