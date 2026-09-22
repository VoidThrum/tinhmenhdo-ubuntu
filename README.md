# TinhMenhDo Ubuntu

Metapackage cho Ubuntu Desktop, hướng tới GNOME gần vanilla với GNOME Software, Flatpak/Flathub và không cài lại `snapd`, Ubuntu Dock hoặc Yaru theme.

## Trạng thái hiện tại

Đây là source repo. Hiện chưa có file `.deb`, APT metadata, public key hoặc GitHub remote thật. Trước khi phát hành cần build package, tạo APT repository, điền URL/fingerprint GPG thật trong `install-tinhmenhdo.sh`, rồi publish repository qua HTTPS.

Không commit private key, thư mục `~/.gnupg` hoặc thư mục `public/` chứa dữ liệu chưa được kiểm tra. Các artifact build và local repository đã được loại trong `.gitignore`.

## Vì sao không dùng bản nháp cũ nguyên xi?

- `Conflicts` chỉ làm APT không cho các gói Snap, Ubuntu Dock và Yaru theme tồn tại đồng thời; nó không phải cơ chế purge mọi dữ liệu cũ.
- Maintainer script không được gọi `apt`, không được tự xóa `/var/lib/snapd`, `/usr/lib/snapd` hoặc thư mục người dùng. Những việc đó dễ làm hỏng trạng thái dpkg và dữ liệu người dùng.
- Không thêm PPA trong `postinst`. PPA là nguồn bên ngoài, cần được người quản trị chấp thuận và bootstrap riêng.
- `vanilla-gnome-desktop` đã kéo các thành phần GNOME cần thiết qua dependency/recommendation; gói này khai báo thêm Adwaita và các thành phần quan trọng để việc cài đặt không phụ thuộc vào cấu hình `APT::Install-Recommends`.

## Build

Trên Ubuntu/Debian:

```sh
sudo apt update
sudo apt install --yes build-essential debhelper devscripts dpkg-dev apt-utils gnupg
dpkg-buildpackage -us -uc -b
```

File `.deb` sẽ nằm ở thư mục cha.

GitHub Actions trong `.github/workflows/validate.yml` tự kiểm tra shell script và build package trên Ubuntu 24.04. Workflow `.github/workflows/build-and-publish.yml` cũng build package và lưu `.deb` làm artifact sau mỗi push lên `main`.

## Cài đặt

### Máy khác, cài online từ APT repository

Workflow có thể tự publish APT repository lên GitHub Pages. Để bật bước publish, vào **Settings → Secrets and variables → Actions** và tạo repository variable `PUBLISH_APT=true`, cùng hai repository secrets:

- `APT_GPG_PRIVATE_KEY`: private key ASCII-armored dùng để ký APT Release.
- `APT_GPG_KEY_ID`: fingerprint đầy đủ của key tương ứng, không có khoảng trắng.

Không dùng key cá nhân; hãy tạo một signing key riêng cho repository. Nếu chưa bật `PUBLISH_APT=true` hoặc chưa tạo hai secret này, workflow vẫn build `.deb` nhưng bước publish Pages sẽ không chạy.

Sau khi workflow publish thành công và GitHub Pages đã bật chế độ **GitHub Actions**, URL repository là:

```text
https://voidthrum.github.io/tinhmenhdo-ubuntu/
```

Trước khi cài, kiểm tra nhanh endpoint:

```sh
curl --fail --silent --show-error --head \
  https://voidthrum.github.io/tinhmenhdo-ubuntu/install-tinhmenhdo.sh
curl --fail --silent --show-error --head \
  https://voidthrum.github.io/tinhmenhdo-ubuntu/public.key
```

Nếu cả hai trả HTTP `200`, trên máy Ubuntu mới chạy:

```sh
curl --fail --silent --show-error --location \
  https://voidthrum.github.io/tinhmenhdo-ubuntu/install-tinhmenhdo.sh \
  -o /tmp/install-tinhmenhdo.sh
chmod 700 /tmp/install-tinhmenhdo.sh
sudo /tmp/install-tinhmenhdo.sh
```

Script kiểm tra Ubuntu codename, xác minh fingerprint key, cài keyring, thêm APT source có `Signed-By`, chạy `apt-get update`, rồi cài metapackage. Workflow hiện publish metadata cho Ubuntu 24.04 `noble` và Ubuntu 26.04 `resolute`; không chạy trên `jammy` hoặc release khác cho đến khi có metadata tương ứng.

Installer sẽ khiến APT gỡ các package xung đột sau đây nếu chúng đang có mặt:

- `snapd`, `snapd-desktop-integration`, `gnome-software-plugin-snap`
- `gnome-shell-extension-ubuntu-dock`
- các package `yaru-theme-*` được khai báo trong metapackage

