# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.7"
PYTHON_USE_WITH="xml"

inherit gnome2 python toolchain-funcs autotools multilib-minimal

DESCRIPTION="Introspection infrastructure for generating gobject library bindings for various languages"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="doc doctool test"

RDEPEND=">=dev-libs/gobject-introspection-common-${PV}
	>=dev-libs/glib-2.31.22:2
	<dev-libs/glib-2.33:2
	doctool? ( dev-python/mako )
	virtual/libffi"
# Wants real bison, not virtual/yacc
DEPEND="${RDEPEND}
	x11-proto/xproto[abi_x86_32?]
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex
	doc? ( >=dev-util/gtk-doc-1.15 )"
# PDEPEND to avoid circular dependencies, bug #391213
PDEPEND="x11-libs/cairo[glib]"

# TODO, see https://github.com/anyc/steam-overlay/issues/47
REQUIRED_USE="amd64? ( abi_x86_32? ( !doctool ) )"

pkg_setup() {
	# To prevent crosscompiling problems, bug #414105
	CC=$(tc-getCC)

	DOCS="AUTHORS CONTRIBUTORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		YACC=$(type -p yacc)
		$(use_enable doctool)
		$(use_enable test tests)"

	python_set_active_version 2
	python_pkg_setup
}

disable_python_for_x86() {
	# x86 build on AMD64 fails due to missing 32bit python. We just remove the
	# Python parts and those that depend on it as they are not required.
	
	if use amd64 && [ "$ABI" == "x86" ]; then
		cd ${BUILD_DIR}
		
		# disable configure checks
		epatch ${FILESDIR}/disable_python.patch
		
		# disable python bindings
		sed -i "s/include Makefile-giscanner.am//" Makefile.am || die "sed failed"
		
		# disable stuff that doesn't get installed anyways
		sed -i "s/include Makefile-tools.am//" Makefile.am || die "sed failed"
		sed -i "s/include Makefile-gir.am//" Makefile.am || die "sed failed"
		
		# disable tests
		sed -i "s/SUBDIRS = . docs tests/SUBDIRS = . docs/" Makefile.am || die "sed failed"
		eautoreconf
	fi
}

src_prepare() {
	# FIXME: Parallel compilation failure with USE=doc
	use doc && MAKEOPTS="-j1"

	gnome2_src_prepare

	python_clean_py-compile_files

	# avoid GNU-isms
	sed -i -e 's/\(if test .* \)==/\1=/' configure || die

	gi_skip_tests=
	if ! has_version "x11-libs/cairo[glib]"; then
		# Bug #391213: enable cairo-gobject support even if it's not installed
		# We only PDEPEND on cairo to avoid circular dependencies
		export CAIRO_LIBS="-lcairo"
		export CAIRO_CFLAGS="-I${EPREFIX}/usr/include/cairo"
		export CAIRO_GOBJECT_LIBS="-lcairo-gobject"
		export CAIRO_GOBJECT_CFLAGS="-I${EPREFIX}/usr/include/cairo"
		if use test; then
			G2CONF="${G2CONF} --disable-tests"
			gi_skip_tests=yes
			ewarn "Tests will be skipped because x11-libs/cairo[glib] is not present"
			ewarn "on your system. Consider installing it to get tests to run."
		fi
	fi
	
	multilib_copy_sources
	multilib_foreach_abi disable_python_for_x86
}

multilib_src_test() {
	[[ -z ${gi_skip_tests} ]] && default
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	python_convert_shebangs 2 "${ED}"usr/bin/g-ir-{annotation-tool,scanner}
	use doctool && python_convert_shebangs 2 "${ED}"usr/bin/g-ir-doc-tool

	# Prevent collision with gobject-introspection-common
	rm -v "${ED}"usr/share/aclocal/introspection.m4 \
		"${ED}"usr/share/gobject-introspection-1.0/Makefile.introspection || die
	rmdir "${ED}"usr/share/aclocal || die
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}/giscanner
	python_need_rebuild
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${PN}/giscanner
}
