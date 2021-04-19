# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Please keep these lists sorted!

GCC=\>=sys-devel/gcc-4.6.0
GLIBC=\>=sys-libs/glibc-2.15

# Commented entries here are deemed to volatile to unbundle.
LIBS[ld-linux-x86-64.so.2]=${GLIBC}[@MULTILIB@]
LIBS[ld-linux.so.2]=${GLIBC}[@MULTILIB@]
LIBS[libacl.so.1]=sys-apps/acl[@ABI@]
LIBS[libalut.so.0]=media-libs/freealut[@ABI@]
LIBS[libappindicator.so.1]=dev-libs/libappindicator:2[@ABI@]
LIBS[libasn1.so.8]=app-crypt/heimdal[@ABI@]
LIBS[libasound.so.2]=media-libs/alsa-lib[@ABI@]
LIBS[libasyncns.so.0]=net-libs/libasyncns[@ABI@]
LIBS[libatk-1.0.so.0]=dev-libs/atk[@ABI@]
LIBS[libattr.so.1]=sys-apps/attr[@ABI@]
LIBS[libavahi-client.so.3]=net-dns/avahi[@ABI@]
LIBS[libavahi-common.so.3]=net-dns/avahi[@ABI@]
LIBS[libbz2.so.1]=app-arch/bzip2[@ABI@]
LIBS[libbz2.so.1.0]=app-arch/bzip2[@ABI@]
LIBS[libc.so.6]=${GLIBC}[@MULTILIB@]
LIBS[libcairo.so.2]=x11-libs/cairo[@ABI@]
LIBS[libcanberra-gtk.so.0]=media-libs/libcanberra[@ABI@,gtk]
LIBS[libcanberra.so.0]=media-libs/libcanberra[@ABI@]
LIBS[libcap.so.2]=sys-libs/libcap[@ABI@]
LIBS[libcef.so]=+
LIBS[libCg.so]=media-gfx/nvidia-cg-toolkit[@ABI@]
LIBS[libCgGL.so]=media-gfx/nvidia-cg-toolkit[@ABI@]
LIBS[libcom_err.so.2]=sys-libs/e2fsprogs-libs[@ABI@]
LIBS[libcrypto.so.0.9.8]=dev-libs/openssl-compat:0.9.8[@ABI@]
LIBS[libcrypto.so.1.0.0]=dev-libs/openssl-compat:1.0.0[@ABI@]
LIBS[libcrypto.so.1.1]=dev-libs/openssl:0/1.1[@ABI@]
LIBS[libcrypto.so.42]=libcrypto.so.1.0.0
LIBS[libcups.so.2]=net-print/cups[@ABI@]
LIBS[libcurl-gnutls.so.4]=net-libs/libcurl-debian:4[@ABI@]
LIBS[libcurl-nss.so.4]=net-libs/libcurl-debian:4[@ABI@]
LIBS[libcurl.so.3]=libcurl.so.4
LIBS[libcurl.so.4]=net-misc/curl[@ABI@]
LIBS[libdbus-1.so.3]=sys-apps/dbus[@ABI@]
LIBS[libdbus-glib-1.so.2]=dev-libs/dbus-glib[@ABI@]
LIBS[libdbusmenu-glib.so.4]=dev-libs/libdbusmenu[@ABI@]
LIBS[libdbusmenu-gtk.so.4]=dev-libs/libdbusmenu[@ABI@,gtk]
LIBS[libdl.so.2]=${GLIBC}[@MULTILIB@]
LIBS[libdrm.so.2]=x11-libs/libdrm[@ABI@]
LIBS[libexif.so.12]=media-libs/libexif[@ABI@]
LIBS[libexpat.so.1]=dev-libs/expat[@ABI@]
LIBS[libexpatu.so.1]=dev-libs/expat[@ABI@,unicode]
LIBS[libexpatw.so.1]=dev-libs/expat[@ABI@,unicode]
LIBS[libFAudio.so.0]=app-emulation/faudio[@ABI@]
LIBS[libffi.so.6]=dev-libs/libffi-compat:6[@ABI@]
LIBS[libFLAC.so.8]=media-libs/flac[@ABI@]
LIBS[libfltk.so.1.3]=x11-libs/fltk[@ABI@]
LIBS[libfltk_cairo.so.1.3]=x11-libs/fltk[@ABI@,cairo]
LIBS[libfltk_forms.so.1.3]=x11-libs/fltk[@ABI@]
LIBS[libfltk_gl.so.1.3]=x11-libs/fltk[@ABI@,opengl]
LIBS[libfltk_images.so.1.3]=x11-libs/fltk[@ABI@]
LIBS[libfmod.so]=+
LIBS[libfmodevent.so]=+
LIBS[libfmodex.so]=+
LIBS[libfontconfig.so.1]=media-libs/fontconfig:1.0[@ABI@]
LIBS[libform.so.5]=sys-libs/ncurses-compat:5[@ABI@]
LIBS[libform.so.6]==sys-libs/ncurses-6*[@ABI@]
LIBS[libformw.so.5]=sys-libs/ncurses-compat:5[@ABI@,unicode]
LIBS[libformw.so.6]==sys-libs/ncurses-6*[@ABI@,unicode]
LIBS[libfreetype.so.6]=media-libs/freetype:2[@ABI@]
LIBS[libgcc_s.so.1]=${GCC}[@MULTILIB@]
LIBS[libgconf-2.so.4]=gnome-base/gconf:2[@ABI@]
LIBS[libgcrypt.so.11]=dev-libs/libgcrypt-compat:11[@ABI@]
LIBS[libgcrypt.so.20]=dev-libs/libgcrypt:0/20[@ABI@]
LIBS[libgdk-x11-2.0.so.0]=x11-libs/gtk+:2[@ABI@]
LIBS[libgdk_pixbuf-2.0.so.0]=x11-libs/gdk-pixbuf[@ABI@]
LIBS[libgdk_pixbuf_xlib-2.0.so.0]=x11-libs/gdk-pixbuf[@ABI@,X]
LIBS[libgio-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libGL.so.1]=media-libs/libglvnd[@ABI@]
LIBS[libGLEW.so.1.10]==media-libs/glew-1.10*[@ABI@]
LIBS[libGLEW.so.1.6]==media-libs/glew-1.6*[@ABI@]
LIBS[libglib-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libGLU.so.1]=media-libs/glu[@ABI@]
LIBS[libglut.so.3]=media-libs/freeglut[@ABI@]
LIBS[libgme.so.0]=media-libs/game-music-emu[@ABI@]
LIBS[libgmodule-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libgmp.so.10]=dev-libs/gmp:0/10.4[@ABI@]
LIBS[libgobject-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libgomp.so.1]=${GCC}[@MULTILIB@,openmp]
LIBS[libgsm.so.1]=media-sound/gsm[@ABI@]
LIBS[libgpg-error.so.0]=dev-libs/libgpg-error[@ABI@]
LIBS[libgssapi.so.3]=app-crypt/heimdal[@ABI@]
LIBS[libgssapi_krb5.so.2]=app-crypt/mit-krb5[@ABI@]
LIBS[libgstapp-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstaudio-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstbase-0.10.so.0]=media-libs/gstreamer:0.10[@ABI@]
LIBS[libgstcdda-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstcheck-0.10.so.0]=media-libs/gstreamer:0.10[@ABI@]
LIBS[libgstcontroller-0.10.so.0]=media-libs/gstreamer:0.10[@ABI@]
LIBS[libgstdataprotocol-0.10.so.0]=media-libs/gstreamer:0.10[@ABI@]
LIBS[libgstfft-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstinterfaces-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstnet-0.10.so.0]=media-libs/gstreamer:0.10[@ABI@]
LIBS[libgstnetbuffer-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstpbutils-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstreamer-0.10.so.0]=media-libs/gstreamer:0.10[@ABI@]
LIBS[libgstriff-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstrtp-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstrtsp-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstsdp-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgsttag-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgstvideo-0.10.so.0]=media-libs/gst-plugins-base:0.10[@ABI@]
LIBS[libgthread-2.0.so.0]=dev-libs/glib:2[@ABI@]
LIBS[libgtk-x11-2.0.so.0]=x11-libs/gtk+:2[@ABI@]
LIBS[libgtk-3.so.0]=x11-libs/gtk+:3[@ABI@]
LIBS[libgudev-1.0.so.0]=dev-libs/libgudev[@ABI@]
LIBS[libheimbase.so.1]=app-crypt/heimdal[@ABI@]
LIBS[libheimntlm.so.0]=app-crypt/heimdal[@ABI@]
LIBS[libhogweed.so.4]=dev-libs/nettle-compat:6.2[@ABI@]
LIBS[libhx509.so.5]=app-crypt/heimdal[@ABI@]
LIBS[libICE.so.6]=x11-libs/libICE[@ABI@]
LIBS[libidn.so.12]=net-dns/libidn:0/12[@ABI@]
LIBS[libindicator.so.7]=dev-libs/libindicator:0[@ABI@]
LIBS[libjack.so.0]=media-sound/jack2[@ABI@]
LIBS[libjacknet.so.0]=media-sound/jack2[@ABI@]
LIBS[libjasper.so.1]=media-libs/jasper[@ABI@]
LIBS[libjawt.so]=+
LIBS[libjpeg.so.62]=virtual/jpeg-compat:62[@ABI@]
LIBS[libjpeg.so.8]=media-libs/jpeg-compat:8[@ABI@]
LIBS[libjvm.so]=+
LIBS[libk5crypto.so.3]=app-crypt/mit-krb5[@ABI@]
LIBS[libkeyutils.so.1]=sys-apps/keyutils[@ABI@]
LIBS[libkrb5.so.3]=app-crypt/mit-krb5[@ABI@]
LIBS[libkrb5support.so.0]=app-crypt/mit-krb5[@ABI@]
LIBS[liblber-2.4.so.2]=net-nds/openldap[@ABI@]
LIBS[liblcms2.so.2]=media-libs/lcms:2[@ABI@]
LIBS[libldap-2.4.so.2]=net-nds/openldap[@ABI@]
LIBS[libldap_r-2.4.so.2]=net-nds/openldap[@ABI@]
LIBS[libltdl.so.7]=dev-libs/libltdl:0[@ABI@]
LIBS[libm.so.6]=${GLIBC}[@MULTILIB@]
LIBS[libmad.so.0]=media-libs/libmad[@ABI@]
LIBS[libmenu.so.5]=sys-libs/ncurses-compat:5[@ABI@]
LIBS[libmenu.so.6]==sys-libs/ncurses-6*[@ABI@]
LIBS[libmenuw.so.5]=sys-libs/ncurses-compat:5[@ABI@,unicode]
LIBS[libmenuw.so.6]==sys-libs/ncurses-6*[@ABI@,unicode]
LIBS[libmikmod.so.2]=media-libs/libmikmod[@ABI@]
LIBS[libmikmod.so.3]=media-libs/libmikmod[@ABI@]
LIBS[libMiles.so]=+
LIBS[libmodplug.so.1]=media-libs/libmodplug[@ABI@]
LIBS[libmp3lame.so.0]=media-sound/lame[@ABI@]
LIBS[libmpg123.so.0]=media-sound/mpg123[@ABI@]
LIBS[libncurses.so.5]=sys-libs/ncurses-compat:5[@ABI@]
LIBS[libncurses.so.6]==sys-libs/ncurses-6*[@ABI@]
LIBS[libncursesw.so.5]=sys-libs/ncurses-compat:5[@ABI@,unicode]
LIBS[libncursesw.so.6]==sys-libs/ncurses-6*[@ABI@,unicode]
LIBS[libnettle.so.6]=dev-libs/nettle-compat:6.2[@ABI@]
LIBS[libnm-glib.so.4]=net-libs/libnm-glib[@ABI@]
LIBS[libnm-util.so.2]=net-libs/libnm-glib[@ABI@]
LIBS[libnotify.so.4]=x11-libs/libnotify[@ABI@]
LIBS[libnsl.so.1]=${GLIBC}[@MULTILIB@]
LIBS[libnspr4.so]=dev-libs/nspr[@ABI@]
LIBS[libnss3.so]=dev-libs/nss[@ABI@]
LIBS[libnssutil3.so]=dev-libs/nss[@ABI@]
LIBS[libnuma.so.1]=sys-process/numactl[@ABI@]
LIBS[libogg.so.0]=media-libs/libogg[@ABI@]
LIBS[libopenal.so.1]=media-libs/openal[@ABI@]
LIBS[libOpenAL.so]=libopenal.so.1
LIBS[libopenjpeg.so.5]=media-libs/openjpeg:0/5[@ABI@]
LIBS[libopenvr_api.so]=+
LIBS[libopus.so.0]=media-libs/opus[@ABI@]
LIBS[liborc-0.4.so.0]=dev-lang/orc[@ABI@]
LIBS[liborc-test-0.4.so.0]=dev-lang/orc[@ABI@]
LIBS[libout123.so.0]=media-sound/mpg123[@ABI@]
LIBS[libp11-kit.so.0]=app-crypt/p11-kit[@ABI@]
LIBS[libpanel.so.5]=sys-libs/ncurses-compat:5[@ABI@]
LIBS[libpanel.so.6]==sys-libs/ncurses-6*[@ABI@]
LIBS[libpanelw.so.5]=sys-libs/ncurses-compat:5[@ABI@,unicode]
LIBS[libpanelw.so.6]==sys-libs/ncurses-6*[@ABI@,unicode]
LIBS[libpango-1.0.so.0]=x11-libs/pango[@ABI@]
LIBS[libpangocairo-1.0.so.0]=x11-libs/pango[@ABI@]
LIBS[libpangoft2-1.0.so.0]=x11-libs/pango[@ABI@]
LIBS[libpangoxft-1.0.so.0]=x11-libs/pango[@ABI@]
LIBS[libpci.so.3]=sys-apps/pciutils[@ABI@]
LIBS[libpcre.so.1]=dev-libs/libpcre:3[@ABI@]
LIBS[libpcre.so.3]=dev-libs/libpcre-debian:3[@ABI@]
LIBS[libpcrecpp.so.0]=dev-libs/libpcre:3[@ABI@,cxx]
LIBS[libpcreposix.so.3]=dev-libs/libpcre-debian:3[@ABI@]
LIBS[libpdf.so]=+
LIBS[libPhysXLoader.so.1]=+
LIBS[libpixman-1.so.0]=x11-libs/pixman[@ABI@]
LIBS[libplc4.so]=dev-libs/nspr[@ABI@]
LIBS[libplds4.so]=dev-libs/nspr[@ABI@]
LIBS[libpng12.so.0]=media-libs/libpng-compat:1.2[@ABI@]
LIBS[libpng15.so.15]=media-libs/libpng-compat:1.5[@ABI@]
LIBS[libpng16.so.16]=media-libs/libpng:0/16[@ABI@]
LIBS[libpthread.so.0]=${GLIBC}[@MULTILIB@]
LIBS[libpulse-simple.so.0]=media-sound/pulseaudio[@ABI@]
LIBS[libpulse.so.0]=media-sound/pulseaudio[@ABI@]
#LIBS[libQt5Core.so.5]=dev-qt/qtcore:5[@ABI@]
#LIBS[libQt5DBus.so.5]=dev-qt/qtdbus:5[@ABI@]
#LIBS[libQt5Gui.so.5]=dev-qt/qtgui:5[@ABI@]
#LIBS[libQt5OpenGL.so.5]=dev-qt/qtopengl:5[@ABI@]
#LIBS[libQt5Widgets.so.5]=dev-qt/qtwidgets:5[@ABI@]
#LIBS[libQt5X11Extras.so.5]=dev-qt/qtx11extras:5[@ABI@]
#LIBS[libQt5XcbQpa.so.5]=dev-qt/qtgui:5[@ABI@]
LIBS[libroken.so.18]=app-crypt/heimdal[@ABI@]
LIBS[libresolv.so.2]=${GLIBC}[@MULTILIB@]
LIBS[librt.so.1]=${GLIBC}[@MULTILIB@]
LIBS[libsamplerate.so.0]=media-libs/libsamplerate[@ABI@]
LIBS[libSDL-1.2.so.0]=media-libs/libsdl[@ABI@,joystick,sound,video]
LIBS[libSDL2-2.0.so.0]=media-libs/libsdl2[@ABI@,haptic,joystick,sound,threads,video]
LIBS[libSDL2-2.0.7.so]=libSDL2-2.0.so.0
LIBS[libSDL2-2.0.8.so]=libSDL2-2.0.so.0
LIBS[libSDL2_image-2.0.so.0]=media-libs/sdl2-image[@ABI@]
LIBS[libSDL2_image-2.0.1.so]=libSDL2_image-2.0.so.0
LIBS[libSDL2_mixer-2.0.so.0]=media-libs/sdl2-mixer[@ABI@]
LIBS[libSDL2_net-2.0.so.0]=media-libs/sdl2-net[@ABI@]
LIBS[libSDL2_ttf-2.0.so.0]=media-libs/sdl2-ttf[@ABI@]
LIBS[libSDL_image-1.2.so.0]=media-libs/sdl-image[@ABI@]
LIBS[libSDL_mixer-1.2.so.0]=media-libs/sdl-mixer[@ABI@]
LIBS[libSDL_net-1.2.so.0]=media-libs/sdl-net[@ABI@]
LIBS[libSDL_ttf-2.0.so.0]=media-libs/sdl-ttf[@ABI@]
LIBS[libselinux.so.1]=sys-libs/libselinux[@ABI@]
LIBS[libSM.so.6]=x11-libs/libSM[@ABI@]
LIBS[libsmime3.so]=dev-libs/nss[@ABI@]
LIBS[libsnappy.so.1]=app-arch/snappy:0/1[@ABI@]
LIBS[libsndfile.so.1]=media-libs/libsndfile[@ABI@]
LIBS[libsoxr.so.0]=media-libs/soxr[@ABI@]
LIBS[libspeex.so.1]=media-libs/speex[@ABI@]
LIBS[libspeexdsp.so.1]=media-libs/speex[@ABI@]
LIBS[libsqlite3.so.0]=dev-db/sqlite:3[@ABI@]
LIBS[libss.so.2]=sys-libs/e2fsprogs-libs[@ABI@]
LIBS[libssl.so.0.9.8]=dev-libs/openssl-compat:0.9.8[@ABI@]
LIBS[libssl.so.1.0.0]=dev-libs/openssl-compat:1.0.0[@ABI@]
LIBS[libssl.so.1.1]=dev-libs/openssl:0/1.1[@ABI@]
LIBS[libssl.so.44]=libssl.so.1.0.0
LIBS[libssl3.so]=dev-libs/nss[@ABI@]
LIBS[libstdc++.so.5]=sys-libs/libstdc++-v3[@MULTILIB@]
LIBS[libstdc++.so.6]=${GCC}[@MULTILIB@,cxx]
LIBS[libsteam_api.so]=+
LIBS[libSteamValidateUserIDTickets_amd64.so]=+
LIBS[libtasn1.so.6]=dev-libs/libtasn1:0/6[@ABI@]
LIBS[libtbb.so.2]=dev-cpp/tbb[@ABI@]
LIBS[libtbbmalloc.so.2]=dev-cpp/tbb[@ABI@]
LIBS[libtbbmalloc_proxy.so.2]=dev-cpp/tbb[@ABI@]
#LIBS[libtcmalloc.so.4]==dev-util/google-perftools-2*[@ABI@]
#LIBS[libtcmalloc_minimal.so.4]==dev-util/google-perftools-2*[@ABI@]
LIBS[libtdb.so.1]=sys-libs/tdb[@ABI@]
LIBS[libtheora.so.0]=media-libs/libtheora[@ABI@]
LIBS[libtheoradec.so.1]=media-libs/libtheora[@ABI@]
LIBS[libtheoraenc.so.1]=media-libs/libtheora[@ABI@,encode]
LIBS[libthread_db.so.1]=${GLIBC}[@MULTILIB@]
LIBS[libtier0.so]=+
LIBS[libtier0_s.so]=+
LIBS[libtier0_srv.so]=+
LIBS[libtiff.so.3]=media-libs/tiff:3[@ABI@]
LIBS[libtiff.so.4]=media-libs/tiff:3[@ABI@]
LIBS[libtiff.so.5]=media-libs/tiff:0[@ABI@]
LIBS[libtiffxx.so.3]=media-libs/tiff:3[@ABI@,cxx]
LIBS[libtiffxx.so.4]=media-libs/tiff:3[@ABI@,cxx]
LIBS[libtiffxx.so.5]=media-libs/tiff:0[@ABI@,cxx]
LIBS[libtinfo.so.5]=sys-libs/ncurses-compat:5[@ABI@,tinfo]
LIBS[libtinfo.so.6]==sys-libs/ncurses-6*[@ABI@,tinfo]
LIBS[libtogl.so]=+
LIBS[libtwolame.so.0]=media-sound/twolame[@ABI@]
LIBS[libtxc_dxtn.so]=media-libs/libtxc_dxtn[@ABI@]
LIBS[libudev.so.0]=sys-libs/libudev-compat[@ABI@]
LIBS[libusb-1.0.so.0]=dev-libs/libusb:1[@ABI@]
LIBS[libuuid.so.1]=sys-apps/util-linux[@ABI@]
LIBS[libva-glx.so.1]=x11-libs/libva-compat:1[@ABI@,opengl]
LIBS[libva-x11.so.1]=x11-libs/libva-compat:1[@ABI@,X]
LIBS[libva.so.1]=x11-libs/libva-compat:1[@ABI@]
LIBS[libvdpau.so.1]=x11-libs/libvdpau[@ABI@]
LIBS[libvorbis.so.0]=media-libs/libvorbis[@ABI@]
LIBS[libvorbisenc.so.2]=media-libs/libvorbis[@ABI@]
LIBS[libvorbisfile.so.3]=media-libs/libvorbis[@ABI@]
LIBS[libvstdlib.so]=+
LIBS[libvstdlib_s.so]=+
LIBS[libvstdlib_srv.so]=+
LIBS[libwavpack.so.1]=media-sound/wavpack[@ABI@]
LIBS[libwayland-client.so.0]=dev-libs/wayland[@ABI@]
LIBS[libwayland-cursor.so.0]=dev-libs/wayland[@ABI@]
LIBS[libwayland-egl.so.1]=media-libs/mesa[@ABI@,wayland]
LIBS[libwind.so.0]=app-crypt/heimdal[@ABI@]
LIBS[libwine.so.1]=+
LIBS[libwrap.so.0]=sys-apps/tcp-wrappers[@ABI@]
LIBS[libX11-xcb.so.1]=x11-libs/libX11[@ABI@]
LIBS[libX11.so.6]=x11-libs/libX11[@ABI@]
LIBS[libXau.so.6]=x11-libs/libXau[@ABI@]
LIBS[libXaw.so.7]=x11-libs/libXaw[@ABI@]
LIBS[libXaw7.so.7]=x11-libs/libXaw[@ABI@]
LIBS[libXcomposite.so.1]=x11-libs/libXcomposite[@ABI@]
LIBS[libXcursor.so.1]=x11-libs/libXcursor[@ABI@]
LIBS[libXdamage.so.1]=x11-libs/libXdamage[@ABI@]
LIBS[libXdmcp.so.6]=x11-libs/libXdmcp[@ABI@]
LIBS[libXext.so.6]=x11-libs/libXext[@ABI@]
LIBS[libXfixes.so.3]=x11-libs/libXfixes[@ABI@]
LIBS[libXft.so.2]=x11-libs/libXft[@ABI@]
LIBS[libXi.so.6]=x11-libs/libXi[@ABI@]
LIBS[libXinerama.so.1]=x11-libs/libXinerama[@ABI@]
LIBS[libxkbcommon.so.0]=x11-libs/libxkbcommon[@ABI@]
LIBS[libxml2.so.2]=dev-libs/libxml2:2[@ABI@]
LIBS[libXmu.so.6]=x11-libs/libXmu[@ABI@]
LIBS[libXpm.so.4]=x11-libs/libXpm[@ABI@]
LIBS[libXrandr.so.2]=x11-libs/libXrandr[@ABI@]
LIBS[libXrender.so.1]=x11-libs/libXrender[@ABI@]
LIBS[libxslt.so.1]=dev-libs/libxslt[@ABI@]
LIBS[libXss.so.1]=x11-libs/libXScrnSaver[@ABI@]
LIBS[libXt.so.6]=x11-libs/libXt[@ABI@]
LIBS[libXtst.so.6]=x11-libs/libXtst[@ABI@]
LIBS[libxvidcore.so.4]=media-libs/xvid[@ABI@]
LIBS[libXxf86vm.so.1]=x11-libs/libXxf86vm[@ABI@]
LIBS[libz.so.1]=sys-libs/zlib[@ABI@]
LIBS[libzvbi.so.0]=media-libs/zvbi[@ABI@]
LIBS[vgui.so]=+

