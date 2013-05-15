steam-overlay
=============

Gentoo overlay for Valve's Steam client and Steam-based games. Stable ebuilds are also transferred to [Gamerlay overlay](http://dev.gentoo.org/~mrpouet/pub/gamerlay/main_page.xml) ([repo](http://git.overlays.gentoo.org/gitweb/?p=proj/gamerlay.git;a=summary)). 

Using the overlay
-----------------

You can add this overlay with [Layman](http://www.gentoo.org/proj/en/overlays/userguide.xml) and the following command `layman -a steam`.

To install, emerge `steam-meta` ebuild.

Troubleshooting Steam
---------------------

If you have problems, please take a look at http://wiki.gentoo.org/wiki/Steam, [Gentoo Forums 
thread](https://forums.gentoo.org/viewtopic-t-930354-postdays-0-postorder-asc-start-75.html), [Arch 
Wiki](https://wiki.archlinux.org/index.php/Steam#Native_Steam_on_Linux) and the [official bug tracker](https://github.com/ValveSoftware/steam-for-linux/issues).

The correspondig bugzilla entry is [bug #442176](https://bugs.gentoo.org/show_bug.cgi?id=442176). The official steam repo is [here](http://repo.steampowered.com/steam/).

Contribute to this overlay
--------------------------

If you want to suggest changes, like new dependencies or game-related stuff, please send a github pull request with explanation/proof why this is necessary, so we can discuss it. Determine correct behavior and dependencies can be tricky, therefore we'd like to discuss and wait for confirmation of others before adding modifications or new ebuilds.
