# TinhMenhDo Ubuntu: Pure Vanilla GNOME & Minimalist Linux Desktop Experience

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04%20LTS%20%7C%2024.10-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![GNOME](https://img.shields.io/badge/Desktop-Pure%20Vanilla%20GNOME-4a86cf?logo=gnome&logoColor=white)](https://www.gnome.org/)
[![Input Method](https://img.shields.io/badge/Vietnamese%20IME-SKey%20(fcitx5--skey)-brightgreen)](https://github.com/collyn/skey)
[![Package Format](https://img.shields.io/badge/Package-Debian%20Metapackage-A81D33?logo=debian&logoColor=white)](debian/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](debian/copyright)

> **TinhMenhDo Ubuntu** is a Debian metapackage designed to transform Ubuntu into an elegant, high-performance **Pure Vanilla GNOME** environment. It completely strips away Snap, Ubuntu Dock, and Canonical's customized Yaru branding in favor of standard upstream Adwaita, a native Flatpak/Flathub application ecosystem, a modern Zsh shell, and an out-of-the-box Vietnamese input experience with SKey.

---

## 🌟 Key Features

- **Pure Vanilla GNOME Experience**: Experience GNOME in its authentic upstream form, just like Fedora workstation or Arch GNOME. Eliminates Canonical's modifications (`ubuntu-dock`, `yaru-theme-*`), providing a clean, distraction-free desktop with the modern Adwaita design language.
- **Flawless Vietnamese Typing with [SKey](https://github.com/collyn/skey)**:
  - Bundled with **SKey** (`fcitx5-skey`) – the next-generation Vietnamese input engine developed and optimized by **[Nguyễn Tiến Huy (collyn)](https://github.com/collyn)** ([collyn/skey](https://github.com/collyn/skey)).
  - **Eliminates common Linux typing issues**: No swallowed letters, missing characters, or unwanted underlines in **Google Chrome**, **Electron apps** (VS Code, Discord, Slack), or heavy developer IDEs.
  - **Complete Wayland & X11 compatibility**: Full support for Telex and VNI typing methods. Automatically configures and launches `skey-setup -y` on installation.
- **Snap-Free Architecture with Flatpak & Flathub**: Thoroughly removes `snapd` and associated daemon packages, replacing them with a system-wide **Flathub** repository and **GNOME Software (with Flatpak plugin)** for isolated, fast, and secure app management.
- **Enhanced Terminal & Shell Environment**: Sets **Zsh** as the default shell across current and newly created users. Pre-configured with **Oh My Zsh**, Git integration, history substring search, `zsh-autosuggestions`, `zsh-syntax-highlighting`, and persistent shared command history.
- **Ready-to-Work Toolset**: Comes ready with Google Chrome Stable (amd64), Tailscale (mesh VPN), RustDesk (open-source remote desktop), 7-Zip, Unzip, File Roller, comprehensive Noto fonts, and the GNOME Extensions Manager.
- **Clean & Transparent Debian Packaging**: Built strictly as a standard Debian metapackage with declarative `Conflicts` and `Breaks`. No third-party PPA bloat, no invasive recursive scripts, and no modification of personal user data.

---

## 🚀 Installation

### Method 1: Automatic Installation via APT Repository (Recommended)

On Ubuntu 24.04 LTS (Noble) or supported releases, run the automated installation script:

```bash
curl --fail --silent --show-error --location \
  https://voidthrum.github.io/tinhmenhdo-ubuntu/install-tinhmenhdo.sh \
  -o /tmp/install-tinhmenhdo.sh
chmod 700 /tmp/install-tinhmenhdo.sh
sudo /tmp/install-tinhmenhdo.sh
```

> **How it works:** The script verifies the repository's GPG key fingerprint, configures signed APT sources, installs `tinhmenhdo-ubuntu` with recommended packages (SKey, Chrome, Tailscale, RustDesk), and automatically runs post-setup hooks.

---

### Method 2: Local `.deb` Package Installation

Download the latest `.deb` packages from the [GitHub Releases](../../releases) page:

```bash
sudo apt install ./tinhmenhdo-ubuntu_*.deb
```

*Tip: If downloading companion packages (SKey, Tailscale, RustDesk) together, place them in a single folder and install them all with `sudo apt install ./*.deb`.*

---

## ⚙️ Post-Installation Setup

1. **Session Selection**: Log out or reboot. On the display manager login screen, select **GNOME** (Vanilla GNOME session) rather than Ubuntu.
2. **Vietnamese Input (SKey)**: SKey and Fcitx5 start automatically upon login. You can toggle typing with `Ctrl+Space` or run `skey-setup -y` anytime for reconfiguration.
3. **Services**:
   - **Tailscale**: Authenticate on first run with:
     ```bash
     sudo tailscale up
     ```
   - **RustDesk**: The background service `rustdesk.service` is pre-enabled. Simply open the app to view your connection ID/password or configure a self-hosted relay.
4. **Terminal / Shell**: Open a new terminal tab or run `exec zsh` to activate the Oh My Zsh theme and plugins.

---

## 🔄 Updates & Upgrades

To update `tinhmenhdo-ubuntu` when a new release is published to the APT repository:

```bash
sudo apt update
sudo apt install --only-upgrade tinhmenhdo-ubuntu
```

Or perform a full system upgrade:

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 🗑️ Uninstallation

To remove the metapackage:

```bash
sudo apt remove tinhmenhdo-ubuntu
sudo apt autoremove --purge
```

> *Note*: Removing the metapackage does not automatically restore previously removed components (such as Snap or Ubuntu Dock).

---

## 🤝 Credits & Acknowledgments

- **Nhà tài trợ & Bảo trợ hạ tầng (Sponsor)**:
  Trân trọng cảm ơn hệ thống **[TinhMenhDo.com](https://tinhmenhdo.com)** – Nền tảng tra cứu và [lập lá số Tử Vi](https://tinhmenhdo.com/tu-vi/la-so-tu-vi-viet-nam), [Tứ Trụ (Bát Tự)](https://tinhmenhdo.com/tu-vi-tu-tru/bazi-full-tu-tru-bat-tu-chinh-xac), gieo quẻ [Kinh Dịch](https://tinhmenhdo.com/gieo-que-kinh-dich), [xem ngày giờ tốt xấu](https://tinhmenhdo.com/xem-ngay-gio-tot-xau) và tính toán [tiết khí chính xác](https://tinhmenhdo.com/tiet-khi-chinh-xac) hàng đầu Việt Nam – đã đồng hành tài trợ và cung cấp hạ tầng phần cứng thử nghiệm thực tế cho dự án.
- **Vietnamese Input Engine (SKey)**:
  Special thanks to **[Nguyễn Tiến Huy](https://github.com/collyn)** for authoring and maintaining **[SKey](https://github.com/collyn/skey)** (`fcitx5-skey`), providing the smoothest and most dependable Vietnamese typing experience available on modern Linux desktop environments.
- **Open-Source Communities**:
  Gratitude to the open-source contributors behind **GNOME**, **Flatpak**, **Fcitx5**, **Oh My Zsh**, **Tailscale**, and **RustDesk**.

---

## 📄 License

Distributed under the [MIT License](debian/copyright) for configuration and packaging scripts. Third-party software packages (including Google Chrome, Tailscale, RustDesk) remain under the terms of their respective vendor licenses.
