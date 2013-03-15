# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic virtualx multilib-minimal

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="http://launchpad.net/libindicator"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="test gtk3"

RDEPEND=">=dev-libs/glib-2.22
	gtk3? ( >=x11-libs/gtk+-3.2:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/dbus-test-runner )
	amd64? (
		x11-proto/kbproto[abi_x86_32?]
		x11-proto/xproto[abi_x86_32?]
		)
	"

ECONF_SOURCE=${S}

multilib_src_configure() {
	append-flags -Wno-error
	
	use gtk3 && GTK_SWITCH="--with-gtk=3" || GTK_SWITCH="--with-gtk=2"
	
	econf \
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
