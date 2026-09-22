# TinhMenhDo Ubuntu

Metapackage cho Ubuntu Desktop, hướng tới GNOME gần vanilla với GNOME Software, Flatpak/Flathub và không cài lại `snapd`.

## Trạng thái hiện tại

Đây là source repo. Hiện chưa có file `.deb`, APT metadata, public key hoặc GitHub remote thật. Trước khi phát hành cần build package, tạo APT repository, điền URL/fingerprint GPG thật trong `install-tinhmenhdo.sh`, rồi publish repository qua HTTPS.

Không commit private key, thư mục `~/.gnupg` hoặc thư mục `public/` chứa dữ liệu chưa được kiểm tra. Các artifact build và local repository đã được loại trong `.gitignore`.

## Vì sao không dùng bản nháp cũ nguyên xi?

- `Conflicts` chỉ làm APT không cho các gói Snap chính tồn tại đồng thời; nó không phải cơ chế purge mọi dữ liệu Snap.
- Maintainer script không được gọi `apt`, không được tự xóa `/var/lib/snapd`, `/usr/lib/snapd` hoặc thư mục người dùng. Những việc đó dễ làm hỏng trạng thái dpkg và dữ liệu người dùng.
- Không thêm PPA trong `postinst`. PPA là nguồn bên ngoài, cần được người quản trị chấp thuận và bootstrap riêng.
- `vanilla-gnome-desktop` đã kéo các thành phần GNOME cần thiết qua dependency/recommendation; gói này khai báo thêm các thành phần quan trọng để việc cài đặt không phụ thuộc vào cấu hình `APT::Install-Recommends`.

## Build

Trên Ubuntu/Debian:

```sh
sudo apt update
sudo apt install --yes build-essential debhelper devscripts dpkg-dev apt-utils gnupg
dpkg-buildpackage -us -uc -b
```

File `.deb` sẽ nằm ở thư mục cha.

GitHub Actions trong `.github/workflows/validate.yml` tự kiểm tra shell script và build package trên Ubuntu 24.04. Workflow này chỉ validate/build, chưa publish release.

## Cài đặt

### Máy khác, cài online từ APT repository

Sau khi public repo, thay URL/fingerprint key trong `install-tinhmenhdo.sh`, và build metadata đúng codename/kiến trúc, trên máy Ubuntu mới chạy:

```sh
curl --fail --silent --show-error --location \
  https://YOUR-USER.github.io/tinhmenhdo-ubuntu/install-tinhmenhdo.sh \
  -o /tmp/install-tinhmenhdo.sh
chmod 700 /tmp/install-tinhmenhdo.sh
sudo /tmp/install-tinhmenhdo.sh
```

Script kiểm tra Ubuntu codename, xác minh fingerprint key, cài keyring, thêm APT source có `Signed-By`, chạy `apt-get update`, rồi cài metapackage. Mỗi Ubuntu release phải có metadata repo tương ứng (`noble`, `jammy`, ...).

### Cài bằng file `.deb` (USB hoặc file local)

Chép file `.deb` đã build sang máy mới, rồi chạy:

```sh
sudo apt install ./tinhmenhdo-ubuntu_1.0.0_all.deb
```

APT sẽ giải quyết xung đột với `snapd`; các dependency chưa có trên máy vẫn cần nguồn APT hoạt động. Gói không purge dữ liệu Snap cũ. Nếu muốn dọn dữ liệu sau khi đã xác nhận không còn cần rollback:

```sh
sudo apt purge snapd
sudo apt autoremove --purge
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

`repo/build-repo.sh` tạo các index `binary-ARCH`, `Release` và chữ ký `InRelease`/`Release.gpg`. Script sẽ dừng nếu thiếu `.deb` hoặc secret GPG key. Ví dụ cho amd64 và arm64:

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

Bản đầu nhắm Ubuntu 24.04 `noble` và Ubuntu 22.04 `jammy`, kiến trúc `amd64` và `arm64`. Cần build/test riêng cho từng Ubuntu release và kiến trúc; không dùng metadata `noble` cho `jammy`.
