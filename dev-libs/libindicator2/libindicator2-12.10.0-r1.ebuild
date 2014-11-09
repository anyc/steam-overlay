# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic virtualx multilib-minimal

MY_PN=${PN/libindicator2/libindicator}
MY_P=${P/libindicator2/libindicator}

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="http://launchpad.net/libindicator"
SRC_URI="http://launchpad.net/${MY_PN}/${PV%.*}/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-libs/glib-2.22[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.18:2[${MULTILIB_USEDEP}]
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/dbus-test-runner )
	x11-proto/kbproto[${MULTILIB_USEDEP}]
	x11-proto/xproto[${MULTILIB_USEDEP}]
	"

S=${WORKDIR}/${MY_P}
ECONF_SOURCE=${S}

src_prepare() {
	echo ${S}
	sed -i "s/80indicator-debugging//" "${S}"/tools/Makefile* || die
}

multilib_src_configure() {
	append-flags -Wno-error
	
	GTK_SWITCH="--with-gtk=2"
	
	econf \
		--prefix=/opt/steam-runtime/ \
		--libdir=/opt/steam-runtime/usr/$(get_libdir) \
		--disable-silent-rules \
		--disable-static \
		${GTK_SWITCH}
}

multilib_src_test() {
	Xemake check #391179
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc AUTHORS ChangeLog NEWS
	prune_libtool_files --all
}
