# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Steam games"
HOMEPAGE="http://steampowered.com"
LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="s3tc mono +steamruntime"

# add USE_EXPAND="${USE_EXPAND} STEAMGAMES" to your make.conf for proper
# display of steamgames use flags
IUSE_STEAMGAMES="bioshock_infinite defenders_quest dirt_rally dirt_showdown dwarfs hammerwatch ironclad_tactics journey_down
	narcissu painkiller portal shadow_mordor shatter source_engine tf2 trine2 unwritten_tales voidexpanse witcher2
        dont_starve"

for sgame in ${IUSE_STEAMGAMES}; do
	IUSE="${IUSE} steamgames_${sgame}"
done

IUSE_VIDEOCARDS="intel fglrx nouveau nvidia radeon"
for scard in ${IUSE_VIDEOCARDS}; do
	IUSE="${IUSE} video_cards_${scard}"
done

RDEPEND="
		amd64? (
			video_cards_fglrx? ( x11-drivers/ati-drivers[abi_x86_32] )
			video_cards_nvidia? ( x11-drivers/nvidia-drivers[multilib] )
			)
		mono? (
			dev-lang/mono
			)
		s3tc? (
			media-libs/mesa[-bindist]
			media-libs/libtxc_dxtn[abi_x86_32]
			)

		steamgames_bioshock_infinite? (
			!steamruntime? ( media-libs/sdl2-image[abi_x86_32] )
			)
		steamgames_defenders_quest? (
			dev-util/adobe-air-runtime
			)
		steamgames_dirt_rally? (
			media-libs/sdl-image
			media-libs/sdl-ttf
			)
		steamgames_dont_starve? (
			!steamruntime? ( net-libs/libcurl-debian[abi_x86_32] )
			)
		steamgames_dwarfs? (
			media-libs/libexif[abi_x86_32]
		)
		steamgames_ironclad_tactics? (
			media-libs/sdl2-mixer[abi_x86_32]
			)
		steamgames_journey_down? (
			media-libs/openal[abi_x86_32]
			)
		steamgames_narcissu? (
			media-libs/sdl2-image[abi_x86_32]
			media-libs/sdl2-mixer[abi_x86_32]
			)
		steamgames_painkiller? (
			!steamruntime? ( media-libs/glew:1.6[abi_x86_32] )
			)
		steamgames_shadow_mordor? (
			!steamruntime? ( net-libs/libcurl-debian )
			)
		steamgames_shatter? (
			media-gfx/nvidia-cg-toolkit[abi_x86_32]
			)
		steamgames_source_engine? (
			video_cards_fglrx? ( >=x11-drivers/ati-drivers-12.8 )
			media-libs/libpng:1.2[abi_x86_32]
			dev-libs/libgcrypt:11/11[abi_x86_32]
			)
		steamgames_trine2? (
			x11-apps/xwininfo
			!steamruntime? (
				media-gfx/nvidia-cg-toolkit[abi_x86_32]
				media-libs/libogg[abi_x86_32]
				media-libs/libvorbis[abi_x86_32]
				x11-libs/libXxf86vm[abi_x86_32]
				)
			)
		steamgames_unwritten_tales? (
			media-libs/jasper[abi_x86_32]
			media-libs/jpeg:8[abi_x86_32]
			)
		steamgames_witcher2? (
			!steamruntime? ( media-libs/libsdl2[haptic] )
			)
		"
REQUIRED_USE="
		steamgames_hammerwatch? ( mono )
		steamgames_dirt_showdown? ( s3tc )
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
