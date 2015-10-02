# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Valve's Steam environment"
HOMEPAGE="https://steampowered.com"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+steamruntime"

RDEPEND="
		games-util/steam-launcher[steamruntime?]
		games-util/steam-client-meta[steamruntime?]
		games-util/steam-games-meta[steamruntime?]
		"
