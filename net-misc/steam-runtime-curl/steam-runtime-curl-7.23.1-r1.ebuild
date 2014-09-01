# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

WANT_AUTOMAKE=1.9.6

inherit autotools eutils prefix multilib-minimal

MY_PN=curl
MY_P=curl-${PV}

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="http://curl.haxx.se/"
SRC_URI="http://curl.haxx.se/download/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ares gnutls idn ipv6 kerberos ldap libssh2 nss ssl static-libs test threads"

RDEPEND="ldap? ( net-nds/openldap )
	gnutls? ( net-libs/gnutls dev-libs/libgcrypt app-misc/ca-certificates )
	ssl? ( !gnutls? ( dev-libs/openssl ) )
	nss? ( !gnutls? ( !ssl? ( dev-libs/nss app-misc/ca-certificates ) ) )
	idn? ( net-dns/libidn )
	ares? ( >=net-dns/c-ares-1.6 )
	kerberos? ( virtual/krb5 )
	libssh2? ( >=net-libs/libssh2-0.16 )"

# rtmpdump ( media-video/rtmpdump )  / --with-librtmp
# fbopenssl (not in gentoo) --with-spnego
# krb4 http://web.mit.edu/kerberos/www/krb4-end-of-life.html

DEPEND="${RDEPEND}
	test? (
		sys-apps/diffutils
		dev-lang/perl
	)"
# used - but can do without in self test: net-misc/stunnel

# ares must be disabled for threads and both can be disabled
# one can use wether gnutls or nss if ssl is enabled
REQUIRED_USE="threads? ( !ares )
	nss? ( !gnutls )"

DOCS=()
S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${MY_PN}-7.20.0-strip-ldflags.patch \
		"${FILESDIR}"/${MY_PN}-7.19.7-test241.patch \
		"${FILESDIR}"/${MY_PN}-7.18.2-prefix.patch \
		"${FILESDIR}"/${MY_PN}-respect-cflags-3.patch \
		"${FILESDIR}"/0001-CURLOPT_DNS_SERVERS-set-name-servers-if-possible.patch \
		"${FILESDIR}"/0001-CURLOPT_DNS_SERVERS-set-name-servers-if-possible-fix.patch \
		"${FILESDIR}"/0001-Do-not-try-to-do-DNS-name-resolution-on-interface-na.patch \
		"${FILESDIR}"/0001-multi-handle-timeouts-on-DNS-servers-by-checking-for.patch \
		"${FILESDIR}"/0001-multi-interface-only-use-non-NULL-function-pointer.patch
	sed -i '/LD_LIBRARY_PATH=/d' configure.ac || die #382241

	eprefixify curl-config.in
	eautoreconf
}

multilib_src_configure() {
	local myconf

	if use gnutls; then
		myconf+=" --without-ssl --with-gnutls --without-nss"
		myconf+=" --with-ca-bundle=${EPREFIX}/etc/ssl/certs/ca-certificates.crt"
	elif use ssl; then
		myconf+=" --without-gnutls --without-nss --with-ssl"
		myconf+=" --without-ca-bundle --with-ca-path=${EPREFIX}/etc/ssl/certs"
	elif use nss; then
		myconf+=" --without-ssl --without-gnutls --with-nss"
		myconf+=" --with-ca-bundle=${EPREFIX}/etc/ssl/certs/ca-certificates.crt"
	else
		myconf+=" --without-gnutls --without-nss --without-ssl"
	fi

	# prefix hack, works for now
	ECONF_SOURCE="${S}" \
	econf \
		--prefix=/opt/steam-runtime/usr/ \
		$(use_enable ldap) \
		$(use_enable ldap ldaps) \
		$(use_with idn libidn) \
		$(use_with kerberos gssapi "${EPREFIX}"/usr) \
		$(use_with libssh2) \
		$(use_enable static-libs static) \
		$(use_enable ipv6) \
		$(use_enable threads threaded-resolver) \
		$(use_enable ares) \
		--enable-http \
		--enable-ftp \
		--enable-gopher \
		--enable-file \
		--enable-dict \
		--enable-manual \
		--enable-telnet \
		--enable-smtp \
		--enable-pop3 \
		--enable-imap \
		--enable-rtsp \
		--enable-nonblocking \
		--enable-largefile \
		--enable-maintainer-mode \
		--disable-sspi \
		--without-krb4 \
		--without-librtmp \
		--without-spnego \
		${myconf}

	if ! multilib_is_native_abi; then
                # avoid building the client
                sed -i -e '/SUBDIRS/s:src::' Makefile || die
        fi
}

multilib_src_install() {
	default
	find "${ED}" -name '*.la' -delete
	rm -rf "${ED}"/etc/

	# hack, works for now
	rm -rf "${ED}"/usr/

	# https://sourceforge.net/tracker/index.php?func=detail&aid=1705197&group_id=976&atid=350976
	#insinto /usr/share/aclocal
	#doins docs/libcurl/libcurl.m4

	#dodoc CHANGES README
	#dodoc docs/FEATURES docs/INTERNALS
	#dodoc docs/MANUAL docs/FAQ docs/BUGS docs/CONTRIBUTE
}
