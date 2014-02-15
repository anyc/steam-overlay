# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

# modified ebuild from main tree to provide libudev for steam

SR_DIR="/opt/steam-runtime/"
MY_P=udev-${PV}

inherit eutils flag-o-matic multilib toolchain-funcs linux-info libtool multilib-minimal

KEYWORDS="~amd64 ~x86"
SRC_URI="https://www.kernel.org/pub/linux/utils/kernel/hotplug/${MY_P}.tar.gz"
if [[ -n "${patchversion}" ]]
then
	patchset=${MY_P}-patchset-${patchversion}
	SRC_URI="${SRC_URI} mirror://gentoo/${patchset}.tar.bz2"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="selinux acl +gudev introspection keymap floppy edd"

COMMON_DEPEND="selinux? ( sys-libs/libselinux )
	acl? ( sys-apps/acl dev-libs/glib:2 )
	gudev? ( dev-libs/glib:2 )
	introspection? ( dev-libs/gobject-introspection )
	>=sys-apps/util-linux-2.16
	>=sys-libs/glibc-2.10"

DEPEND="${COMMON_DEPEND}
	keymap? ( dev-util/gperf )
	virtual/pkgconfig
	virtual/os-headers
	!<sys-kernel/linux-headers-2.6.34"

RDEPEND="${COMMON_DEPEND}
	acl? ( sys-apps/coreutils[acl] )
	!sys-apps/coldplug
	!<sys-fs/lvm2-2.02.45
	!sys-fs/device-mapper
	>=sys-apps/baselayout-1.12.5"

S=${WORKDIR}/${MY_P}

DOCS=""

src_prepare()
{
	# backport some patches
	if [[ -n "${patchset}" ]]
	then
		EPATCH_SOURCE="${WORKDIR}/${patchset}" EPATCH_SUFFIX="patch" \
			EPATCH_FORCE="yes" epatch
	fi
	
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
		--enable-static \
		$(use_with selinux) \
		--with-pci-ids-path="${EPREFIX}/usr/share/misc/pci.ids" \
		--with-usb-ids-path="${EPREFIX}/usr/share/misc/usb.ids" \
		$(use_enable acl udev_acl) \
		$(use_enable gudev) \
		$(use_enable introspection) \
		$(use_enable keymap) \
		$(use_enable floppy) \
		$(use_enable edd)
}

multilib_src_install()
{
	insinto "${SR_DIR}/usr/$(get_libdir)/"
	
	doins libudev/.libs/libudev.so.0.13.0
	ln -s libudev.so.0.13.0 "${D}/${SR_DIR}/usr/$(get_libdir)/libudev.so.0" || die
	ln -s libudev.so.0.13.0 "${D}/${SR_DIR}/usr/$(get_libdir)/libudev.so" || die
	
	if use gudev; then
		doins extras/gudev/.libs/libgudev-1.0.so.0.1.1
		ln -s libgudev-1.0.so.0.1.1 "${D}/${SR_DIR}/usr/$(get_libdir)/libgudev-1.0.so.0" || die
	fi
}

