# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils autotools multilib-minimal

AYATANA_VALA_VERSION=0.16

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="http://launchpad.net/libappindicator"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection gtk3"

RDEPEND=">=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.26
	=dev-libs/libdbusmenu-0.6.2-r1[gtk3=,gtk,${MULTILIB_USEDEP}]
	=dev-libs/libindicator-12.10.0-r1[gtk3=,${MULTILIB_USEDEP}]
	gtk3? ( >=x11-libs/gtk+-3.2:3 )
	!gtk3? ( >=x11-libs/gtk+-2.18:2 )
	introspection? ( >=dev-libs/gobject-introspection-1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	introspection? ( dev-lang/vala:${AYATANA_VALA_VERSION}[vapigen] )"

ECONF_SOURCE=${S}

src_prepare() {
	epatch ${FILESDIR}/multilib_disable_python.patch
	sed -i "s/.*python.*/\\\/" bindings/Makefile.am || die "Bindings patch failed"
	sed -i "s/ python //" bindings/Makefile.in || die "Bindings patch failed"
	eautoreconf
	
	# Disable MONO for now because of http://bugs.gentoo.org/382491
	sed -i -e '/^MONO_REQUIRED_VERSION/s:=.*:=9999:' configure || die
}

multilib_src_configure() {
	# http://bugs.gentoo.org/409133
	export APPINDICATOR_PYTHON_CFLAGS=' '
	export APPINDICATOR_PYTHON_LIBS=' '
	
	use introspection && export VALAC="$(type -P valac-${AYATANA_VALA_VERSION})"
	
	use gtk3 && GTK_SWITCH="--with-gtk=3" || GTK_SWITCH="--with-gtk=2"
	
	econf \
		--disable-silent-rules \
		--disable-static \
		--with-html-dir=/usr/share/doc/${PF}/html \
		$(use_enable introspection) \
		${GTK_SWITCH}
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc AUTHORS ChangeLog
	prune_libtool_files
}
