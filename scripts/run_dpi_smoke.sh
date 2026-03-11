#!/usr/bin/env bash
set -euo pipefail

TARGET=""
PING_COUNT=4
PING_TIMEOUT=2
CHECK_PUBLIC=0
PUBLIC_TARGET="8.8.8.8"
STRICT_GATEWAY=0

L3_RESULT="PASS"
FAIL_REASONS=()
WARNINGS=()
CHECK_HOST_INFO="[ ]"
CHECK_IF_ROUTE="[ ]"
CHECK_SOCKET="[ ]"
CHECK_GATEWAY="[ ]"
CHECK_TARGET="[ ]"
CHECK_PUBLIC_CONNECTIVITY="[ ]"
CHECK_TOOLING="[ ]"

usage() {
  cat <<'EOF'
Usage: run_dpi_smoke.sh [--target <host-or-ip>] [--count <n>] [--timeout <sec>] [--check-public] [--strict-gateway] [--help]

Options:
  --target   Target server/host for incident check (recommended for L3 triage).
  --count    Number of ICMP probes for ping (default: 4).
  --timeout  Per-probe timeout in seconds (default: 2).
  --check-public  Also check connectivity to 8.8.8.8 (optional).
  --strict-gateway  Fail run if default gateway ping fails.
  --help     Show this help message.
EOF
}

mark_fail() {
  L3_RESULT="FAIL"
  FAIL_REASONS+=("$1")
}

add_warning() {
  WARNINGS+=("$1")
}

sanitize_name() {
  echo "$1" | tr -c '[:alnum:]' '_'
}

save_cmd() {
  local name="$1"
  shift
  {
    echo "# $*"
    "$@"
  } >"${OUT_DIR}/${name}.txt" 2>&1 || true
}

run_ping_check() {
  local label="$1"
  local host="$2"
  local required="$3"
  local outfile="${OUT_DIR}/ping_$(sanitize_name "${label}").txt"
  local rc

  set +e
  {
    echo "# ping -c ${PING_COUNT} -W ${PING_TIMEOUT} ${host}"
    ping -c "${PING_COUNT}" -W "${PING_TIMEOUT}" "${host}"
  } >"${outfile}" 2>&1
  rc=$?
  set -e

  if [[ ${rc} -ne 0 ]]; then
    if [[ "${required}" == "required" ]]; then
      mark_fail "ping to ${host} failed"
    fi
    return 1
  fi

  local loss
  loss=$(awk -F',' '/packet loss/ {gsub(/[^0-9]/, "", $3); print $3}' "${outfile}" | tail -n1 || true)
  if [[ -n "${loss}" ]] && [[ "${loss}" -gt 0 ]] && [[ "${required}" == "required" ]]; then
    mark_fail "packet loss to ${host}: ${loss}%"
    return 1
  fi

  return 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="${2:-}"
      if [[ -z "${TARGET}" ]]; then
        echo "Error: --target requires a value"
        exit 1
      fi
      shift 2
      ;;
    --count)
      PING_COUNT="${2:-}"
      if ! [[ "${PING_COUNT}" =~ ^[0-9]+$ ]] || [[ "${PING_COUNT}" -lt 1 ]]; then
        echo "Error: --count must be a positive integer"
        exit 1
      fi
      shift 2
      ;;
    --timeout)
      PING_TIMEOUT="${2:-}"
      if ! [[ "${PING_TIMEOUT}" =~ ^[0-9]+$ ]] || [[ "${PING_TIMEOUT}" -lt 1 ]]; then
        echo "Error: --timeout must be a positive integer"
        exit 1
      fi
      shift 2
      ;;
    --check-public)
      CHECK_PUBLIC=1
      shift
      ;;
    --strict-gateway)
      STRICT_GATEWAY=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

OUT_DIR="smoke_result_$(date -u +%Y%m%d_%H%M%S)"
mkdir -p "${OUT_DIR}"

log() {
  echo "[$(date -u +%H:%M:%S)] $*"
}

log "Start L3 triage smoke run"

