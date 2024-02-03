steam-overlay
=============

Gentoo overlay for Valve's Steam client.

Valve only provides a 32-bit version of the client, uses an own update mechanism
for the client and games that is outside the control of package managers, and
ships a customized runtime with precompiled libraries. This overlay provides:

* A package for the Steam launcher.
* A utility to install additional native Linux game dependencies.
* Old ebuilds that are needed by games but have been officially removed by Gentoo.

*Please note*: Valve only supports Steam with their runtime enabled. If you have
problems, enable the runtime with the `steamruntime` USE flag or start Steam
with `STEAM_RUNTIME=1 steam` before reporting a bug at the [official bug
tracker](https://github.com/ValveSoftware/steam-for-linux/issues).

Usage
-----

* Install `app-eselect/eselect-repository` and `dev-vcs/git`:
  ```
  emerge --ask --noreplace app-eselect/eselect-repository dev-vcs/git
  ```

* Add this repository:
  ```
  eselect repository enable steam-overlay
  ```

* Then sync with either [emaint](https://wiki.gentoo.org/wiki/Emaint) or `emerge`:
  ```
  emaint sync -r steam-overlay
  emerge --sync
  ```

* The Steam runtime is enabled by default. If you'd like to rely solely on
  Gentoo packages, then disable the `steamruntime` USE flag. Use the `esteam`
  utility later to scan your installed native Linux games for additional Gentoo
  packages required by them. Note that Gentoo packages do not cover the entirety
  of the runtime, so a small number of games may not work.

* Install `games-util/steam-launcher`:
  ```
  emerge --ask games-util/steam-launcher
  ```
  This may prompt you to enable to `abi_x86_32` USE flag for many packages due to the Steam client being 32-bit. You can just enable it globally for simplicity.

* Start the client by executing `steam`.

Troubleshooting Steam
---------------------

If you encounter any issues, the following links may be helpful.

* [Steam on the Gentoo Wiki](https://wiki.gentoo.org/wiki/Steam)
* [Steam thread on the Gentoo Forums](https://forums.gentoo.org/viewtopic-t-930354.html)
* [Steam on the Arch Wiki](https://wiki.archlinux.org/title/Steam#Native_Steam_on_Linux)
* [Official Steam for Linux bug tracker](https://github.com/ValveSoftware/steam-for-linux/issues)

License
-------

steam-overlay is provided under the GNU General Public License v2. See [LICENSE](LICENSE).
