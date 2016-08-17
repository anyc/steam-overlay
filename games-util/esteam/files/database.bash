# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Please keep these lists sorted!

GCC=\>=sys-devel/gcc-4.6.0
GLIBC=\>=sys-libs/glibc-2.15

LIBS[ld-linux-x86-64.so.2]=${GLIBC}[@MULTILIB@]
LIBS[ld-linux.so.2]=${GLIBC}[@MULTILIB@]
LIBS[libasound.so.2]=media-libs/alsa-lib[@ABI@]
LIBS[libatk-1.0.so.0]=dev-libs/atk[@ABI@]
LIBS[libattr.so.1]=sys-apps/attr[@ABI@]
LIBS[libavahi-client.so.3]=net-dns/avahi[@ABI@]
LIBS[libavahi-common.so.3]=net-dns/avahi[@ABI@]
LIBS[libbz2.so.1]=app-arch/bzip2[@ABI@]
LIBS[libc.so.6]=${GLIBC}[@MULTILIB@]
LIBS[libcairo.so.2]=x11-libs/cairo[@ABI@]
LIBS[libcanberra-gtk.so.0]=media-libs/libcanberra[@ABI@,gtk]
LIBS[libcanberra.so.0]=media-libs/libcanberra[@ABI@]
LIBS[libCg.so]=media-gfx/nvidia-cg-toolkit[@ABI@]
LIBS[libCgGL.so]=media-gfx/nvidia-cg-toolkit[@ABI@]
LIBS[libcom_err.so.2]=sys-libs/e2fsprogs-libs[@ABI@]
LIBS[libcrypto.so.1.0.0]=dev-libs/openssl:0[@ABI@]
LIBS[libcups.so.2]=net-print/cups[@ABI@]
LIBS[libcurl.so.4]=net-misc/curl[@ABI@]
LIBS[libdbus-1.so.3]=sys-apps/dbus[@ABI@]
LIBS[libdbus-glib-1.so.2]=dev-libs/dbus-glib[@ABI@]
LIBS[libdl.so.2]=${GLIBC}[@MULTILIB@]
LIBS[libdrm.so.2]=x11-libs/libdrm[@ABI@]
LIBS[libexif.so.12]=media-libs/libexif[@ABI@]
LIBS[libexpat.so.1]=dev-libs/expat[@ABI@]
LIBS[libexpatu.so.1]=dev-libs/expat[@ABI@,unicode]
LIBS[libexpatw.so.1]=dev-libs/expat[@ABI@,unicode]
LIBS[libffi.so.6]=dev-libs/libffi[@ABI@]
LIBS[libFLAC.so.8]=media-libs/flac[@ABI@]
LIBS[libfontconfig.so.1]=media-libs/fontconfig:1.0[@ABI@]
LIBS[libfreetype.so.6]=media-libs/freetype:2[@ABI@]
LIBS[libgcc_s.so.1]=${GCC}[@MULTILIB@]
LIBS[libgcrypt.so.11]=dev-libs/libgcrypt:11/11[@ABI@]
LIBS[libgdk-x11-2.0.so.0]=x11-libs/gtk+:2[@ABI@]
LIBS[libgdk_pixbuf-2.0.so.0]=x11-libs/gdk-pixbuf[@ABI@]
LIBS[libgio-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libGLEW.so.1.10]=media-libs/glew:1.10[@ABI@]
LIBS[libGLEW.so.1.6]=media-libs/glew:1.6[@ABI@]
LIBS[libglib-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libGLU.so.1]=media-libs/glu[@ABI@]
LIBS[libglut.so.3]=media-libs/freeglut[@ABI@]
LIBS[libgmodule-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libgobject-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libgthread-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libgtk-x11-2.0.so.0]=x11-libs/gtk+:2[@ABI@]
LIBS[libICE.so.6]=x11-libs/libICE[@ABI@]
LIBS[libidn.so.11]=net-dns/libidn:0/11.6.16[@ABI@]
LIBS[libjasper.so.1]=media-libs/jasper[@ABI@]
LIBS[libjpeg.so.62]=virtual/jpeg:62[@ABI@]
LIBS[libjpeg.so.8]=media-libs/jpeg:8[@ABI@]
LIBS[libm.so.6]=${GLIBC}[@MULTILIB@]
LIBS[libmono-2.0.so.1]=dev-lang/mono
LIBS[libmono-2.0.so]=dev-lang/mono
LIBS[libnspr4.so]=dev-libs/nspr[@ABI@]
LIBS[libnss3.so]=dev-libs/nss[@ABI@]
LIBS[libnssutil3.so]=dev-libs/nss[@ABI@]
LIBS[libogg.so.0]=media-libs/libogg[@ABI@]
LIBS[libopenal.so.1]=media-libs/openal[@ABI@]
LIBS[libpango-1.0.so.0]=x11-libs/pango[@ABI@]
LIBS[libpangocairo-1.0.so.0]=x11-libs/pango[@ABI@]
LIBS[libpangoft2-1.0.so.0]=x11-libs/pango[@ABI@]
LIBS[libpcre.so.1]=dev-libs/libpcre-debian:3[@ABI@]
LIBS[libpcre.so.3]=dev-libs/libpcre:3[@ABI@]
LIBS[libplc4.so]=dev-libs/nspr[@ABI@]
LIBS[libplds4.so]=dev-libs/nspr[@ABI@]
LIBS[libpng12.so.0]=media-libs/libpng:1.2[@ABI@]
LIBS[libpng15.so.15]=media-libs/libpng:1.5[@ABI@]
LIBS[libpng16.so.16]=media-libs/libpng:0/16[@ABI@]
LIBS[libpthread.so.0]=${GLIBC}[@MULTILIB@]
LIBS[libpulse-simple.so.0]=media-sound/pulseaudio[@ABI@]
LIBS[libpulse.so.0]=media-sound/pulseaudio[@ABI@]
LIBS[librt.so.1]=${GLIBC}[@MULTILIB@]
LIBS[libSDL-1.2.so.0]=media-libs/libsdl[@ABI@,joystick,sound,video]
LIBS[libSDL2-2.0.so.0]=media-libs/libsdl2[@ABI@,haptic,joystick,sound,threads,video]
LIBS[libSDL2_image-2.0.so.0]=media-libs/sdl2-image[@ABI@]
LIBS[libSDL2_mixer-2.0.so.0]=media-libs/sdl2-mixer[@ABI@]
LIBS[libSDL2_net-2.0.so.0]=media-libs/sdl2-net[@ABI@]
LIBS[libSDL2_ttf-2.0.so.0]=media-libs/sdl2-ttf[@ABI@]
LIBS[libSDL_image-1.2.so.0]=media-libs/sdl-image[@ABI@]
LIBS[libSDL_mixer-1.2.so.0]=media-libs/sdl-mixer[@ABI@]
LIBS[libSDL_net-1.2.so.0]=media-libs/sdl-net[@ABI@]
LIBS[libSDL_ttf-2.0.so.0]=media-libs/sdl-ttf[@ABI@]
LIBS[libSM.so.6]=x11-libs/libSM[@ABI@]
LIBS[libsmime3.so]=dev-libs/nss[@ABI@]
LIBS[libss.so.2]=sys-libs/e2fsprogs-libs[@ABI@]
LIBS[libssl.so.1.0.0]=dev-libs/openssl:0[@ABI@]
LIBS[libssl3.so]=dev-libs/nss[@ABI@]
LIBS[libstdc++.so.6]=${GCC}[@MULTILIB@,cxx]
LIBS[libtcmalloc.so.4]=dev-util/google-perftools:0/4[@ABI@]
LIBS[libtcmalloc_minimal.so.4]=dev-util/google-perftools:0/4[@ABI@]
LIBS[libtxc_dxtn.so]=media-libs/libtxc_dxtn[@ABI@]
LIBS[libudev.so.0]=sys-libs/libudev-compat[@ABI@]
LIBS[libuuid.so.1]=sys-apps/util-linux[@ABI@]
LIBS[libvorbis.so.0]=media-libs/libvorbis[@ABI@]
LIBS[libvorbisfile.so.3]=media-libs/libvorbis[@ABI@]
LIBS[libwayland-client.so.0]=dev-libs/wayland[@ABI@]
LIBS[libwayland-cursor.so.0]=dev-libs/wayland[@ABI@]
LIBS[libwayland-egl.so.1]=media-libs/mesa[@ABI@,wayland]
LIBS[libwrap.so.0]=sys-apps/tcp-wrappers[@ABI@]
LIBS[libX11.so.6]=x11-libs/libX11[@ABI@]
LIBS[libXcomposite.so.1]=x11-libs/libXcomposite[@ABI@]
LIBS[libXcursor.so.1]=x11-libs/libXcursor[@ABI@]
LIBS[libXdamage.so.1]=x11-libs/libXdamage[@ABI@]
LIBS[libXext.so.6]=x11-libs/libXext[@ABI@]
LIBS[libXfixes.so.3]=x11-libs/libXfixes[@ABI@]
LIBS[libXft.so.2]=dev-libs/libXft[@ABI@]
LIBS[libXi.so.6]=x11-libs/libXi[@ABI@]
LIBS[libXinerama.so.1]=x11-libs/libXinerama[@ABI@]
LIBS[libxkbcommon.so.0]=x11-libs/libxkbcommon[@ABI@]
LIBS[libxml2.so.2]=dev-libs/libxml2:2[@ABI@]
LIBS[libXrandr.so.2]=x11-libs/libXrandr[@ABI@]
LIBS[libXrender.so.1]=x11-libs/libXrender[@ABI@]
LIBS[libxslt.so.1]=dev-libs/libxslt[@ABI@]
LIBS[libXss.so.1]=x11-libs/libXScrnSaver[@ABI@]
LIBS[libXt.so.6]=dev-libs/libXt[@ABI@]
LIBS[libXtst.so.6]=dev-libs/libXtst[@ABI@]
LIBS[libXxf86vm.so.1]=x11-libs/libXxf86vm[@ABI@]
LIBS[libz.so.1]=sys-libs/zlib[@ABI@]

# IMPORTANT! Do not include games that are VAC enabled:
# http://store.steampowered.com/search/?sort_by=Name_ASC&category2=8&os=linux

UNBUNDLEABLES=(
	"A Boy and His Blob"
	"Alien Isolation"
	"Anodyne"
	"Sid Meier's Civilization V"
	"Trine 2"
)

# The following lack unbundleable libraries:

# 1001 Spikes
# Binaries
# Pix the Cat
# The Talos Principle

# The following should remain bundled:

# Half-Life 2 (VAC)
# Hammerwatch (Mono crashes)
# Portal (VAC?)
