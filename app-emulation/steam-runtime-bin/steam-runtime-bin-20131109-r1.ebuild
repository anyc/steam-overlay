# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker

DESCRIPTION="Precompiled 32bit libraries for steam that are currently missing on AMD64"
HOMEPAGE="http://github.com/anyc/steam-overlay/"
UBUNTU_MIRROR="mirror://ubuntu/pool/main"
SRC_URI="
	${UBUNTU_MIRROR}/n/network-manager/libnm-glib4_0.9.4.0-0ubuntu3_i386.deb
	${UBUNTU_MIRROR}/n/network-manager/libnm-util2_0.9.4.0-0ubuntu3_i386.deb
	"

LICENSE="LGPL-2.1 MIT GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="dev-libs/dbus-glib[abi_x86_32]
	dev-libs/glib[abi_x86_32]
	dev-libs/nspr[abi_x86_32]
	dev-libs/nss[abi_x86_32]
	sys-apps/util-linux[abi_x86_32]
	sys-libs/zlib[abi_x86_32]
	virtual/libgudev[abi_x86_32]
	virtual/libudev[abi_x86_32]

	amd64? ( sys-libs/glibc[multilib] )
	"

IUSE=""
S=${WORKDIR}

src_install() {
	local SR_DIR="/opt/steam-runtime/"

	echo "${SR_DIR}/lib32/" > 99-steam-runtime.conf
	echo "${SR_DIR}/usr/lib32/" >> 99-steam-runtime.conf
	echo "${SR_DIR}/lib32/i386-linux-gnu/" >> 99-steam-runtime.conf
	echo "${SR_DIR}/usr/lib32/i386-linux-gnu/" >> 99-steam-runtime.conf
	insinto /etc/ld.so.conf.d/
	doins 99-steam-runtime.conf

	insinto "${SR_DIR}/usr/lib32/"
	doins "${WORKDIR}/usr/lib/libnm-glib.so.4.3.0"
	ln -s libnm-glib.so.4.3.0 "${D}/${SR_DIR}/usr/lib32/libnm-glib.so.4" || die

	doins "${WORKDIR}/usr/lib/libnm-util.so.2.3.0"
	ln -s libnm-util.so.2.3.0 "${D}/${SR_DIR}/usr/lib32/libnm-util.so.2" || die
}