Đây là thay đổi có chủ ý nhưng có thể làm mất Ubuntu Dock, Yaru theme và các package phụ thuộc trực tiếp vào chúng. Không thử trên máy production nếu chưa có backup hoặc cách khôi phục.

Nếu đã tải file `.deb` và muốn xem APT sẽ gỡ/cài gì trước, chạy mô phỏng:

```sh
sudo apt-get -s install ./tinhmenhdo-ubuntu_1.0.0_all.deb
```

Mô phỏng không chạy `postinst`; nó chỉ giúp kiểm tra dependency và các package bị thay đổi.

Nếu chỉ muốn dùng file build mà chưa bật Pages, tải artifact `tinhmenhdo-deb` từ tab **Actions** rồi cài local:

```sh
sudo apt install ./tinhmenhdo-ubuntu_1.0.0_all.deb
```

### Cài bằng file `.deb` (USB hoặc file local)

Chép file `.deb` đã build sang máy mới, rồi chạy:

```sh
sudo apt install ./tinhmenhdo-ubuntu_1.0.0_all.deb
```

APT sẽ giải quyết xung đột với `snapd`, Ubuntu Dock và Yaru theme; các dependency chưa có trên máy vẫn cần nguồn APT hoạt động. Gói không purge dữ liệu Snap cũ. Theme mặc định của từng user có thể cần đăng xuất/đăng nhập hoặc chọn Adwaita trong GNOME Tweaks. Nếu muốn dọn dữ liệu Snap sau khi đã xác nhận không còn cần rollback:

```sh
sudo apt purge snapd
sudo apt autoremove --purge
```

Kiểm tra các thành phần Ubuntu đã bị loại:

```sh
dpkg-query -W -f='${db:Status-Status}\n' \
  gnome-shell-extension-ubuntu-dock yaru-theme-gnome-shell \
  yaru-theme-gtk yaru-theme-icon yaru-theme-sound 2>/dev/null || true
```

Gỡ profile:

```sh
sudo apt remove tinhmenhdo-ubuntu
sudo apt autoremove --purge
```

Việc gỡ profile không tự cài lại Snap, Ubuntu Dock hoặc Yaru. Nếu muốn khôi phục chúng, cài lại rõ ràng sau khi kiểm tra danh sách package:

```sh
sudo apt install snapd gnome-shell-extension-ubuntu-dock \
  yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound
```

## Firefox dạng deb

Không gắn PPA vào metapackage. Bootstrap riêng, sau khi kiểm tra chính sách của máy:

```sh
sudo apt install --yes software-properties-common
sudo add-apt-repository --yes ppa:mozillateam/ppa
sudo tee /etc/apt/preferences.d/mozillateam-firefox.pref >/dev/null <<'EOF'
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
EOF
sudo apt update
sudo apt install firefox
```

## Tạo APT repository

`repo/build-repo.sh` tạo các index `binary-ARCH`, `Release` và chữ ký `InRelease`/`Release.gpg`. Metadata dùng đường dẫn tương đối `pool/main/...`, nên hoạt động đúng khi thư mục output được deploy trực tiếp lên GitHub Pages. Script sẽ dừng nếu thiếu `.deb` hoặc secret GPG key. Ví dụ cho amd64 và arm64:

```sh
repo/build-repo.sh ./debs ./public noble "$GPG_KEY_ID" "amd64 arm64"
```

Xuất public key để client xác minh repository:

```sh
gpg --armor --export "$GPG_KEY_ID" > public/public.key
```

Chỉ đưa thư mục output lên một HTTPS static host sau khi kiểm tra chữ ký. Không commit private key.

Installer từ chối URL không dùng HTTPS, URL mẫu, fingerprint sai định dạng, hoặc fingerprint không khớp public key tải về.

GitHub Pages có thể phục vụ static APT repo. Có thể dùng GitHub Actions hoặc máy build riêng để tái tạo metadata và ký release; không commit private key.

Thông tin maintainer đã được đặt là `vuquyettam@gmail.com`. Build trên Ubuntu 24.04, rồi kiểm tra:

```sh
lintian ../tinhmenhdo-ubuntu_*.deb
sudo apt install ./../tinhmenhdo-ubuntu_*.deb
apt-cache policy snapd
flatpak remotes --system
```

Không đẩy thư mục chứa private GPG key, file `~/.gnupg`, hoặc một `InRelease` được ký bằng key không còn giữ được.

## Phạm vi hỗ trợ

Bản đầu nhắm Ubuntu 24.04 `noble` và Ubuntu 26.04 `resolute`, kiến trúc `amd64` và `arm64`. Cần build/test riêng cho từng Ubuntu release và kiến trúc; không dùng metadata `noble` cho `resolute` hoặc release khác.
