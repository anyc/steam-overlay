# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/Ryochan7/sc-controller.git"
EGIT_BRANCH="python3"

PYTHON_COMPAT=( python3_{6..8} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 linux-info git-r3 xdg-utils

DESCRIPTION="User-mode driver and GTK3 based GUI for Steam Controller"
HOMEPAGE="https://github.com/Ryochan7/sc-controller/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pylibacl[${PYTHON_USEDEP}]
	gnome-base/librsvg:2[introspection]
	>=x11-libs/gtk+-3.22:3"
DEPEND="${RDEPEND}"

CONFIG_CHECK="
	~INPUT_UINPUT
"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
