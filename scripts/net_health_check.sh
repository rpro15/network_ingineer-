#!/usr/bin/env bash
set -euo pipefail

TARGETS=("8.8.8.8" "1.1.1.1")

echo "=== Host and Time ==="
hostname
date -u

echo
echo "=== Interface Summary ==="
ip -br addr

echo
echo "=== Routing Table (main) ==="
ip route show table main

echo
echo "=== Socket Summary ==="
ss -s

echo
echo "=== Connectivity Checks ==="
for target in "${TARGETS[@]}"; do
  echo "Ping ${target}"
  ping -c 4 -W 2 "${target}" || true
done

echo
echo "=== Traceroute (if available) ==="
if command -v traceroute >/dev/null 2>&1; then
  traceroute -m 8 8.8.8.8 || true
else
  echo "traceroute not installed"
fi

echo
echo "Health check complete"
