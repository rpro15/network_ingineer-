#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="support_bundle_$(date -u +%Y%m%d_%H%M%S)"
mkdir -p "${OUT_DIR}"

run_cmd() {
  local name="$1"
  shift
  {
    echo "# Command: $*"
    "$@"
  } >"${OUT_DIR}/${name}.txt" 2>&1 || true
}

run_cmd host_uname uname -a
run_cmd host_date date -u
run_cmd net_ip_addr ip addr
run_cmd net_ip_route ip route
run_cmd net_ss ss -s
run_cmd net_dmesg dmesg

if command -v tcpdump >/dev/null 2>&1; then
  run_cmd tool_tcpdump_version tcpdump --version
fi

if command -v mtr >/dev/null 2>&1; then
  run_cmd tool_mtr_version mtr --version
fi

echo "Support bundle created: ${OUT_DIR}"
