#!/bin/sh
set -eu

# Replace these values before publishing this script. They may also be
# supplied as environment variables for testing or private deployments.
REPO_URL=${REPO_URL:-https://YOUR-USER.github.io/tinhmenhdo-ubuntu}
REPO_KEY_URL=${REPO_KEY_URL:-$REPO_URL/public.key}
REPO_KEY_FINGERPRINT=${REPO_KEY_FINGERPRINT:-REPLACE_WITH_REPO_KEY_FINGERPRINT}
REPO_ARCHES=${REPO_ARCHES:-amd64 arm64}
REPO_KEYRING=/etc/apt/keyrings/tinhmenhdo-ubuntu.gpg
REPO_SOURCE=/etc/apt/sources.list.d/tinhmenhdo-ubuntu.sources

case "$REPO_URL" in
    https://*) ;;
    *) echo "REPO_URL must use HTTPS" >&2; exit 1 ;;
esac

case "$REPO_KEY_URL" in
    https://*) ;;
    *) echo "REPO_KEY_URL must use HTTPS" >&2; exit 1 ;;
esac

if [ "$REPO_URL" = "https://YOUR-USER.github.io/tinhmenhdo-ubuntu" ] \
    || [ "$REPO_KEY_FINGERPRINT" = REPLACE_WITH_REPO_KEY_FINGERPRINT ]; then
    echo "Set the real repository URL and GPG fingerprint before publishing" >&2
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root: sudo $0" >&2
    exit 1
fi

if [ ! -r /etc/os-release ]; then
    echo "Cannot identify the operating system" >&2
    exit 1
fi
. /etc/os-release

for command_name in curl gpg apt-get awk install mktemp; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "Required command not found: $command_name" >&2
        exit 1
    fi
done

if [ "${ID:-}" != ubuntu ]; then
    echo "This installer supports Ubuntu only" >&2
    exit 1
fi

case "${VERSION_CODENAME:-}" in
    noble|jammy) CODENAME=$VERSION_CODENAME ;;
    *)
        echo "Unsupported Ubuntu codename: ${VERSION_CODENAME:-unknown}" >&2
        echo "Build and publish a repository for this Ubuntu release first." >&2
        exit 1
        ;;
esac

install -d -m 0755 /etc/apt/keyrings
tmp_key=$(mktemp)
tmp_keyring=$(mktemp)
tmp_source=$(mktemp)
trap 'rm -f "$tmp_key" "$tmp_keyring" "$tmp_source"' EXIT INT TERM
curl --fail --silent --show-error --location "$REPO_KEY_URL" -o "$tmp_key"

actual_fingerprint=$(gpg --show-keys --with-colons "$tmp_key" \
    | awk -F: '$1 == "fpr" {print toupper($10); exit}')
expected_fingerprint=$(printf '%s' "$REPO_KEY_FINGERPRINT" \
    | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
case "$expected_fingerprint" in
    (*[!0-9A-F]*|"")
        echo "REPO_KEY_FINGERPRINT must be a hexadecimal GPG fingerprint" >&2
        exit 1
        ;;
esac
if [ -z "$actual_fingerprint" ] || [ "$actual_fingerprint" != "$expected_fingerprint" ]; then
    echo "Repository key fingerprint mismatch; refusing to configure APT" >&2
    exit 1
fi

gpg --dearmor --yes -o "$tmp_keyring" "$tmp_key"
chmod 0644 "$tmp_keyring"
install -m 0644 "$tmp_keyring" "$REPO_KEYRING"

cat > "$tmp_source" <<EOF
Types: deb
URIs: $REPO_URL
Suites: $CODENAME
Components: main
Architectures: $REPO_ARCHES
Signed-By: $REPO_KEYRING
EOF
install -m 0644 "$tmp_source" "$REPO_SOURCE"

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install --yes tinhmenhdo-ubuntu

echo "TinhMenhDo Ubuntu installed for Ubuntu $CODENAME. Log out and select the GNOME session, or reboot."
