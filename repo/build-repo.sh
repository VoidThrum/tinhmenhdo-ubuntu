#!/bin/sh
set -eu

usage() {
    echo "Usage: $0 PACKAGE-DIR OUTPUT-DIR CODENAME GPG_KEY_ID [ARCHES]" >&2
    exit 2
}

[ "$#" -ge 4 ] || usage
PACKAGE_DIR=$1
OUTPUT_DIR=$2
CODENAME=$3
GPG_KEY_ID=$4
ARCHES=${5:-amd64}

command -v apt-ftparchive >/dev/null || { echo "apt-ftparchive is required" >&2; exit 1; }
command -v gpg >/dev/null || { echo "gpg is required" >&2; exit 1; }
[ -d "$PACKAGE_DIR" ] || { echo "Package directory not found: $PACKAGE_DIR" >&2; exit 1; }
[ -n "$CODENAME" ] || { echo "Codename is required" >&2; exit 1; }
[ -n "$GPG_KEY_ID" ] || { echo "GPG key ID is required" >&2; exit 1; }
[ -n "$ARCHES" ] || { echo "At least one architecture is required" >&2; exit 1; }

set -- "$PACKAGE_DIR"/*.deb
if [ ! -f "$1" ]; then
    echo "No .deb files found in $PACKAGE_DIR" >&2
    exit 1
fi

gpg --batch --list-secret-keys "$GPG_KEY_ID" >/dev/null 2>&1 || {
    echo "Secret GPG key not found: $GPG_KEY_ID" >&2
    exit 1
}

mkdir -p "$OUTPUT_DIR/pool/main"
find "$PACKAGE_DIR" -maxdepth 1 -type f -name '*.deb' -exec cp -f {} "$OUTPUT_DIR/pool/main/" \;

# ARCHES is intentionally a whitespace-separated list, e.g. "amd64 arm64".
# shellcheck disable=SC2086
for arch in $ARCHES; do
    mkdir -p "$OUTPUT_DIR/dists/$CODENAME/main/binary-$arch"
    apt-ftparchive packages "$OUTPUT_DIR/pool/main" > "$OUTPUT_DIR/dists/$CODENAME/main/binary-$arch/Packages"
    gzip -n -9 -c "$OUTPUT_DIR/dists/$CODENAME/main/binary-$arch/Packages" > "$OUTPUT_DIR/dists/$CODENAME/main/binary-$arch/Packages.gz"
done

cat > "$OUTPUT_DIR/dists/$CODENAME/Release" <<EOF
Origin: TinhMenhDo Ubuntu
Label: TinhMenhDo Ubuntu
Suite: $CODENAME
Codename: $CODENAME
Architectures: $ARCHES
Components: main
Description: TinhMenhDo Ubuntu packages
EOF
apt-ftparchive release "$OUTPUT_DIR/dists/$CODENAME" >> "$OUTPUT_DIR/dists/$CODENAME/Release"

gpg --batch --local-user "$GPG_KEY_ID" --armor --detach-sign \
    --output "$OUTPUT_DIR/dists/$CODENAME/Release.gpg" "$OUTPUT_DIR/dists/$CODENAME/Release"
gpg --batch --local-user "$GPG_KEY_ID" --clearsign \
    --output "$OUTPUT_DIR/dists/$CODENAME/InRelease" "$OUTPUT_DIR/dists/$CODENAME/Release"

echo "Repository generated at: $OUTPUT_DIR"
