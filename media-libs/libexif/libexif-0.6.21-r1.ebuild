# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=5
inherit autotools-multilib

DESCRIPTION="Library for parsing, editing, and saving EXIF data"
HOMEPAGE="http://libexif.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc nls static-libs"

RDEPEND="
		nls? ( virtual/libintl )
		amd64? (
				abi_x86_32? ( app-emulation/emul-linux-x86-baselibs )
				)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.6.13-pkgconfig.patch
	sed -i -e '/FLAGS=/s:-g::' configure || die #390249
	
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable nls)
		$(use_enable doc docs)
		--with-doc-dir="${EPREFIX}"/usr/share/doc/${PF}
		)
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install
	
	rm -f "${ED}"/usr/share/doc/${PF}/{ABOUT-NLS,COPYING}
}
