# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Valve's Steam environment"
HOMEPAGE="https://steampowered.com"
LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+steamruntime"

RDEPEND="
		games-util/steam-launcher[steamruntime?]
		games-util/steam-client-meta[steamruntime?]
		steamruntime? (
			|| (
				games-util/steam-games-meta[steamruntime]
				games-util/esteam
			)
		)
		!steamruntime? (
			|| (
				games-util/esteam
				games-util/steam-games-meta[-steamruntime]
			)
		)
		"
