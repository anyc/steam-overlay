# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

# modified ebuild from main tree to provide libudev for steam

SR_DIR="/opt/steam-runtime/"
MY_P=udev-${PV}

inherit eutils flag-o-matic multilib toolchain-funcs linux-info libtool multilib-minimal

MULTILIB_COMPAT=( abi_x86_32 )
KEYWORDS="~amd64 ~x86"
SRC_URI="https://www.kernel.org/pub/linux/utils/kernel/hotplug/${MY_P}.tar.gz"

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="selinux acl +gudev"


COMMON_DEPEND="selinux? ( sys-libs/libselinux[${MULTILIB_USEDEP}] )
	acl? ( sys-apps/acl[${MULTILIB_USEDEP}] dev-libs/glib:2[${MULTILIB_USEDEP}] )
	gudev? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
	>=sys-apps/util-linux-2.16
	>=sys-libs/glibc-2.10"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	virtual/os-headers"

RDEPEND="${COMMON_DEPEND}
	acl? ( sys-apps/coreutils[acl] )"

S=${WORKDIR}/${MY_P}

DOCS=""

src_prepare()
{
	multilib_copy_sources
}

multilib_src_configure()
{
	filter-flags -fprefetch-loop-arrays
	econf \
		--prefix="${EPREFIX}/usr" \
		--sysconfdir="${EPREFIX}/etc" \
		--sbindir="${EPREFIX}/sbin" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--with-rootlibdir="${EPREFIX}/$(get_libdir)" \
		--libexecdir="${EPREFIX}/lib/udev" \
		--enable-logging \
		--disable-static \
		$(use_with selinux) \
		--with-pci-ids-path="${EPREFIX}/usr/share/misc/pci.ids" \
		--with-usb-ids-path="${EPREFIX}/usr/share/misc/usb.ids" \
		$(use_enable acl udev_acl) \
		$(use_enable gudev) \
		--disable-introspection \
		--disable-keymap \
		--disable-floppy \
		--disable-edd
}

multilib_src_install()
{
	into "${SR_DIR}/usr/"
	
	dolib libudev/.libs/libudev.so.0.13.0 libudev/.libs/libudev.so.0 libudev/.libs/libudev.so
	
	if use gudev; then
		dolib extras/gudev/.libs/libgudev-1.0.so.0.1.1 extras/gudev/.libs/libgudev-1.0.so.0
	fi
}

