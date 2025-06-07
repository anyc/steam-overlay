# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="Scan Steam libraries to generate and emerge a Portage set"
HOMEPAGE="https://github.com/anyc/steam-overlay"
S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pulseaudio systemd"

RDEPEND="
	app-misc/pax-utils
	sys-apps/gentoo-functions
"

src_install() {
	newbin $(prefixify_ro "${FILESDIR}"/script.bash) ${PN}

	insinto /usr/share/${PN}
	doins "${FILESDIR}"/database.bash

	if ! use pulseaudio; then
		sed -i 's:=media-libs/libpulse\b:=media-sound/apulse:g' \
			"${ED}"/usr/share/${PN}/database.bash || die
	fi

	if use systemd; then
		sed -i 's:=sys-apps/systemd-utils\b:=sys-apps/systemd:g' \
			"${ED}"/usr/share/${PN}/database.bash || die
	fi
}

pkg_postinst() {
	if [[ -e "${EPREFIX}"/var/lib/portage/${PN} && ! -e "${EPREFIX}"/etc/portage/sets/${PN} ]]; then
		ebegin "Moving old ${PN} Portage set to /etc/portage/sets"
		mkdir -p "${EPREFIX}"/etc/portage/sets || die
		mv "${EPREFIX}"/var/lib/portage/${PN} "${EPREFIX}"/etc/portage/sets/ || die
		eend $?
		echo
	fi

	elog "Run esteam after installing or updating Steam games to have"
	elog "Portage automatically install the necessary dependencies. Your"
	elog "games will probably not start otherwise. See esteam -h for more"
	elog "information."
}
