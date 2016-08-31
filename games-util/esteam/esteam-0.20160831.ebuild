# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit prefix

DESCRIPTION="Scan Steam libraries to generate and emerge a Portage set"
HOMEPAGE="https://github.com/anyc/steam-overlay"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pulseaudio"

RDEPEND="app-eselect/eselect-opengl
	app-misc/pax-utils
	sys-apps/gentoo-functions"

S="${WORKDIR}"

src_install() {
	newbin $(prefixify_ro "${FILESDIR}"/script.bash) ${PN}

	insinto /usr/share/portage/config/sets
	newins $(prefixify_ro "${FILESDIR}"/set.conf) ${PN}.conf

	insinto /usr/share/${PN}
	doins "${FILESDIR}"/database.bash

	if ! use pulseaudio; then
		sed -i 's:=media-sound/pulseaudio\b:=media-sound/apulse:g' \
			"${ED}"usr/share/${PN}/database.bash || die
	fi
}

pkg_postinst() {
	elog "Run esteam after installing or updating Steam games to have"
	elog "Portage automatically install the necessary dependencies. Your"
	elog "games will probably not start otherwise. See esteam -h for more"
	elog "information."
}
