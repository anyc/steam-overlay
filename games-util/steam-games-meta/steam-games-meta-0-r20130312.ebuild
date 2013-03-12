# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Steam games"
HOMEPAGE="http://steampowered.com"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="s3tc testdeps video_cards_intel video_cards_fglrx video_cards_nouveau
	video_cards_nvidia video_cards_radeon"

# add USE_EXPAND="${USE_EXPAND} STEAMGAMES" to your make.conf for proper
# display of steamgames use flags
IUSE_STEAMGAMES="dwarfs unwritten_tales tf2 trine2 journey_down defenders_quest"

for sgame in ${IUSE_STEAMGAMES}; do
	IUSE="${IUSE} steamgames_${sgame}"
done

RDEPEND="
		s3tc? (
			amd64? ( || (
				>=media-libs/libtxc_dxtn-1.0.1-r1[abi_x86_32]
				<media-libs/libtxc_dxtn-1.0.1-r1[multilib]
				) )
			x86? ( media-libs/libtxc_dxtn )
			)
		testdeps? (
			dev-lang/mono
			x86? (
				dev-db/sqlite
				dev-games/ogre
				media-libs/freealut
				media-libs/freeglut
				media-libs/libtheora
				media-libs/libvorbis
				media-libs/openal
				media-libs/sdl-image
				media-libs/sdl-mixer
				media-libs/sdl-ttf
				media-libs/tiff
				net-dns/libidn
				net-misc/curl
				sys-apps/pciutils
				x11-libs/libXaw
				x11-libs/libXft
				x11-libs/libXmu
				x11-libs/libXxf86vm
				x11-misc/xclip

				video_cards_nvidia? ( media-gfx/nvidia-cg-toolkit )
				)
			)
		steamgames_dwarfs? (
				x86? ( media-libs/libexif )
				amd64? ( >=media-libs/libexif-0.6.21-r1[abi_x86_32] )
			)
		steamgames_unwritten_tales? (
				x86? ( media-libs/jasper )
				amd64? ( >=media-libs/jasper-1.900.1-r6[abi_x86_32] )
			)
		steamgames_tf2? (
				video_cards_fglrx? ( >=x11-drivers/ati-drivers-12.8 )
			)
		steamgames_journey_down? (
				x86? ( media-libs/openal )
			)
		steamgames_trine2? (
				x11-apps/xwininfo
			)
		steamgames_defenders_quest? (
				dev-util/adobe-air-runtime
			)
		"
REQUIRED_USE="
		steamgames_tf2? (
				video_cards_intel? ( s3tc )
				video_cards_radeon? ( s3tc )
				video_cards_nouveau? ( s3tc )
			)
		"

pkg_postinst() {
	if use x86; then
		elog "If a game does not start, please enable \"testdeps\" use-flag and"
		elog "check if it fixes the issue. Please report, if and which one of the"
		elog "dependencies is required for a game, so we can mark it accordingly."
	fi

	if use amd64; then
		elog "If a game does not start, please take a look at the dependencies"
		elog "for the x86 architecture in this ebuild. It might be required that"
		elog "you build them in a x86 chroot environment or using crossdev (see"
		elog "http://en.gentoo-wiki.com/wiki/Crossdev ). Please report, if and"
		elog "which one of the dependencies is required for a game, so we can"
		elog "request the inclusion in the emul-linux-x86* packages, see:"
		elog "https://bugs.gentoo.org/show_bug.cgi?id=446682"
	fi
	elog "Ebuild development website: https://github.com/anyc/steam-overlay"
	elog "If you have problems, please also see http://wiki.gentoo.org/wiki/Steam"
}
