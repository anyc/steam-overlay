# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools flag-o-matic toolchain-funcs eutils multilib-minimal

MY_P=SDL2-${PV}
DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="http://www.libsdl.org"
SRC_URI="http://www.libsdl.org/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""

IUSE="3dnow alsa altivec +audio custom-cflags dbus directfb fusionsound gles haptic +joystick mmx nas opengl oss pulseaudio sse sse2 static-libs +threads tslib udev +video X xinerama xscreensaver"
REQUIRED_USE="
	alsa? ( audio )
	fusionsound? ( audio )
	gles? ( video )
	nas? ( audio )
	opengl? ( video )
	pulseaudio? ( audio )
	xinerama? ( X )
	xscreensaver? ( X )"

RDEPEND="
	amd64? (
		abi_x86_32? (
			>=app-emulation/emul-linux-x86-soundlibs-20121202
			>=app-emulation/emul-linux-x86-opengl-20121202
			>=app-emulation/emul-linux-x86-xlibs-20121202
		)
	)
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus )
	directfb? ( >=dev-libs/DirectFB-1.0.0 )
	fusionsound? ( || ( >=media-libs/FusionSound-1.1.1 >=dev-libs/DirectFB-1.7.1[fusionsound] ) )
	gles? ( media-libs/mesa[gles2] )
	nas? ( media-libs/nas[${MULTILIB_USEDEP}] )
	opengl? ( virtual/opengl virtual/glu )
	pulseaudio? ( media-sound/pulseaudio )
	tslib? ( x11-libs/tslib )
	udev? ( virtual/udev )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXt[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
		xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
		xscreensaver? ( x11-libs/libXScrnSaver[${MULTILIB_USEDEP}] )
	)
	!media-libs/libsdl:2
	"
DEPEND="${RDEPEND}
	X? (
		x11-proto/xextproto[${MULTILIB_USEDEP}]
		x11-proto/xproto[${MULTILIB_USEDEP}]
	)
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

MULTILIB_WRAPPED_HEADERS=(
/usr/include/SDL2/SDL_config.h
)

src_prepare() {
	# https://bugzilla.libsdl.org/show_bug.cgi?id=1431
	epatch "${FILESDIR}"/${P}-static-libs.patch
	AT_M4DIR="/usr/share/aclocal acinclude" eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	use custom-cflags || strip-flags

	local directfbconf="--disable-video-directfb"
	if use directfb ; then
		# since DirectFB can link against SDL and trigger a
		# dependency loop, only link against DirectFB if it
		# isn't broken #61592
		echo 'int main(){}' > directfb-test.c
		$(tc-getCC) directfb-test.c -ldirectfb 2>/dev/null \
			&& directfbconf="--enable-video-directfb" \
			|| ewarn "Disabling DirectFB since libdirectfb.so is broken"
	fi

	# sorted by `./configure --help`
	econf \
		$(use_enable static-libs static) \
		$(use_enable audio) \
		$(use_enable video) \
		--enable-render \
		--enable-events \
		$(use_enable joystick) \
		$(use_enable haptic) \
		--enable-power \
		$(use_enable threads) \
		--enable-timers \
		--enable-file \
		--disable-loadso \
		--enable-cpuinfo \
		--enable-atomic \
		--enable-assembly \
		$(use_enable sse ssemath) \
		$(use_enable mmx) \
		$(use_enable 3dnow) \
		$(use_enable sse) \
		$(use_enable sse2) \
		$(use_enable altivec) \
		$(use_enable oss) \
		$(use_enable alsa) \
		--disable-alsa-shared \
		--disable-esd \
		$(use_enable pulseaudio) \
		--disable-pulseaudio-shared \
		--disable-arts \
		$(use_enable nas) \
		--disable-nas-shared \
		--disable-sndio \
		--disable-sndio-shared \
		$(use_enable audio diskaudio) \
		$(use_enable audio dummyaudio) \
		$(use_enable X video-x11) \
		--disable-x11-shared \
		$(use_enable X video-x11-xcursor) \
		$(use_enable xinerama video-x11-xinerama) \
		$(use_enable X video-x11-xinput) \
		$(use_enable X video-x11-xrandr) \
		$(use_enable xscreensaver video-x11-scrnsaver) \
		$(use_enable X video-x11-xshape) \
		$(use_enable X video-x11-vm) \
		--disable-video-cocoa \
		${directfbconf} \
		--disable-directfb-shared \
		$(use_enable fusionsound) \
		--disable-fusionsound-shared \
		$(use_enable video video-dummy) \
		$(use_enable opengl video-opengl) \
		$(use_enable gles video-opengles) \
		$(use_enable udev libudev) \
		$(use_enable dbus) \
		$(use_enable tslib input-tslib) \
		--disable-directx \
		--disable-rpath \
		--disable-render-d3d \
		$(use_with X x)
}

multlib_src_install() {
	emake DESTDIR="${D}" install
	use static-libs || prune_libtool_files
}

multilib_src_install_all() {
	dodoc {BUGS,CREDITS,README,README-SDL,README-hg,TODO,WhatsNew}.txt
}
