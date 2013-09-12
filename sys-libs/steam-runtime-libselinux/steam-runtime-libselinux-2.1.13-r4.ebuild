# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libselinux/libselinux-2.1.13-r4.ebuild,v 1.4 2013/09/05 19:44:50 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_2 )

inherit multilib python-r1 toolchain-funcs eutils multilib-minimal

SEPOL_VER="2.1.9"
SR_DIR="/opt/steam-runtime/"

MY_P=${P/steam-runtime-/}
MY_PN=${PN/steam-runtime-/}

DESCRIPTION="SELinux userland library"
HOMEPAGE="http://userspace.selinuxproject.org"
SRC_URI="http://userspace.selinuxproject.org/releases/20130423/${MY_P}.tar.gz
	http://dev.gentoo.org/~swift/patches/${MY_PN}/patchbundle-${MY_P}-r3.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=">=sys-libs/steam-runtime-libsepol-${SEPOL_VER}[${MULTILIB_USEDEP}]
	>=dev-libs/libpcre-8.30-r2[static-libs?]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_unpack() {
	default
}

src_prepare() {
	# fix up paths for multilib
	sed -i \
		-e "/^LIBDIR/s/lib/$(get_libdir)/" \
		-e "/^SHLIBDIR/s/lib/$(get_libdir)/" \
		src/Makefile utils/Makefile || die

	EPATCH_MULTI_MSG="Applying libselinux patches ... " \
	EPATCH_SUFFIX="patch" \
	EPATCH_SOURCE="${WORKDIR}/gentoo-patches" \
	EPATCH_FORCE="yes" \
	epatch

	epatch_user

	multilib_copy_sources
}

multilib_src_compile() {
	export PKG_CONFIG_PATH=${SR_DIR}/usr/$(get_libdir)/pkgconfig/:${PKG_CONFIG_PATH}

	tc-export RANLIB
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CFLAGS="$(pkg-config --cflags libsepol)" \
		LDFLAGS="-fPIC $($(tc-getPKG_CONFIG) libpcre --libs) ${LDFLAGS} -lpthread" all || die
}

multilib_src_install() {
        insinto "${SR_DIR}/usr/$(get_libdir)/"
        doins src/libselinux.so.1
        ln -s libselinux.so.1 ${D}/${SR_DIR}/usr/$(get_libdir)/libselinux.so || die
}
