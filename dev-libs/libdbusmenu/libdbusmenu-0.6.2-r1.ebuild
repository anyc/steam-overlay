# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AYATANA_VALA_VERSION=0.16

inherit eutils flag-o-matic multilib-minimal

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="http://launchpad.net/dbusmenu"
SRC_URI="http://launchpad.net/${PN/lib}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gtk gtk3 +introspection"

RDEPEND=">=dev-libs/glib-2.32
	>=dev-libs/dbus-glib-0.100
	dev-libs/libxml2
	gtk3? ( >=x11-libs/gtk+-3.2:3 )
	!gtk3? ( gtk? ( >=x11-libs/gtk+-2.18:2 ) )
	introspection? ( >=dev-libs/gobject-introspection-1[${MULTILIB_USEDEP}] )
	"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	virtual/pkgconfig
	introspection? ( dev-lang/vala:${AYATANA_VALA_VERSION}[vapigen] )"
REQUIRED_USE="gtk3? ( gtk )"

ECONF_SOURCE=${S}

multilib_src_configure() {
	append-flags -Wno-error #414323
	export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/share/pkgconfig/

	use introspection && export VALA_API_GEN="$(type -P vapigen-${AYATANA_VALA_VERSION})"
	use gtk3 && GTK_SWITCH="--with-gtk=3" || GTK_SWITCH="--with-gtk=2"
	
	# dumper extra tool is only for GTK+-2.x, tests use valgrind which is stupid
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-static \
		--disable-silent-rules \
		--disable-scrollkeeper \
		$(use_enable gtk) \
		--disable-dumper \
		--disable-tests \
		$(use_enable introspection) \
		$(use_enable introspection vala) \
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
