# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AYATANA_VALA_VERSION=0.16

MY_PN=${PN/libdbusmenu2/libdbusmenu}
MY_P=${P/libdbusmenu2/libdbusmenu}

inherit eutils flag-o-matic multilib-minimal

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="http://launchpad.net/dbusmenu"
SRC_URI="http://launchpad.net/${MY_PN/lib}/${PV%.*}/${PV}/+download/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gtk"

RDEPEND=">=dev-libs/glib-2.32[${MULTILIB_USEDEP}]
	>=dev-libs/dbus-glib-0.100[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	gtk? ( >=x11-libs/gtk+-2.18:2[${MULTILIB_USEDEP}] )
	"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}
ECONF_SOURCE=${S}

src_prepare() {
	epatch "${FILESDIR}/${PN}-signal-fix.patch"
}

multilib_src_configure() {
	append-flags -Wno-error #414323
	
	export PKG_CONFIG=pkg-config
	export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/share/pkgconfig/:/usr/$(get_libdir)/pkgconfig/

	GTK_SWITCH="--with-gtk=2"
	
	# dumper extra tool is only for GTK+-2.x, tests use valgrind which is stupid
	econf \
		--prefix=/opt/steam-runtime/ \
		--libdir=/opt/steam-runtime/usr/$(get_libdir) \
		--docdir=/usr/share/doc/${PF} \
		--disable-static \
		--disable-silent-rules \
		--disable-scrollkeeper \
		$(use_enable gtk) \
		--disable-dumper \
		--disable-tests \
		--disable-introspection \
		--disable-vala \
		$(use_enable debug massivedebugging) \
		--with-html-dir=/usr/share/doc/${PF}/html \
		${GTK_SWITCH}
}

multilib_src_test() { :; } #440192

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc AUTHORS ChangeLog README

	local a b
	for a in ${PN}-{glib,gtk}; do
		b=/usr/share/doc/${PF}/html/${a}
		[[ -d ${ED}/${b} ]] && dosym ${b} /usr/share/gtk-doc/html/${a}
	done

	prune_libtool_files
}
