# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Steam games"
HOMEPAGE="https://steampowered.com"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="s3tc testdeps video_cards_intel video_cards_fglrx"

# add USE_EXPAND="${USE_EXPAND} STEAMGAMES" to your make.conf for proper
# display of steamgames use flags
IUSE_STEAMGAMES="unwritten_tales tf2"

for sgame in ${IUSE_STEAMGAMES}; do
	IUSE="${IUSE} steamgames_${sgame}"
done

RDEPEND="
		s3tc? ( media-libs/libtxc_dxtn )
		testdeps? (
			dev-games/ogre
			dev-lang/mono
			media-libs/freealut
			media-libs/sdl-image
			media-libs/sdl-mixer
			media-libs/sdl-ttf
			media-libs/tiff
			net-misc/curl
			sys-apps/pciutils
			x11-misc/xclip
			)
		steamgames_unwritten_tales? ( media-libs/jasper )
		steamgames_tf2? (
				video_cards_fglrx? ( >=x11-drivers/ati-drivers-12.8 )
			)
		"

pkg_postinst() {
	elog "If a game does not start, please enable \"testdeps\" use-flag and"
	elog "check if it fixes the issue. Please report, if and which one of the"
	elog "dependencies is required for a game, so we can mark it accordingly."
	elog "Development website: https://github.com/anyc/steam-overlay"

	if use video_cards_intel && ! use s3tc; then
		elog "You have video_cards_intel enabled. You might want to enable"
		elog "s3tc use-flag in order to play certain games which rely on this"
		elog "texture compression."
	fi
}
