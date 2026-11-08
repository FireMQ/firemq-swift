#!/usr/bin/env bash
# Points the package at a FireMQ release: the XCFramework URL and checksum in Package.swift,
# and the Swift sources and example from the same tag of FireMQ/firemq.
#
#   scripts/update.sh v0.1.0
set -euo pipefail

tag=${1:?usage: scripts/update.sh <tag>}
cd "$(dirname "$0")/.."
release=https://github.com/FireMQ/firemq/releases/download/$tag
raw=https://raw.githubusercontent.com/FireMQ/firemq/$tag/bindings/swift/Sources

checksum=$(curl -fsSL "$release/FireMQFFI.xcframework.zip.sha256" | cut -d' ' -f1)
[[ "$checksum" =~ ^[0-9a-f]{64}$ ]] || { echo "unexpected checksum: $checksum" >&2; exit 1; }

sed -i.bak -E \
  -e "s|url: \"[^\"]*/FireMQFFI\.xcframework\.zip\"|url: \"$release/FireMQFFI.xcframework.zip\"|" \
  -e "s|checksum: \"[0-9a-f]{64}\"|checksum: \"$checksum\"|" \
  Package.swift
rm Package.swift.bak

for file in FireMQ.swift Extensions.swift; do
  curl -fsSL "$raw/FireMQ/$file" -o "Sources/FireMQ/$file"
done
curl -fsSL "$raw/HelloFireMQ/main.swift" -o Examples/HelloFireMQ/main.swift

echo "Package.swift now uses $tag ($checksum)."
