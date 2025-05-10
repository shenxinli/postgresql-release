#!/usr/bin/env bash
set -e

VERSION="$1"
OS="$2"
ARCH="$3"

FILENAME="postgresql-${VERSION}-${OS}-${ARCH}-binaries"
EXT="tar.gz"
[ "$OS" == "windows" ] && EXT="zip"

URL="https://get.enterprisedb.com/postgresql/${FILENAME}.${EXT}"

if [[ "$OS" == "linux" && "$ARCH" == "arm64" ]]; then
  echo "ARM64 builds from source, skipping download."
  exit 0
fi

echo "Downloading from $URL..."
curl -fSL "$URL" -o "package.${EXT}"
mkdir -p postgresql
cd postgresql
if [[ "$EXT" == "zip" ]]; then
  unzip ../package.${EXT}
else
  tar -xf ../package.${EXT} --strip-components=1
fi
