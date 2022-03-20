# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for Valve's Steam environment"
HOMEPAGE="https://steampowered.com"
LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+steamruntime"

RDEPEND="
	games-util/steam-launcher[steamruntime?]
	games-util/steam-client-meta[steamruntime?]
	!steamruntime? ( games-util/esteam )
"
