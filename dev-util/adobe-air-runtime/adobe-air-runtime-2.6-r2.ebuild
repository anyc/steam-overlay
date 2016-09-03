# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Adobe AIR runtime"
HOMEPAGE="http://www.adobe.com/products/air/tools/sdk/"
SRC_URI="http://airdownload.adobe.com/air/lin/download/${PV}/AdobeAIRSDK.tbz2 -> AdobeAIRSDK-${PV}.tbz2"

LICENSE="AdobeAIRSDK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip mirror"

DEPEND="dev-util/patchelf"

RDEPEND="app-arch/unzip
	dev-libs/atk[abi_x86_32]
	dev-libs/glib:2[abi_x86_32]
	dev-libs/libxml2:2[abi_x86_32]
	dev-libs/libxslt[abi_x86_32]
	dev-libs/nspr[abi_x86_32]
	dev-libs/nss[abi_x86_32]
	gnome-base/gconf:2[abi_x86_32]
	media-libs/fontconfig:1.0[abi_x86_32]
	media-libs/freetype:2[abi_x86_32]
	media-libs/hal-flash[abi_x86_32]
	net-misc/curl[abi_x86_32]
	sys-libs/zlib[abi_x86_32]
	www-plugins/adobe-flash[abi_x86_32]
	x11-libs/cairo[abi_x86_32]
	x11-libs/gdk-pixbuf[abi_x86_32]
	x11-libs/gtk+:2[abi_x86_32,cups]
	x11-libs/libX11[abi_x86_32]
	x11-libs/libXcursor[abi_x86_32]
	x11-libs/libXext[abi_x86_32]
	x11-libs/libXrender[abi_x86_32]
	x11-libs/libXt[abi_x86_32]
	x11-libs/pango[abi_x86_32]"

QA_PRESTRIPPED=".*\.so"
QA_EXECSTACK="*/libCore.so */libcurl.so */libadobecertstore.so */libadobecp.so"
QA_TEXTRELS="*/libcurl.so */libadobecertstore.so"
QA_PREBUILT=".*\.so */Resources/rpmbuilder */Resources/appentry"

S=${WORKDIR}

src_install() {
	local SDKDIR="opt/Adobe AIR/"
	local RTDIR="runtimes/air/linux/Adobe AIR/Versions/1.0"

	# fix QA, see https://bugs.gentoo.org/show_bug.cgi?id=542796
	patchelf --set-rpath "$(patchelf --print-rpath "${RTDIR}"/Resources/libcurl.so | sed "s,\\$\\$,$,g")" "${RTDIR}"/Resources/libcurl.so
	patchelf --set-rpath "$(patchelf --print-rpath "${RTDIR}"/Resources/libpacparser.so | sed "s,\\$\\$,$,g")" "${RTDIR}"/Resources/libpacparser.so

	# remove the broken symlinks
	rm -rv "${RTDIR}"/Resources/nss3 || die

	insinto "/${SDKDIR}"
	doins -r "runtimes/air/linux/Adobe AIR/"*

	cd "${ED}" || die
	fperms 0755 "${SDKDIR}"/Versions/1.0/{libCore.so,Resources/lib*.so*}

	# swap ancient bundled Flash Player with a symlink
	dosym /{usr/$(ABI=x86 get_libdir)/nsbrowser/plugins,"${SDKDIR}"/Versions/1.0/Resources}/libflashplayer.so
}

pkg_postinst() {
	ewarn "Adobe AIR is officially unsupported on Linux."
	ewarn "Use it on your own risk."
	ewarn ""

	elog "To run AIR apps, you have to accept the EULA."
	elog "If you do, execute the following commands as user:"
	elog "   mkdir -p ~/.appdata/Adobe/AIR"
	elog "   echo 2 > ~/.appdata/Adobe/AIR/eulaAccepted"
}
