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
IUSE="+installer testdeps"

RDEPEND="
		games-util/steam-client-meta

		installer? ( games-util/steam-installer )
		testdeps? (
			media-libs/libtxc_dxtn
			sys-apps/pciutils
			media-libs/jasper
			)
		"

pkg_postinst() {
	einfo "This is a meta package that pulls in the dependencies"
	einfo "for the steam environment."
}
