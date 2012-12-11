# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Meta package for Steam games"
HOMEPAGE="https://steampowered.com"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="s3tc testdeps video_cards_intel"

# add USE_EXPAND="${USE_EXPAND} STEAMGAMES" to your make.conf for proper
# display of steamgames use flags
IUSE_STEAMGAMES="unwritten_tales"

for sgame in ${IUSE_STEAMGAMES}; do
	IUSE="${IUSE} steamgames_${sgame}"
done

RDEPEND="
		s3tc? ( media-libs/libtxc_dxtn )
		testdeps? (
			dev-games/ogre
			media-libs/freealut
			media-libs/sdl-ttf
			media-libs/tiff
			net-misc/curl
			sys-apps/pciutils
			)
		steamgames_unwritten_tales? ( media-libs/jasper )
		"

pkg_postinst() {
	elog "If a game does not start, please enable \"testdeps\" use-flag and"
	elog "check if it fixes the issue. Please report, if and which one of the"
	elog "dependencies is required for a game, so we can mark it accordingly."

	if use video_cards_intel && ! use s3tc; then
		elog "You have video_cards_intel enabled. You might want to enable"
		elog "s3tc use-flag in order to play certain games which rely on this"
		elog "texture compression."
	fi
}
