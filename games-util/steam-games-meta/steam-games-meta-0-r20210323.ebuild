# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Steam games"
HOMEPAGE="https://steampowered.com"
LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mono +steamruntime video_cards_nvidia"

# add USE_EXPAND="${USE_EXPAND} STEAMGAMES" to your make.conf for proper
# display of steamgames use flags
IUSE_STEAMGAMES="bioshock_infinite defenders_quest dirt_rally dwarfs hammerwatch ironclad_tactics journey_down
	narcissu painkiller portal shadow_mordor shatter source_engine tf2 trine2 voidexpanse witcher2
	dont_starve te120"

for sgame in ${IUSE_STEAMGAMES}; do
	IUSE="${IUSE} steamgames_${sgame}"
done

RDEPEND="
		>=media-libs/mesa-17.3.9[-bindist(-)]

		amd64? (
			video_cards_nvidia? ( x11-drivers/nvidia-drivers[abi_x86_32,multilib(+)] )
			)
		mono? (
			dev-lang/mono
			)

		steamgames_bioshock_infinite? (
			!steamruntime? ( media-libs/sdl2-image[abi_x86_32] )
			)
		steamgames_defenders_quest? (
			dev-util/adobe-air-runtime
			)
		steamgames_dirt_rally? (
			media-libs/sdl2-image
			media-libs/sdl2-ttf
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
			media-libs/libpng-compat:1.2[abi_x86_32]
			dev-libs/libgcrypt:0/20[abi_x86_32]
			)
		steamgames_tf2? (
			!steamruntime? ( net-libs/libcurl-debian[abi_x86_32] )
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
		steamgames_witcher2? (
			!steamruntime? ( media-libs/libsdl2[haptic] )
			)
		"
REQUIRED_USE="
		steamgames_hammerwatch? ( mono )
		steamgames_portal? ( steamgames_source_engine )
		steamgames_te120? ( steamgames_source_engine )
		steamgames_tf2? ( steamgames_source_engine )
		steamgames_voidexpanse? ( mono )
		"

S="${WORKDIR}"

pkg_postinst() {
	elog "Please report bugs at: https://github.com/anyc/steam-overlay"
	elog ""
	elog "If you have problems, please also see:"
	elog "https://github.com/anyc/steam-overlay#troubleshooting-steam"
}
