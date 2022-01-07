# Copyright 2014-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Collection of fonts used by Valve's Steam client"
HOMEPAGE="https://support.steampowered.com/kb_article.php?ref=1974-YFKL-4947"
SRC_URI="https://support.steampowered.com/downloads/1974-YFKL-4947/SteamFonts.zip"

LICENSE="MSttfEULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"
FONT_S="${WORKDIR}"
FONT_SUFFIX="ttf TTF"
