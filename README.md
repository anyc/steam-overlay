steam-overlay
=============

Gentoo overlay for Valve's Steam client and Steam-based games.

Valve only provides a 32-bit version of the client, uses an own update mechanism for the client and games that is not under control 
of package managers and ships a customized runtime with all precompiled libraries. This overlay provides an ebuild for the steam
installer and meta ebuilds as well as patched (multilib) ebuilds from main tree that enable the execution of the client and games with 
(almost only) system libraries on x86_64 and x86 systems.

*Please note*: Valve only supports Steam with an enabled steam runtime. If you have problems, enable the runtime with the use flag or 
start steam with `STEAM_RUNTIME=1 steam` before reporting a bug at the [official bug tracker](https://github.com/ValveSoftware/steam-for-linux/issues).

Usage
-----

* Include this overlay with [Layman](http://www.gentoo.org/proj/en/overlays/userguide.xml) and the following command `layman -a steam`
* Choose if you want to use the official Steam runtime along with its bundled libraries or system libraries by en-/disabling the `steamruntime` use flag (see "Notes for 
AMD64")
* Emerge `steam-meta` ebuild
* Start the client by executing `steam`

Notes for AMD64
---------------

If you disable `steamruntime`, our ebuilds depend on the split multilib packages that (partially) replace the emul-linux-x86* packages 
([background](http://kicherer.org/joomla/index.php/en/blog/liste/29-transition-of-emul-packages-to-true-multilib)). In order to use 
them, you have to unmask certain ebuilds and enable the ```abi_x86_32``` use flag. For convenience, we provide the file 
`multilib-keywords` that can be placed in the ```/etc/portage/package.keywords/``` directory. You also have to add 
```-abi_x86_32``` to ```/etc/portage/profile/use.mask```.

Troubleshooting Steam
---------------------

If you have problems, please take a look at http://wiki.gentoo.org/wiki/Steam, [Gentoo Forums 
thread](https://forums.gentoo.org/viewtopic-t-930354-postdays-0-postorder-asc-start-75.html), [Arch 
Wiki](https://wiki.archlinux.org/index.php/Steam#Native_Steam_on_Linux) and the [official bug tracker](https://github.com/ValveSoftware/steam-for-linux/issues).

The correspondig bugzilla entry is [bug #442176](https://bugs.gentoo.org/show_bug.cgi?id=442176). The official steam repo is [here](http://repo.steampowered.com/steam/).

Contribute to this overlay
--------------------------

If you want to suggest changes, like new dependencies or game-related stuff, please send a github pull request with explanation/proof why this is necessary, so we can discuss it. Determine correct behavior and dependencies can be tricky, therefore we'd like to discuss and wait for confirmation of others before adding modifications or new ebuilds.
