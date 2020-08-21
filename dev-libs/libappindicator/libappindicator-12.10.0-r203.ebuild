# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal xdg-utils

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="https://launchpad.net/libappindicator"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/dbus-glib-0.98[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.26:2[${MULTILIB_USEDEP}]
	>=dev-libs/libdbusmenu-0.6.2[gtk,${MULTILIB_USEDEP}]
	>=dev-libs/libindicator-12.10.0:0[${MULTILIB_USEDEP}]
	x11-libs/gtk+:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-conditional-py-bindings.patch
)

src_prepare() {
	default

	# Don't use -Werror
	sed -i 's/ -Werror//' {src,tests}/Makefile.{am,in} || die

	xdg_environment_reset
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-introspection \
		--disable-python \
		--disable-static \
		--with-gtk=2
}

multilib_src_compile() {
	emake -j1 -C src #638782
}

multilib_src_install() {
	emake -j1 -C src DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name "*.la" -delete || die
}
