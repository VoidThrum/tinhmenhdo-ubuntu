# TinhMenhDo Ubuntu: Trải nghiệm Ubuntu pure vanilla GNOME chuẩn & tối giản

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04%20LTS%20%7C%2024.10-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![GNOME](https://img.shields.io/badge/Desktop-Pure%20Vanilla%20GNOME-4a86cf?logo=gnome&logoColor=white)](https://www.gnome.org/)
[![Input Method](https://img.shields.io/badge/Vietnamese%20IME-SKey%20(fcitx5--skey)-brightgreen)](https://github.com/collyn/skey)
[![Package Format](https://img.shields.io/badge/Package-Debian%20Metapackage-A81D33?logo=debian&logoColor=white)](debian/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](debian/copyright)

> **TinhMenhDo Ubuntu** là Debian metapackage biến Ubuntu thành hệ thống **chạy giao diện GNOME nguyên bản (Pure Vanilla GNOME)** mượt mà, loại bỏ triệt để Snap, Ubuntu Dock và giao diện Yaru tùy biến của Canonical. Tích hợp sẵn bộ gõ tiếng Việt hiện đại và hệ sinh thái Flatpak/Flathub chuẩn mực.

---

## 🌟 Điểm nổi bật (Key features)

- **Pure Vanilla GNOME Experience**: Trải nghiệm giao diện GNOME thuần khiết như Fedora hay Arch GNOME. Loại bỏ hoàn toàn sự can thiệp của Canonical (`ubuntu-dock`, giao diện `yaru-theme-*`), mang lại không gian làm việc sạch sẽ, hiệu năng cao và phong cách thiết kế Adwaita hiện đại.
- **Trải nghiệm bộ gõ Tiếng Việt đỉnh cao với [SKey](https://github.com/collyn/skey) (Bộ gõ tiếng Việt tốt nhất cho Linux/Ubuntu hiện nay)**:
  - Dự án tích hợp sẵn **SKey** (`fcitx5-skey`) – bộ gõ tiếng Việt thế hệ mới được đánh giá là **nhẹ, mượt mà và hoạt động ổn định nhất trên Linux** hiện nay, được phát triển và tối ưu bởi tác giả **[Nguyễn Tiến Huy (collyn)](https://github.com/collyn)** ([collyn/skey](https://github.com/collyn/skey)).
  - **Khắc phục triệt để các lỗi cố hữu trên Linux**: Loại bỏ hoàn toàn hiện tượng mất chữ, nuốt ký tự, gạch chân khó chịu hay xung đột gõ tiếng Việt trên **Google Chrome**, các ứng dụng **Electron** (VS Code, Discord, Slack) và các IDE lập trình nặng.
  - **Tương thích hoàn hảo cả Wayland lẫn X11**: Hỗ trợ đầy đủ các kiểu gõ phổ biến **Telex / VNI**, chuyển đổi chế độ gõ siêu nhạy, tự động cấu hình và kích hoạt cùng phiên làm việc desktop.
- **Tạm biệt Snap - Tối ưu với Flatpak & Flathub**: Loại bỏ hoàn toàn `snapd` và các gói liên quan, mở sẵn remote **Flathub** trên toàn hệ thống kèm **GNOME Software (với plugin Flatpak)** để tải app nhanh, nhẹ và bảo mật.
- **Môi trường dòng lệnh (Terminal/Shell) cao cấp**: Cài đặt sẵn **Zsh** làm shell mặc định (áp dụng cho cả user hiện tại và user tạo mới), đi kèm framework **Oh My Zsh**, tích hợp Git, `autosuggestions`, `syntax-highlighting` và cấu hình persistent history. Tự động tinh chỉnh Ptyxis về profile chuẩn.
- **Công cụ cần thiết sẵn sàng (Ready-to-work)**: Cài sẵn Google Chrome Stable (amd64), Tailscale (kết nối VPN an toàn), RustDesk (remote desktop mã nguồn mở), 7-Zip, Unzip, File Roller, bộ phông chữ Noto fonts đầy đủ và GNOME Extensions Manager.
- **An toàn & Sạch sẽ**: Đóng gói dạng chuẩn Debian Metapackage với hệ thống xung đột (`Conflicts` & `Breaks`) minh bạch, không cài PPA rác, không can thiệp xóa dữ liệu người dùng hay chạy apt đệ quy.

---

## 🚀 Hướng dẫn cài đặt (Installation)

### Cách 1: Cài đặt tự động qua APT repository (Khuyên dùng)

Trên Ubuntu 24.04 (Noble) hoặc các bản phân phối Ubuntu được hỗ trợ, chạy lệnh cài đặt nhanh qua script:

```bash
curl --fail --silent --show-error --location \
  https://voidthrum.github.io/tinhmenhdo-ubuntu/install-tinhmenhdo.sh \
  -o /tmp/install-tinhmenhdo.sh
chmod 700 /tmp/install-tinhmenhdo.sh
sudo /tmp/install-tinhmenhdo.sh
```

> **Cơ chế hoạt động:** Script sẽ kiểm tra mã vân tay GPG (fingerprint), thiết lập APT source có chữ ký số bảo mật, sau đó cài đặt `tinhmenhdo-ubuntu` cùng bộ gõ **SKey** và **Google Chrome Stable** (trên kiến trúc amd64). Hãy kiểm tra danh sách thay đổi gói APT trước khi xác nhận cài đặt.

---

### Cách 2: Cài đặt từ gói `.deb` cục bộ

Tải gói `.deb` từ tab [Releases](../../releases) và chạy lệnh:

```bash
sudo apt install ./tinhmenhdo-ubuntu_*.deb
```

*Lưu ý: Nếu bạn tải về bộ file `.deb` (bao gồm các gói đồng hành như SKey, Tailscale, RustDesk), hãy đặt chung trong một thư mục và cài đặt tất cả cùng lúc bằng lệnh `sudo apt install ./*.deb`.*

---

## ⚙️ Cấu hình sau khi cài đặt (Post-installation)

1. **Khởi động lại session**: Đăng xuất (Log out) hoặc khởi động lại máy (Reboot). Tại màn hình đăng nhập, chọn phiên bản **GNOME** (Vanilla GNOME) thay vì Ubuntu.
2. **Bộ gõ Tiếng Việt SKey**: SKey và Fcitx5 được cấu hình tự động kích hoạt khi đăng nhập. Bạn có thể mở công cụ cấu hình Fcitx5 hoặc chạy `skey-setup -y` nếu cần tùy chỉnh thêm bảng mã hay kiểu gõ (Telex/VNI).
3. **Mạng & Điều khiển từ xa**:
   - **Tailscale**: Khởi chạy lần đầu qua lệnh:
     ```bash
     sudo tailscale up
     ```
   - **RustDesk**: Dịch vụ `rustdesk.service` đã được kích hoạt chạy ngầm, bạn chỉ cần mở ứng dụng để lấy ID/Password hoặc cấu hình server riêng.
4. **Terminal Ptyxis**: Hãy đóng và mở lại Ptyxis terminal một lần để profile mặc định được áp dụng đầy đủ.

---

## 🔄 Cập nhật hệ thống (Update)

Khi có bản cập nhật mới từ kho APT, bạn có thể cập nhật riêng gói:

```bash
sudo apt update
sudo apt install --only-upgrade tinhmenhdo-ubuntu
```

Hoặc nâng cấp toàn diện cùng toàn bộ hệ điều hành:

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 🗑️ Gỡ cài đặt (Removal)

Nếu muốn gỡ bỏ gói metapackage:

```bash
sudo apt remove tinhmenhdo-ubuntu
sudo apt autoremove --purge
```

> *Lưu ý*: Việc gỡ bỏ metapackage sẽ không tự động cài đặt lại các thành phần đã bị gỡ bỏ trước đó (như Snap hay Ubuntu Dock).

---

## 🤝 Lời cảm ơn & tác quyền (Credits & acknowledgments)

- Đặc biệt cảm ơn hệ thống **[TinhMenhDo.com](https://tinhmenhdo.com)** – Nền tảng tra cứu và [lập lá số Tử Vi](https://tinhmenhdo.com/tu-vi/la-so-tu-vi-viet-nam), [Tứ Trụ (Bát Tự)](https://tinhmenhdo.com/tu-vi-tu-tru/bazi-full-tu-tru-bat-tu-chinh-xac), gieo quẻ [Kinh Dịch](https://tinhmenhdo.com/gieo-que-kinh-dich), [xem ngày giờ tốt xấu](https://tinhmenhdo.com/xem-ngay-gio-tot-xau) và tính toán [tiết khí chính xác](https://tinhmenhdo.com/tiet-khi-chinh-xac) hàng đầu Việt Nam – đã tài trợ và hỗ trợ hạ tầng thiết bị thử nghiệm thực tế cho dự án.
- Dự án bộ gõ tiếng Việt xuất sắc **SKey** (`fcitx5-skey`) – Bộ gõ tiếng Việt tốt nhất và mượt mà nhất trên Linux hiện nay – được sáng lập và phát triển bởi tác giả **[Nguyễn Tiến Huy](https://github.com/collyn)** (kho mã nguồn chính thức: [collyn/skey](https://github.com/collyn/skey)).
- Toàn bộ cộng đồng mã nguồn mở **GNOME**, **Flatpak**, **Fcitx5**, **Oh My Zsh**, **Tailscale**, và **RustDesk**.

---

## 📄 Bản quyền (License)

Dự án được phân phối dưới giấy phép [MIT License](debian/copyright) cho các mã nguồn script cấu hình và đóng gói. Các gói phần mềm bên thứ ba (như Google Chrome, Tailscale, RustDesk) tuân theo giấy phép và điều khoản sử dụng riêng của nhà phát triển tương ứng.
