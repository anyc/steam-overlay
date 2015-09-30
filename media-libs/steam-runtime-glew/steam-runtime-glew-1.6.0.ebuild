# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# ebuild based on version 1.10.0-r2

EAPI=5
inherit multilib multilib-minimal toolchain-funcs versionator

MY_PN=glew
MY_P=${MY_PN}-${PV}

DESCRIPTION="The OpenGL Extension Wrangler Library"
HOMEPAGE="http://glew.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tgz"

LICENSE="BSD MIT"
SLOT="0/$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="virtual/glu[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
	x11-libs/libXmu[${MULTILIB_USEDEP}]
	abi_x86_32? ( !app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)] )"
DEPEND=${RDEPEND}

S=${WORKDIR}/${MY_P}

DOCS=""
SR_DIR="/opt/steam-runtime/"

src_prepare() {
	sed -i \
		-e '/INSTALL/s:-s::' \
		-e '/$(CC) $(CFLAGS) -o/s:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' \
		-e '/^.PHONY: .*\.pc$/d' \
		Makefile || die

	if ! use static-libs ; then
		sed -i \
			-e '/glew.lib:/s|lib/$(LIB.STATIC) ||' \
			-e '/glew.lib.mx:/s|lib/$(LIB.STATIC.MX) ||' \
			-e '/INSTALL.*LIB.STATIC/d' \
			Makefile || die
	fi

	# don't do stupid Solaris specific stuff that won't work in Prefix
	cp config/Makefile.linux config/Makefile.solaris || die
	# and let freebsd be built as on linux too
	cp config/Makefile.linux config/Makefile.freebsd || die

	multilib_copy_sources
}

set_opts() {
	myglewopts=(
		AR="$(tc-getAR)"
		STRIP=true
		CC="$(tc-getCC)"
		LD="$(tc-getCC) ${LDFLAGS}"
		M_ARCH=""
		LDFLAGS.EXTRA=""
		POPT="${CFLAGS}"
	)
}

multilib_src_compile() {
	set_opts
	emake GLEW_DEST="${EPREFIX}/${SR_DIR}/usr" LIBDIR="${EPREFIX}/${SR_DIR}/usr/$(get_libdir)" "${myglewopts[@]}"
}

multilib_src_install() {
	set_opts
	emake \
		GLEW_DEST="${ED}/${SR_DIR}/usr" \
		LIBDIR="${ED}/${SR_DIR}/usr/$(get_libdir)" \
		"${myglewopts[@]}" \
		install.all
}