UNBUNDLEABLES=(
	"A Boy and His Blob"
	"Alien Isolation"
	"Altitude"
	"Anodyne"
	"Destination Sol"
	"Deus Ex Mankind Divided"
	"dota 2 beta"
	"dota 2"
	"Duck Game" # Effective when https://github.com/0x0ade/DuckGame-Linux is applied.
	"Dustforce"
	"Dwarfs - F2P"
	"GRID Autosport"
	"Half-Life 2"
	"Half-Life"
	"Life is Strange - Before the Storm"
	"Life Is Strange"
	"Mad Max"
	"Portal 2"
	"Portal Stories Mel"
	"Portal"
	"Revenge of the Titans"
	"Rise of the Tomb Raider"
	"ShadowOfMordor"
	"Sid Meier's Civilization V"
	"Skullgirls"
	"SpeedRunners"
	"This War of Mine"
	"Titan Attacks"
	"Tomb Raider"
	"Trine 2"
	"WormsWMD"
)

# The following lack unbundleable libraries:

# 1001 Spikes
# A Virus Named TOM
# Absolute Drift
# Besiege
# Binaries
# Bridge Constructor Portal
# BridgeConstructor
# Epistory
# Gang Beasts
# Hammerwatch
# Hover
# Human Fall Flat
# I Hate Running Backwards
# Letter Quest Remastered
# Lovers in a Dangerous Spacetime
# MegabytePunch
# Metro 2033 Redux
# Octodad Dadliest Catch
# Oh...Sir! The Insult Simulator
# PAC-MAN 256
# Pix the Cat
# Please, Don’t Touch Anything
# Prison Architect
# Rocket Wars
# rocketleague
# Screencheat
# Serious Sam 3
# The Talos Principle
# Tricky Towers
# Ultimate Chicken Horse
# Worms Clan Wars

# The following should remain bundled:

# Grim Fandango Remastered (custom SDL2? other libs are in DELETEABLES)

# The following files will be deleted if found:

DELETEABLES=(
	"Dwarfs - F2P"/lib{tier0,vstdlib}_s.so # Crashes on startup with these.
	"Grim Fandango Remastered"/{amd64,i386} # They bundled half a distro!
	"Life is Strange - Before the Storm"/sdl_override # Fixes minor bug but breaks with SDL 2.0.9 installed.
)
