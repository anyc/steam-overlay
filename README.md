steam-overlay
=============

Gentoo overlay for Valve's Steam client and Steam-based games. Stable ebuilds are also transferred to [Gamerlay overlay](http://dev.gentoo.org/~mrpouet/pub/gamerlay/main_page.xml) ([repo](http://git.overlays.gentoo.org/gitweb/?p=proj/gamerlay.git;a=summary)). 
Currently, it seems no one of the contributors is part of the beta, therefore we cannot provide information about game-specific dependencies. Please see the "Contribute" section below if you have more information.

Using the overlay
-----------------

To use this overlay follow the instructions at [Layman with custom git repo](http://samuelololol.blogspot.de/2010/10/layman-with-custom-git-repo-ie-github.html). You can use steam-overlay.xml for convenience.

Troubleshooting Steam
---------------------

If you have problems, please take a look at http://wiki.gentoo.org/wiki/Steam, [Gentoo Forums thread](https://forums.gentoo.org/viewtopic-t-930354-postdays-0-postorder-asc-start-75.html) and [Arch Wiki](https://wiki.archlinux.org/index.php/Steam#Native_Steam_on_Linux).

The correspondig bugzilla entry is here: [Bug #442176](https://bugs.gentoo.org/show_bug.cgi?id=442176)

Contribute to this overlay
--------------------------

If you want to suggest changes, like new dependencies or game-related stuff, please send a github pull request with explanation/proof why this is necessary, so we can discuss it. Determine correct behavior and dependencies can be tricky, therefore we'd like to discuss and wait for confirmation of others before adding modifications or new ebuilds.

Branches
--------

* master: current stable versions, should equal the ebuilds in gamerlay overlay
* testing: testing new modifications for master branch
* single_ebuild: the all-in-one steam-installer ebuild (deprecated)
