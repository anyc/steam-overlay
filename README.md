steam-overlay
=============

Gentoo overlay for Valve's Steam client and Steam-based games.

Valve only provides a 32-bit version of the client, uses an own update mechanism for the client and games that is not under control 
of package managers and ships a customized runtime with precompiled libraries. This overlay provides an ebuild for the steam
installer and meta ebuilds as well as patched (multilib) ebuilds from main tree that enable the execution of the client and games with 
(almost only) system libraries on x86_64 and x86 systems.

*Please note*: Valve only supports Steam with an enabled steam runtime. If you have problems, enable the runtime with the use flag or 
start steam with `STEAM_RUNTIME=1 steam` before reporting a bug at the [official bug tracker](https://github.com/ValveSoftware/steam-for-linux/issues).

Usage
-----

* Include this overlay with [Layman](http://www.gentoo.org/proj/en/overlays/userguide.xml) and the following command: `layman -a steam-overlay` *or*
  copy `steam-overlay.conf` from this repository into `/etc/portage/repos.conf/` to use the new [portage sync capabilities](https://wiki.gentoo.org/wiki/Project:Portage/Sync)
* Choose if you want to use the official Steam runtime along with its bundled libraries or system libraries by en-/disabling the `steamruntime` use flag. Disabling the official runtime is only 
  recommended for advanced Gentoo users
* Emerge the `steam-meta` package
* Start the client by executing `steam`

Notes for AMD64
---------------

As the client and most games use 32-bit executables, the ebuilds require that you enable the `abi_x86_32` use flag for some packages, see [this news 
item](https://www.gentoo.org/support/news-items/2015-03-28-true-multilib.html) for more information.

Troubleshooting Steam
---------------------

If you have problems, please take a look at http://wiki.gentoo.org/wiki/Steam, [Gentoo Forums 
thread](https://forums.gentoo.org/viewtopic-t-930354-postdays-0-postorder-asc-start-75.html), [Arch 
Wiki](https://wiki.archlinux.org/index.php/Steam#Native_Steam_on_Linux) and the [official bug tracker](https://github.com/ValveSoftware/steam-for-linux/issues).

The correspondig bugzilla entry is [bug #442176](https://bugs.gentoo.org/show_bug.cgi?id=442176). The official steam repo is [here](http://repo.steampowered.com/steam/).

License
-------

steam-overlay is provided under the GNU General Public License v2. See [LICENSE](LICENSE).
