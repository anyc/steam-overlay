# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils multilib-minimal

MY_P=SDL2_mixer-${PV}
DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="http://www.libsdl.org/projects/SDL_mixer/"
SRC_URI="http://www.libsdl.org/projects/SDL_mixer/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="flac mad mikmod mod modplug mp3 playtools smpeg static-libs vorbis +wav"
REQUIRED_USE="
	mp3? ( || ( smpeg mad ) )
	smpeg? ( mp3 )
	mad? ( mp3 )
	mod? ( || ( mikmod modplug ) )
	mikmod? ( mod )
	modplug? ( mod )
	"

DEPEND="media-libs/libsdl2[${MULTILIB_USEDEP}]
	flac? ( media-libs/flac[${MULTILIB_USEDEP}] )
	mp3? (
		mad? ( media-libs/libmad[${MULTILIB_USEDEP}] )
		smpeg? ( >=media-libs/smpeg2-2.0.0[${MULTILIB_USEDEP}] )
	)
	mod? (
		modplug? ( media-libs/libmodplug[${MULTILIB_USEDEP}] )
		mikmod? ( >=media-libs/libmikmod-3.1.10[${MULTILIB_USEDEP}] )
	)
	vorbis? (
		>=media-libs/libvorbis-1.0_beta4[${MULTILIB_USEDEP}]
		media-libs/libogg[${MULTILIB_USEDEP}]
	)"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-sdltest \
		--enable-music-cmd \
		$(use_enable wav music-wave) \
		$(use_enable mod music-mod) \
		$(use_enable modplug music-mod-modplug) \
		--disable-music-mod-modplug-shared \
		$(use_enable mikmod music-mod-mikmod) \
		--disable-music-mod-mikmod-shared \
		$(use_enable vorbis music-ogg) \
		--disable-music-ogg-shared \
		$(use_enable flac music-flac) \
		--disable-music-flac-shared \
		$(use_enable mp3 music-mp3) \
		$(use_enable smpeg music-mp3-smpeg) \
		--disable-music-mp3-smpeg-shared \
		--disable-smpegtest \
		$(use_enable mad music-mp3-mad-gpl)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	if use playtools; then
		emake DESTDIR="${D}" install-bin
	fi
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	use static-libs || prune_libtool_files
}