save_cmd host_uname uname -a
save_cmd host_date date -u
save_cmd ip_addr ip -br addr
save_cmd ip_link_stats ip -s link
save_cmd ip_route ip route
save_cmd ip_rule ip rule
save_cmd ip_neigh ip neigh
save_cmd socket_summary ss -s
CHECK_HOST_INFO="[x]"
CHECK_IF_ROUTE="[x]"
CHECK_SOCKET="[x]"

if command -v ping >/dev/null 2>&1; then
  default_gw=$(ip route | awk '/^default/ {print $3; exit}' || true)
  if [[ -n "${default_gw}" ]]; then
    gw_mode="optional"
    if [[ "${STRICT_GATEWAY}" -eq 1 ]]; then
      gw_mode="required"
    fi

    if run_ping_check "default_gw_${default_gw}" "${default_gw}" "${gw_mode}"; then
      CHECK_GATEWAY="[x]"
    else
      CHECK_GATEWAY="[ ]"
      if [[ "${STRICT_GATEWAY}" -eq 0 ]]; then
        add_warning "default gateway ${default_gw} did not reply to ICMP"
      fi
    fi
  else
    mark_fail "default gateway not found"
  fi

  if [[ -n "${TARGET}" ]]; then
    if run_ping_check "target_${TARGET}" "${TARGET}" "required"; then
      CHECK_TARGET="[x]"
    else
      CHECK_TARGET="[ ]"
    fi

    if command -v traceroute >/dev/null 2>&1; then
      save_cmd "traceroute_$(sanitize_name "${TARGET}")" traceroute -m 8 "${TARGET}"
    fi
  else
    CHECK_TARGET="[ ]"
  fi

  if [[ "${CHECK_PUBLIC}" -eq 1 ]]; then
    if run_ping_check "public_${PUBLIC_TARGET}" "${PUBLIC_TARGET}" "optional"; then
      CHECK_PUBLIC_CONNECTIVITY="[x]"
    else
      CHECK_PUBLIC_CONNECTIVITY="[ ]"
    fi
  fi
fi

if command -v tcpdump >/dev/null 2>&1; then
  save_cmd tcpdump_version tcpdump --version
fi
CHECK_TOOLING="[x]"

if [[ ${#FAIL_REASONS[@]} -eq 0 ]]; then
  FAIL_REASON_TEXT="none"
else
  FAIL_REASON_TEXT="$(printf '%s; ' "${FAIL_REASONS[@]}")"
  FAIL_REASON_TEXT="${FAIL_REASON_TEXT%; }"
fi

if [[ ${#WARNINGS[@]} -eq 0 ]]; then
  WARNING_TEXT="none"
else
  WARNING_TEXT="$(printf '%s; ' "${WARNINGS[@]}")"
  WARNING_TEXT="${WARNING_TEXT%; }"
fi

cat >"${OUT_DIR}/smoke_summary.md" <<EOF
# L3 Triage Smoke Summary

## Run Parameters

- Target: ${TARGET:-not-set}
- Ping count: ${PING_COUNT}
- Ping timeout: ${PING_TIMEOUT}
- Public check enabled: ${CHECK_PUBLIC}
- Strict gateway check: ${STRICT_GATEWAY}

## Checklist

- ${CHECK_HOST_INFO} Host info collected
- ${CHECK_IF_ROUTE} Interface and route state collected
- ${CHECK_SOCKET} Socket summary collected
- ${CHECK_GATEWAY} Default gateway connectivity checked
- ${CHECK_TARGET} Target server connectivity checked
- ${CHECK_PUBLIC_CONNECTIVITY} Optional public connectivity checked
- ${CHECK_TOOLING} Tooling availability recorded

## Decision

- L3 smoke result: ${L3_RESULT}
- Fail reasons: ${FAIL_REASON_TEXT}
- Warnings: ${WARNING_TEXT}
- Notes: 

## Next Actions

1. Attach this folder to the incident/ticket.
2. If result is FAIL, continue with protocol-specific checks (OSPF/BGP/IS-IS, ACL/QoS, DPI logs).
3. Escalate with evidence and short impact summary.

EOF

log "L3 smoke run completed: ${OUT_DIR}"
echo "Review ${OUT_DIR}/smoke_summary.md and attach evidence to ticket."
