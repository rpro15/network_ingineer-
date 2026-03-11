#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="smoke_result_$(date -u +%Y%m%d_%H%M%S)"
mkdir -p "${OUT_DIR}"

log() {
  echo "[$(date -u +%H:%M:%S)] $*"
}

save_cmd() {
  local name="$1"
  shift
  {
    echo "# $*"
    "$@"
  } >"${OUT_DIR}/${name}.txt" 2>&1 || true
}

log "Start DPI smoke run"

save_cmd host_uname uname -a
save_cmd host_date date -u
save_cmd ip_addr ip -br addr
save_cmd ip_route ip route
save_cmd socket_summary ss -s

if command -v ping >/dev/null 2>&1; then
  save_cmd ping_8_8_8_8 ping -c 4 -W 2 8.8.8.8
fi

if command -v tcpdump >/dev/null 2>&1; then
  save_cmd tcpdump_version tcpdump --version
fi

cat >"${OUT_DIR}/smoke_summary.md" <<'EOF'
# DPI Smoke Summary

## Checklist

- [ ] Host info collected
- [ ] Interface and route state collected
- [ ] Socket summary collected
- [ ] Connectivity check executed
- [ ] Tooling availability recorded

## Decision

- Smoke result: `PASS / FAIL`
- Notes:

EOF

log "Smoke run completed: ${OUT_DIR}"
echo "Fill ${OUT_DIR}/smoke_summary.md with final decision."
