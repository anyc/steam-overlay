# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib multilib-minimal

DESCRIPTION="Thai language support library"
HOMEPAGE="https://linux.thai.net/projects/libthai"
SRC_URI="https://linux.thai.net/pub/thailinux/software/libthai/libthai-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libdatrie[${MULTILIB_USEDEP}]"
DEPEND="${RDEPENDS}"

src_prepare() {
	default
	multilib_copy_sources
}
