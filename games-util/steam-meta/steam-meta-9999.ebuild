# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Meta package for Valve's Steam environment"
HOMEPAGE="https://steampowered.com"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+installer s3tc testdeps video_cards_intel"

RDEPEND="
		games-util/steam-client-meta

		installer? ( games-util/steam-installer )
		s3tc? ( media-libs/libtxc_dxtn )
		testdeps? (
			sys-apps/pciutils
			media-libs/jasper
			)
		"

pkg_postinst() {
	einfo "This is a meta package that pulls in the dependencies"
	einfo "for the steam environment."

	if use video_cards_intel && ! use s3tc; then
		elog "You have video_cards_intel enabled. You might want"
		elog "to enable s3tc use-flag in order to play certain games"
		elog "which rely on this texture compression."
	fi
}
