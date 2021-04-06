# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

MY_P="nettle-${PV}"
DESCRIPTION="Low-level cryptographic library (6.2 ABI)"
HOMEPAGE="http://www.lysator.liu.se/~nisse/nettle/"
SRC_URI="mirror://gnu/nettle/${MY_P}.tar.gz"

LICENSE="|| ( LGPL-3 LGPL-2.1 )"
SLOT="6.2"
KEYWORDS="~amd64 ~x86"
IUSE="+gmp cpu_flags_x86_aes"
RESTRICT="test"

DEPEND="gmp? ( >=dev-libs/gmp-6.0:0=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
	!dev-libs/nettle:0/6.2"

S="${WORKDIR}/${MY_P}"

DOCS=()
HTML_DOCS=()

PATCHES=(
	"${FILESDIR}/${MY_P}-build.patch"
)

multilib_src_configure() {
	# --disable-openssl bug #427526
	ECONF_SOURCE="${S}" econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-documentation \
		--disable-fat \
		--disable-static \
		--disable-openssl \
		$(use_enable gmp public-key) \
		$(use_enable cpu_flags_x86_aes x86-aesni)
}

multilib_src_install() {
	emake DESTDIR="${D}" install-shared-{nettle,hogweed}
	rm "${ED}"/usr/$(get_libdir)/*.so || die
}
