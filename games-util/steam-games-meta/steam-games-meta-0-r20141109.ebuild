# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
IUSE_STEAMGAMES="bioshock_infinite defenders_quest dwarfs hammerwatch ironclad_tactics journey_down
	narcissu painkiller portal shatter source_engine tf2 trine2 unwritten_tales voidexpanse witcher2"

for sgame in ${IUSE_STEAMGAMES}; do
	IUSE="${IUSE} steamgames_${sgame}"
done

IUSE_VIDEOCARDS="intel fglrx nouveau nvidia radeon"
for scard in ${IUSE_VIDEOCARDS}; do
	IUSE="${IUSE} video_cards_${scard}"
done

RDEPEND="
		amd64? (
			video_cards_fglrx? ( || (
				<x11-drivers/ati-drivers-14.9-r1[multilib]
				>=x11-drivers/ati-drivers-14.9-r1[abi_x86_32]
				) )
			video_cards_nvidia? ( x11-drivers/nvidia-drivers[multilib] )
			)
		mono? (
			dev-lang/mono
			)
		s3tc? (
			media-libs/mesa[-bindist]
			amd64? ( || (
					>=media-libs/libtxc_dxtn-1.0.1-r1[abi_x86_32]
					<media-libs/libtxc_dxtn-1.0.1-r1[multilib]
					)
				)
			x86? ( media-libs/libtxc_dxtn )
			)

		steamgames_bioshock_infinite? (
			!steamruntime? (
					amd64? ( media-libs/sdl2-image[abi_x86_32] )
					x86? ( media-libs/sdl2-image )
				)
			)
		steamgames_defenders_quest? (
				dev-util/adobe-air-runtime
			)
		steamgames_dwarfs? (
				x86? ( media-libs/libexif )
				amd64? ( >=media-libs/libexif-0.6.21-r1[abi_x86_32] )
			)
		steamgames_ironclad_tactics? (
				amd64? (
					media-libs/sdl2-mixer[abi_x86_32]
					)
				x86? (
					media-libs/sdl2-mixer
					)
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
		steamgames_shatter? (
				amd64? ( >=media-gfx/nvidia-cg-toolkit-3.1.0013[multilib] )
				x86? ( media-gfx/nvidia-cg-toolkit )
			)
		steamgames_source_engine? (
				video_cards_fglrx? ( >=x11-drivers/ati-drivers-12.8 )
				amd64? ( media-libs/libpng:1.2[abi_x86_32] )
				x86? ( media-libs/libpng:1.2 )
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
		steamgames_unwritten_tales? (
				x86? (
					media-libs/jasper
					media-libs/jpeg:8
				)
				amd64? (
					>=media-libs/jasper-1.900.1-r6[abi_x86_32]
					media-libs/jpeg:8[abi_x86_32]
				)
			)
		steamgames_witcher2? (
				!steamruntime? ( media-libs/libsdl2[haptic] )
			)
		"
REQUIRED_USE="
		steamgames_hammerwatch? ( mono )
		steamgames_portal? ( steamgames_source_engine )
		steamgames_source_engine? (
				video_cards_intel? ( s3tc )
				video_cards_radeon? ( s3tc )
				video_cards_nouveau? ( s3tc )
			)
		steamgames_tf2? ( steamgames_source_engine )
		steamgames_voidexpanse? ( mono )
		"

S=${WORKDIR}

pkg_postinst() {
	elog "Please report bugs at: http://github.com/anyc/steam-overlay"
	elog ""
	elog "If you have problems, please also see:"
	elog "https://github.com/anyc/steam-overlay#troubleshooting-steam"
}
