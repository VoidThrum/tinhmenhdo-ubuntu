# TinhMenhDo Ubuntu

TinhMenhDo Ubuntu is a Debian metapackage that configures an Ubuntu desktop around a near-vanilla GNOME experience with GNOME Software and Flatpak.

When installed, the package:

- installs the vanilla GNOME desktop, GNOME Session, GNOME Software, Flatpak, Adwaita themes, and related dependencies;
- attempts to enable Flathub as a system-wide Flatpak remote;
- installs Zsh with Oh My Zsh, Git integration, autosuggestions, syntax highlighting, and persistent history;
- installs Fcitx5 and starts it automatically with the desktop session;
- recommends SKey as the Vietnamese Telex/VNI input method on amd64;
- installs Google Chrome Stable by default on amd64;
- installs Tailscale and RustDesk, with their system services enabled at boot;
- installs 7-Zip, Unzip, File Roller, Noto fonts, and the GNOME Extensions manager;
- sets Zsh as the default shell for existing desktop users and future users;
- resets existing Ptyxis preferences once so it starts with its default profile instead of an Ubuntu-specific palette;
- prevents Snap, Ubuntu Dock, the GNOME Software Snap plugin, and Yaru theme packages from being installed alongside the profile;
- keeps the Ubuntu wallpaper package required by Ubuntu's GNOME Shell.

The package does not add arbitrary third-party PPAs, recursively run APT, or delete existing Snap data and user files. Removing the package does not automatically restore components that were removed because of package conflicts.

Tailscale still requires one-time authentication with `sudo tailscale up`. RustDesk starts its service automatically but requires its own ID/password or server configuration before unattended remote access is used.

After installation, close and reopen Ptyxis once so the reset profile is loaded.

## Installation

### From the APT repository

On a supported Ubuntu system, download and run the published installer:

~~~sh
curl --fail --silent --show-error --location \
  https://voidthrum.github.io/tinhmenhdo-ubuntu/install-tinhmenhdo.sh \
  -o /tmp/install-tinhmenhdo.sh
chmod 700 /tmp/install-tinhmenhdo.sh
sudo /tmp/install-tinhmenhdo.sh
~~~

The installer verifies the repository key fingerprint, configures the signed APT source, and installs the package with SKey and Google Chrome Stable on amd64. It supports Ubuntu noble and resolute. Review the APT transaction before confirming.

The project repository includes the current amd64 SKey package from [collyn/skey](https://github.com/collyn/skey), the official Google Chrome Stable package, Tailscale packages for amd64/arm64, and RustDesk packages for amd64/arm64. Chrome's package adds Google's APT repository for future updates.

### From a local package file

Alternatively, install a built package with:

~~~sh
sudo apt install ./tinhmenhdo-ubuntu_*.deb
~~~

To install the companion packages from a downloaded GitHub Release asset, install all downloaded `.deb` files together. Installing the package may remove Snap, Ubuntu Dock, and Yaru theme packages.

## Update

Once the APT repository is configured, update the package with:

~~~sh
sudo apt update
sudo apt install --only-upgrade tinhmenhdo-ubuntu
~~~

Or update it together with the rest of the system:

~~~sh
sudo apt update
sudo apt upgrade
~~~

## Removal

~~~sh
sudo apt remove tinhmenhdo-ubuntu
sudo apt autoremove --purge
~~~

Removal does not automatically reinstall packages removed because of conflicts.

## License

MIT. See [debian/copyright](debian/copyright).
