# Copyright 1999-2014 Gentoo Foundation
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
KEYWORDS="~amd64 ~x86"
IUSE="s3tc mono +steamruntime"

# add USE_EXPAND="${USE_EXPAND} STEAMGAMES" to your make.conf for proper
# display of steamgames use flags
IUSE_STEAMGAMES="dwarfs unwritten_tales tf2 trine2 journey_down defenders_quest
	shatter hammerwatch source_engine painkiller narcissu witcher2"

for sgame in ${IUSE_STEAMGAMES}; do
	IUSE="${IUSE} steamgames_${sgame}"
done

IUSE_VIDEOCARDS="intel fglrx nouveau nvidia radeon"
for scard in ${IUSE_VIDEOCARDS}; do
	IUSE="${IUSE} video_cards_${scard}"
done

RDEPEND="
		amd64? (
			video_cards_fglrx? ( x11-drivers/ati-drivers[multilib] )
			video_cards_nvidia? ( x11-drivers/nvidia-drivers[multilib] )
			)
		mono? (
			dev-lang/mono
			)
		s3tc? (
			amd64? ( || (
					>=media-libs/libtxc_dxtn-1.0.1-r1[abi_x86_32]
					<media-libs/libtxc_dxtn-1.0.1-r1[multilib]
					)
				)
			x86? ( media-libs/libtxc_dxtn )
			)

		steamgames_dwarfs? (
				x86? ( media-libs/libexif )
				amd64? ( >=media-libs/libexif-0.6.21-r1[abi_x86_32] )
			)
		steamgames_unwritten_tales? (
				x86? ( media-libs/jasper )
				amd64? ( >=media-libs/jasper-1.900.1-r6[abi_x86_32] )
			)
		steamgames_source_engine? (
				video_cards_fglrx? ( >=x11-drivers/ati-drivers-12.8 )
			)
		steamgames_journey_down? (
				amd64? ( media-libs/openal[abi_x86_32] )
				x86? ( media-libs/openal )
			)
		steamgames_narcissu? (
				amd64? (
					media-libs/sdl2-image[abi_x86_32]
					media-libs/sdl2-mixer[abi_x86_32]
					)
				x86? (
					media-libs/sdl2-image
					media-libs/sdl2-mixer
					)
			)
		steamgames_painkiller? (
			!steamruntime? (
					amd64? ( media-libs/steam-runtime-glew[abi_x86_32] )
					x86? ( media-libs/steam-runtime-glew )
				)
			)
		steamgames_trine2? (
				x11-apps/xwininfo
				!steamruntime? (
					x86? (
						media-gfx/nvidia-cg-toolkit
						media-libs/libogg
						media-libs/libvorbis
						x11-libs/libXxf86vm
						)
					amd64? (
						>=media-gfx/nvidia-cg-toolkit-3.1.0013[multilib]
						media-libs/libogg[abi_x86_32]
						media-libs/libvorbis[abi_x86_32]
						x11-libs/libXxf86vm[abi_x86_32]
						)
				)
			)
		steamgames_defenders_quest? (
				dev-util/adobe-air-runtime
			)
		steamgames_shatter? (
				amd64? ( >=media-gfx/nvidia-cg-toolkit-3.1.0013[multilib] )
				x86? ( media-gfx/nvidia-cg-toolkit )
			)
		steamgames_witcher2? (
				!steamruntime? ( media-libs/libsdl2[haptic] )
			)
		"
REQUIRED_USE="
		steamgames_tf2? ( steamgames_source_engine )
		steamgames_source_engine? (
				video_cards_intel? ( s3tc )
				video_cards_radeon? ( s3tc )
				video_cards_nouveau? ( s3tc )
			)
		steamgames_hammerwatch? ( mono )
		"

S=${WORKDIR}

pkg_postinst() {
	if use x86; then
		elog "If a game does not start, please enable \"testdeps\" use-flag and"
		elog "check if it fixes the issue. Please report, if and which one of the"
		elog "dependencies is required for a game, so we can mark it accordingly."
		elog ""
	fi

	if use amd64; then
		elog "If a game does not start, please take a look at the dependencies"
		elog "for the x86 architecture in this ebuild. It might be required that"
		elog "we create a multilib ebuild for x86. Please report, if and which"
		elog "one of the dependencies is required for a game, so we can mark it"
		elog "accordingly."
		elog ""
	fi
	elog "Ebuild development website: http://github.com/anyc/steam-overlay"
	elog ""
	elog "If you have problems, please also see http://wiki.gentoo.org/wiki/Steam"
}
