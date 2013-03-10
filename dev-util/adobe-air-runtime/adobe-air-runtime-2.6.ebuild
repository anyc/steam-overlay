# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils fdo-mime multilib

DESCRIPTION="Adobe AIR SDK"
HOMEPAGE="http://www.adobe.com/products/air/tools/sdk/"
SRC_URI="http://airdownload.adobe.com/air/lin/download/${PV}/AdobeAIRSDK.tbz2 -> AdobeAIRSDK-${PV}.tbz2"

LICENSE="AdobeAIRSDK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="strip mirror"

DEPEND=""
RDEPEND="app-arch/unzip
	x86? ( dev-libs/libxml2
		dev-libs/nspr
		dev-libs/nss
		media-libs/libpng
		net-misc/curl
		www-plugins/adobe-flash
		x11-libs/cairo
		x11-libs/gtk+ )
	amd64? ( app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-gtklibs )"

QA_PRESTRIPPED=".*\.so /opt/Adobe/AirSDK/bin/adl"
QA_EXECSTACK="*/libCore.so */libcurl.so */libadobecertstore.so */libadobecp.so"
QA_TEXTRELS="*/libcurl.so */libadobecertstore.so"
QA_PREBUILT=".*\.so */bin/adl */bin/naip */bin/adb */Resources/rpmbuilder */Resources/appentry"

S=${WORKDIR}

src_install() {
	local SDKDIR="opt/Adobe AIR/"
	local RTDIR="runtimes/air/linux/Adobe AIR/Versions/1.0"

	# remove the broken symlinks
	rm -fr "${RTDIR}"/Resources/nss3/{0d,1d}
	use x86 && rm -rf "${RTDIR}"/Resources/lib{curl,flashplayer}.so

	insinto "/${SDKDIR}"
	doins -r "runtimes/air/linux/Adobe AIR/"*

	cd "${D}"
	fperms 0755 "${SDKDIR}"/Versions/1.0/{libCore.so,Resources/lib*.so*}
}

pkg_postinst() {
	ewarn "Adobe AIR is officially unsupported on Linux."
	ewarn "Use it at on your own risk."
	ewarn ""

	elog "To run AIR apps, you have to accept the EULA."
	elog "If you do, execute the following commands as user:"
	elog "   mkdir -p ~/.appdata/Adobe/AIR"
	elog "   echo 2 > ~/.appdata/Adobe/AIR/eulaAccepted"
}
