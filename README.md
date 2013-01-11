steam-overlay
=============

Gentoo overlay for Valve's Steam client and Steam-based games. Stable ebuilds are also transferred to [Gamerlay overlay](http://dev.gentoo.org/~mrpouet/pub/gamerlay/main_page.xml) ([repo](http://git.overlays.gentoo.org/gitweb/?p=proj/gamerlay.git;a=summary)). 

Using the overlay
-----------------

To use this overlay either execute `layman -a steam` or follow the instructions at [Layman with custom git repo](http://samuelololol.blogspot.de/2010/10/layman-with-custom-git-repo-ie-github.html). You can use steam-overlay.xml for convenience.

To install, emerge `steam-meta` ebuild.

Troubleshooting Steam
---------------------

If you have problems, please take a look at http://wiki.gentoo.org/wiki/Steam, [Gentoo Forums thread](https://forums.gentoo.org/viewtopic-t-930354-postdays-0-postorder-asc-start-75.html), [Arch Wiki](https://wiki.archlinux.org/index.php/Steam#Native_Steam_on_Linux) and [official bug tracker](https://github.com/ValveSoftware/steam-for-linux/issues).

The correspondig bugzilla entry is here: [Bug #442176](https://bugs.gentoo.org/show_bug.cgi?id=442176)

Contribute to this overlay
--------------------------

If you want to suggest changes, like new dependencies or game-related stuff, please send a github pull request with explanation/proof why this is necessary, so we can discuss it. Determine correct behavior and dependencies can be tricky, therefore we'd like to discuss and wait for confirmation of others before adding modifications or new ebuilds.

Branches
--------

* master: current stable versions, should equal the ebuilds in gamerlay overlay
