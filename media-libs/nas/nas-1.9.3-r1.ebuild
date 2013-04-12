# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs multilib-minimal

DESCRIPTION="Network Audio System"
HOMEPAGE="http://radscan.com/nas.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.tar.gz"

LICENSE="HPND MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc static-libs"

RDEPEND="x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXau[${MULTILIB_USEDEP}]
	x11-libs/libXaw[${MULTILIB_USEDEP}]
	x11-libs/libXp[${MULTILIB_USEDEP}]
	x11-libs/libXres
	x11-libs/libXt[${MULTILIB_USEDEP}]
	x11-libs/libXTrap"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/gccmakedep
	x11-misc/imake
	x11-proto/xproto[${MULTILIB_USEDEP}]"

ECONF_SOURCE=${S}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.9.2-asneeded.patch \
		"${FILESDIR}"/${PN}-1.9.2-implicit-inet_ntoa-amd64.patch

	multilib_copy_sources
}

multilib_src_compile() {
	# multilib fails without setting CC
	CC="$(tc-getCC)" xmkmf -a || die

	# EXTRA_LDOPTIONS, SHLIBGLOBALSFLAGS #336564#c2
	local emakeopts=(
		AR="$(tc-getAR) clq"
		AS="$(tc-getAS)"
		CC="$(tc-getCC)"
		CDEBUGFLAGS="${CFLAGS}"
		CXX="$(tc-getCXX)"
		CXXDEBUFLAGS="${CXXFLAGS}"
		EXTRA_LDOPTIONS="${LDFLAGS}"
		LD="$(tc-getLD)"
		MAKE="${MAKE:-gmake}"
		RANLIB="$(tc-getRANLIB)"
		SHLIBGLOBALSFLAGS="${LDFLAGS}"
		)

	# dumb fix for parallel make issue wrt #446598, Imake sux
	emake "${emakeopts[@]}" -C server/dia all || die
	emake "${emakeopts[@]}" -C server/dda/voxware all || die
	emake "${emakeopts[@]}" -C server/os all || die

	emake "${emakeopts[@]}" World || die
}

multilib_src_install() {
	# ranlib is used at install phase too wrt #446600
	emake RANLIB="$(tc-getRANLIB)" DESTDIR="${D}" install install.man || die
}

multilib_src_install_all() {
	dodoc BUILDNOTES FAQ HISTORY README RELEASE TODO

	if use doc; then
		docinto doc
		dodoc doc/{actions,protocol.txt,README}
		docinto pdf
		dodoc doc/pdf/*.pdf
	fi

	mv -vf "${D}"/etc/nas/nasd.conf{.eg,} || die

	newconfd "${FILESDIR}"/nas.conf.d nas || die
	newinitd "${FILESDIR}"/nas.init.d nas || die

	use static-libs || rm -f "${D}"/usr/lib*/libaudio.a

	[[ -e ${D}/usr/bin/nasd ]] || \
		die "Missing nasd executable in the destination directory. Exiting." #314631
}
