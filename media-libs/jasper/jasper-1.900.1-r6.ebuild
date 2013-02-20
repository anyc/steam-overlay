# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools-multilib

DESCRIPTION="software-based implementation of the codec specified in the JPEG-2000 Part-1 standard"
HOMEPAGE="http://www.ece.uvic.ca/~mdadams/jasper/"
SRC_URI="http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-${PV}.zip
	mirror://gentoo/${P}-fixes-20120611.patch.bz2"

LICENSE="JasPer2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="jpeg opengl static-libs"

RDEPEND="jpeg? (
		virtual/jpeg
		amd64? (
			abi_x86_32? ( app-emulation/emul-linux-x86-baselibs )
			)
		)
	opengl? (
		amd64? (
                        abi_x86_32? ( app-emulation/emul-linux-x86-opengl )
                        )
		virtual/opengl media-libs/freeglut
		)"
DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=(
	"${WORKDIR}/${P}-fixes-20120611.patch"
	)

DOCS=( NEWS README doc/. )

src_configure() {
	local myeconfargs=(
		$(use_enable jpeg libjpeg)
		$(use_enable opengl)
		$(use_enable static-libs static)
		--enable-shared
		)
	autotools-multilib_src_configure
}
