#!/usr/bin/env bash
set -e

VERSION="$1"     # e.g., 10, 12, 14, 16
ARCH="$2"        # e.g., amd64 or arm64

# Map short version to full version used in EDB URLs
case "$VERSION" in
  10) FULL="10.23-1" ;;
  11) FULL="11.6-1"  ;;
  12) FULL="12.22-1" ;;
  14) FULL="14.18-1" ;;
  16) FULL="16.9-1"  ;;
  *)
    echo "Unsupported PostgreSQL version: $VERSION"
    exit 1
    ;;
esac

# Handle architecture mapping
if [[ "$ARCH" == "amd64" ]]; then
  PLATFORM="linux-x64-binaries"
  FILENAME="postgresql-${FULL}-linux-x64-binaries.tar.gz"
  URL="https://get.enterprisedb.com/postgresql/${FILENAME}"

  mkdir -p postgresql-linux-amd64
  echo "Downloading $FILENAME from $URL"
  curl -fSL "$URL" -o "postgresql-linux-amd64/${FILENAME}"
  echo "Download completed: postgresql-linux-amd64/${FILENAME}"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi
