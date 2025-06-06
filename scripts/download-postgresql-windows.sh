#!/usr/bin/env bash
set -e

VERSION="$1"  # e.g., 10, 12, 14, 16

# Map short version to full EDB installer version
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

FILENAME="postgresql-${VERSION}-windows-x64.zip"
URL="https://get.enterprisedb.com/postgresql/postgresql-${FULL}-windows-x64-binaries.zip"

# Download
echo "Downloading $FILENAME from $URL"
curl -fSL "$URL" -o "${FILENAME}"

echo "Download completed: ${FILENAME}"
