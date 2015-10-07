# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

MY_PN=openssl
MY_P=${MY_PN}-${PV}

inherit eutils flag-o-matic toolchain-funcs multilib multilib-minimal

REV="1.7"
DESCRIPTION="OpenSSL for Steam-based games"
HOMEPAGE="http://www.openssl.org/"
SRC_URI="mirror://openssl/source/${MY_P}.tar.gz
	http://cvs.pld-linux.org/cgi-bin/cvsweb.cgi/packages/${MY_PN}/${MY_PN}-c_rehash.sh?rev=${REV} -> ${MY_PN}-c_rehash.sh.${REV}"

LICENSE="openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bindist gmp kerberos rfc3779 cpu_flags_x86_sse2 static-libs test +tls-heartbeat vanilla zlib"
RESTRICT="!bindist? ( bindist )"

# The blocks are temporary just to make sure people upgrade to a
# version that lack runtime version checking.  We'll drop them in
# the future.
RDEPEND="gmp? ( >=dev-libs/gmp-5.1.3-r1[static-libs(+)?,${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[static-libs(+)?,${MULTILIB_USEDEP}] )
	kerberos? ( >=app-crypt/mit-krb5-1.11.4[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140406-r3
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
	!<net-misc/openssh-5.9_p1-r4
	!<net-libs/neon-0.29.6-r1"
DEPEND="${RDEPEND}
	sys-apps/diffutils
	>=dev-lang/perl-5
	test? ( sys-devel/bc )"
PDEPEND="app-misc/ca-certificates"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	SSL_CNF_DIR="/etc/ssl"
	sed \
		-e "/^DIR=/s:=.*:=${EPREFIX}${SSL_CNF_DIR}:" \
		-e "s:SSL_CMD=/usr:SSL_CMD=${EPREFIX}/usr:" \
		"${DISTDIR}"/${MY_PN}-c_rehash.sh.${REV} \
		> "${WORKDIR}"/c_rehash || die #416717
}

MULTILIB_WRAPPED_HEADERS=(
	usr/include/openssl/opensslconf.h
)

src_prepare() {
	# Make sure we only ever touch Makefile.org and avoid patching a file
	# that gets blown away anyways by the Configure script in src_configure
	rm -f Makefile

	if ! use vanilla ; then
		epatch "${FILESDIR}"/${MY_PN}-1.0.0a-ldflags.patch #327421
		epatch "${FILESDIR}"/${MY_PN}-1.0.0d-windres.patch #373743
		epatch "${FILESDIR}"/${MY_PN}-1.0.0h-pkg-config.patch
		epatch "${FILESDIR}"/${MY_PN}-1.0.1p-parallel-build.patch
		epatch "${FILESDIR}"/${MY_PN}-1.0.1m-x32.patch
		epatch "${FILESDIR}"/${MY_PN}-1.0.1m-ipv6.patch
		epatch "${FILESDIR}"/${MY_PN}-1.0.1f-revert-alpha-perl-generation.patch #499086
		epatch "${FILESDIR}"/${MY_PN}-1.0.1p-default-source.patch #554338
		epatch_user #332661
	fi

	# disable fips in the build
	# make sure the man pages are suffixed #302165
	# don't bother building man pages if they're disabled
	sed -i \
		-e '/DIRS/s: fips : :g' \
		-e '/^MANSUFFIX/s:=.*:=ssl:' \
		-e '/^MAKEDEPPROG/s:=.*:=$(CC):' \
		-e $(has noman FEATURES \
			&& echo '/^install:/s:install_docs::' \
			|| echo '/^MANDIR=/s:=.*:='${EPREFIX}'/usr/share/man:') \
		Makefile.org \
		|| die
	# show the actual commands in the log
	sed -i '/^SET_X/s:=.*:=set -x:' Makefile.shared

	# since we're forcing $(CC) as makedep anyway, just fix
	# the conditional as always-on
	# helps clang (#417795), and versioned gcc (#499818)
	sed -i 's/expr.*MAKEDEPEND.*;/true;/' util/domd || die

	# quiet out unknown driver argument warnings since openssl
	# doesn't have well-split CFLAGS and we're making it even worse
	# and 'make depend' uses -Werror for added fun (#417795 again)
	[[ ${CC} == *clang* ]] && append-flags -Qunused-arguments

	# allow openssl to be cross-compiled
	cp "${FILESDIR}"/gentoo.config-1.0.1 gentoo.config || die
	chmod a+rx gentoo.config

	append-flags -fno-strict-aliasing
	append-flags $(test-flags-CC -Wa,--noexecstack)

	sed -i '1s,^:$,#!'${EPREFIX}'/usr/bin/perl,' Configure #141906
	# The config script does stupid stuff to prompt the user.  Kill it.
	sed -i '/stty -icanon min 0 time 50; read waste/d' config || die
	./config --test-sanity || die "I AM NOT SANE"

	multilib_copy_sources
}

multilib_src_configure() {
	unset APPS #197996
	unset SCRIPTS #312551
	unset CROSS_COMPILE #311473

	tc-export CC AR RANLIB RC

	# Clean out patent-or-otherwise-encumbered code
	# Camellia: Royalty Free            http://en.wikipedia.org/wiki/Camellia_(cipher)
	# IDEA:     Expired                 http://en.wikipedia.org/wiki/International_Data_Encryption_Algorithm
	# EC:       ????????? ??/??/2015    http://en.wikipedia.org/wiki/Elliptic_Curve_Cryptography
	# MDC2:     Expired                 http://en.wikipedia.org/wiki/MDC-2
	# RC5:      5,724,428 03/03/2015    http://en.wikipedia.org/wiki/RC5

	use_ssl() { usex $1 "enable-${2:-$1}" "no-${2:-$1}" " ${*:3}" ; }
	echoit() { echo "$@" ; "$@" ; }

	local krb5=$(has_version app-crypt/mit-krb5 && echo "MIT" || echo "Heimdal")

	# See if our toolchain supports __uint128_t.  If so, it's 64bit
	# friendly and can use the nicely optimized code paths. #460790
	local ec_nistp_64_gcc_128
	# Disable it for now though #469976
	#if ! use bindist ; then
	#	echo "__uint128_t i;" > "${T}"/128.c
	#	if ${CC} ${CFLAGS} -c "${T}"/128.c -o /dev/null >&/dev/null ; then
	#		ec_nistp_64_gcc_128="enable-ec_nistp_64_gcc_128"
	#	fi
	#fi

	local sslout=$(./gentoo.config)
	einfo "Use configuration ${sslout:-(openssl knows best)}"
	local config="Configure"
	[[ -z ${sslout} ]] && config="config"

	echoit \
	./${config} \
		${sslout} \
		$(use cpu_flags_x86_sse2 || echo "no-sse2") \
		enable-camellia \
		$(use_ssl !bindist ec) \
		${ec_nistp_64_gcc_128} \
		enable-idea \
		enable-mdc2 \
		$(use_ssl !bindist rc5) \
		enable-tlsext \
		$(use_ssl gmp gmp -lgmp) \
		$(use_ssl kerberos krb5 --with-krb5-flavor=${krb5}) \
		$(use_ssl rfc3779) \
		$(use_ssl tls-heartbeat heartbeats) \
		$(use_ssl zlib) \
		--prefix="${EPREFIX}"/usr \
		--openssldir="${EPREFIX}"${SSL_CNF_DIR} \
		--libdir=$(get_libdir) \
		shared threads \
		|| die

	# Clean out hardcoded flags that openssl uses
	local CFLAG=$(grep ^CFLAG= Makefile | LC_ALL=C sed \
		-e 's:^CFLAG=::' \
		-e 's:-fomit-frame-pointer ::g' \
		-e 's:-O[0-9] ::g' \
		-e 's:-march=[-a-z0-9]* ::g' \
		-e 's:-mcpu=[-a-z0-9]* ::g' \
		-e 's:-m[a-z0-9]* ::g' \
	)
	sed -i \
		-e "/^CFLAG/s|=.*|=${CFLAG} ${CFLAGS}|" \
		-e "/^SHARED_LDFLAGS=/s|$| ${LDFLAGS}|" \
		Makefile || die
}

multilib_src_compile() {
	# depend is needed to use $confopts; it also doesn't matter
	# that it's -j1 as the code itself serializes subdirs
	emake -j1 depend
	emake all
	# rehash is needed to prep the certs/ dir; do this
	# separately to avoid parallel build issues.
	emake rehash
}

multilib_src_test() {
	emake -j1 test
}

multilib_src_install() {
	local SR_DIR="/opt/steam-runtime/"

	echo "${SR_DIR}/usr/$(get_libdir)/" >> 99-steam-runtime.conf
	insinto /etc/ld.so.conf.d/
	doins 99-steam-runtime.conf

	insinto "${SR_DIR}/usr/$(get_libdir)/"
	for f in "${BUILD_DIR}"/lib{ssl,crypt}*.so*; do
		doins "${f}"
	done
}
