# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libsepol/libsepol-2.1.9-r3.ebuild,v 1.1 2013/08/23 07:26:05 swift Exp $

EAPI="4"

inherit multilib toolchain-funcs eutils multilib-minimal

MY_P=${P/steam-runtime-/}
MY_PN=${PN/steam-runtime-/}

DESCRIPTION="SELinux binary policy representation library"
HOMEPAGE="http://userspace.selinuxproject.org"
SRC_URI="http://userspace.selinuxproject.org/releases/20130423/${MY_P}.tar.gz
	http://dev.gentoo.org/~swift/patches/${MY_PN}/patchbundle-${MY_P}-r1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

# tests are not meant to be run outside of the
# full SELinux userland repo
RESTRICT="test"

S=${WORKDIR}/${MY_P}

src_prepare() {
	EPATCH_MULTI_MSG="Applying libsepol patches ... " \
	EPATCH_SUFFIX="patch" \
	EPATCH_SOURCE="${WORKDIR}/gentoo-patches" \
	EPATCH_FORCE="yes" \
	epatch

	epatch_user
	multilib_copy_sources
}

multilib_src_compile() {
	local SR_DIR="/opt/steam-runtime/"
	
	tc-export RANLIB;
	LIBDIR="\$(PREFIX)/$(get_libdir)" SHLIBDIR="\$(DESTDIR)/$(get_libdir)" \
		emake AR="$(tc-getAR)" CC="$(tc-getCC)" PREFIX="${SR_DIR}/usr/" INCLUDEDIR="${SR_DIR}/usr/include/"
}

multilib_src_install() {
	local SR_DIR="/opt/steam-runtime/"

#	insinto "${SR_DIR}/usr/$(get_libdir)/"
#	doins src/libsepol.so.1
#	ln -s libsepol.so.1 ${D}/${SR_DIR}/usr/$(get_libdir)/libsepol.so || die

	LIBDIR="\$(PREFIX)/$(get_libdir)" SHLIBDIR="\$(DESTDIR)/$(get_libdir)" \
                emake DESTDIR="${D}/${SR_DIR}" install
}
