# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pax-utils

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-games in Libera Chat IRC

DESCRIPTION="Meta package for Valve's native Steam client"
HOMEPAGE="http://steampowered.com"
LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pulseaudio steamfonts +steamruntime steamvr trayicon video_cards_intel video_cards_nvidia"

# This can help to determine the dependencies:
# find ~/.steam/root/ -exec readelf -d {} + 2>/dev/null | grep Shared | sort -u | fgrep -v -f <(ls -1 ~/.steam/root/ubuntu12_32/)

RDEPEND="
		media-fonts/font-mutt-misc
		|| ( media-fonts/font-bitstream-100dpi media-fonts/font-adobe-100dpi )

		virtual/opengl[abi_x86_32]

		trayicon? ( sys-apps/dbus )
		steamfonts? ( media-fonts/steamfonts )
		steamvr? ( sys-apps/usbutils )

		amd64? (
			!media-libs/mesa[-abi_x86_32]
			!x11-misc/virtualgl[-abi_x86_32]
			video_cards_nvidia? ( x11-drivers/nvidia-drivers[abi_x86_32,multilib(+)] )
			)

		x86? (
			video_cards_intel? ( >=media-libs/mesa-9 )
			)

		!steamruntime? (
			app-arch/bzip2[abi_x86_32]
			dev-libs/atk[abi_x86_32]
			dev-libs/dbus-glib[abi_x86_32]
			dev-libs/expat[abi_x86_32]
			dev-libs/glib:2[abi_x86_32]
			dev-libs/nspr[abi_x86_32]
			dev-libs/nss[abi_x86_32]
			media-libs/alsa-lib[abi_x86_32]
			media-libs/fontconfig[abi_x86_32]
			media-libs/freetype[abi_x86_32]
			media-libs/libpng-compat:1.2[abi_x86_32]
			media-libs/openal[abi_x86_32]
			media-video/pipewire:0/0.3[abi_x86_32]
			net-misc/curl[abi_x86_32]
			net-misc/networkmanager[abi_x86_32]
			net-print/cups[abi_x86_32]
			sys-apps/dbus[abi_x86_32,X]
			sys-libs/libudev-compat[abi_x86_32]
			sys-libs/zlib[abi_x86_32]
			virtual/libusb[abi_x86_32]
			x11-libs/gdk-pixbuf[abi_x86_32]
			x11-libs/gtk+:2[abi_x86_32,cups]
			x11-libs/libICE[abi_x86_32]
			x11-libs/libSM[abi_x86_32]
			x11-libs/libva-compat:1[abi_x86_32]
			x11-libs/libvdpau[abi_x86_32]
			x11-libs/libX11[abi_x86_32]
			x11-libs/libXScrnSaver[abi_x86_32]
			x11-libs/libXcomposite[abi_x86_32]
			x11-libs/libXcursor[abi_x86_32]
			x11-libs/libXdamage[abi_x86_32]
			x11-libs/libXext[abi_x86_32]
			x11-libs/libXfixes[abi_x86_32]
			x11-libs/libXi[abi_x86_32]
			x11-libs/libXinerama[abi_x86_32]
			x11-libs/libXrandr[abi_x86_32]
			x11-libs/libXrender[abi_x86_32]
			x11-libs/libXtst[abi_x86_32]
			x11-libs/pango[abi_x86_32]

			trayicon? ( dev-libs/libappindicator:2[abi_x86_32] )
			pulseaudio? ( media-sound/pulseaudio[abi_x86_32,caps] )
			!pulseaudio? ( media-sound/apulse[abi_x86_32] )

			amd64? (
				>=sys-devel/gcc-4.6.0[multilib]
				>=sys-libs/glibc-2.15[multilib]
				)

			x86? (
				>=sys-devel/gcc-4.6.0
				>=sys-libs/glibc-2.15
				)
			)
		"

pkg_postinst() {
	elog "This is only a meta package that pulls in the required"
	elog "dependencies for the steam client."
	elog ""

	if host-is-pax; then
		elog "If you're using PAX, please see:"
		elog "https://wiki.gentoo.org/wiki/Steam#Hardened_Gentoo"
		elog ""
	fi

	if ! use steamfonts; then
		elog "If the Steam client shows no or misaligned text, then"
		elog "please enable the steamfonts use flag."
		elog ""
	fi

	if ! use pulseaudio; then
		ewarn "You have disabled pulseaudio which is not supported."
		ewarn "If you are experiencing sound problems, you can try if"
		ewarn "media-sound/apulse works for you."
		ewarn ""
	fi

	ewarn "The steam client and the games are not controlled by"
	ewarn "portage. Updates are handled by the client itself."
}
