# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib multilib-minimal

DESCRIPTION="Double-array trie library"
HOMEPAGE="https://linux.thai.net/projects/datrie"
SRC_URI="https://linux.thai.net/pub/thailinux/software/libthai/libdatrie-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	default
	multilib_copy_sources
}
