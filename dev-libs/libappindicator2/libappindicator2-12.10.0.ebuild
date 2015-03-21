# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils autotools multilib-minimal

AYATANA_VALA_VERSION=0.16

MY_PN=${PN/libappindicator2/libappindicator}
MY_P=${P/libappindicator2/libappindicator}

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="http://launchpad.net/libappindicator"
SRC_URI="http://launchpad.net/${MY_PN}/${PV%.*}/${PV}/+download/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/dbus-glib-0.98[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.26[${MULTILIB_USEDEP}]
	dev-libs/libdbusmenu2[gtk,${MULTILIB_USEDEP}]
	dev-libs/libindicator2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.18:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}
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
	
	export PKG_CONFIG=pkg-config
	export PKG_CONFIG_PATH=/opt/steam-runtime/usr/$(get_libdir)/pkgconfig/
	
	GTK_SWITCH="--with-gtk=2"
	
	econf \
		--prefix=/opt/steam-runtime/ \
		--libdir=/opt/steam-runtime/usr/$(get_libdir) \
		--disable-silent-rules \
		--disable-static \
		--with-html-dir=/usr/share/doc/${PF}/html \
		--disable-introspection \
		${GTK_SWITCH}
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc AUTHORS ChangeLog
	prune_libtool_files
}
