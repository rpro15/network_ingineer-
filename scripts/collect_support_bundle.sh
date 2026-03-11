#!/usr/bin/env bash
# Строгий режим: падение при ошибках и неинициализированных переменных.
set -euo pipefail

# Параметры для целевого инцидента.
TARGET=""
DNS_NAME=""

usage() {
  cat <<'EOF'
Usage: collect_support_bundle.sh [--target <host-or-ip>] [--dns <name>] [--help]

Options:
  --target  Целевой сервер/узел для доп. сетевых проверок.
  --dns     DNS-имя для проверки резолва через dig.
  --help    Показать справку.
EOF
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
    --dns)
      DNS_NAME="${2:-}"
      if [[ -z "${DNS_NAME}" ]]; then
        echo "Error: --dns requires a value"
        exit 1
      fi
      shift 2
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

# Папка с таймстемпом для артефактов инцидента.
OUT_DIR="support_bundle_$(date -u +%Y%m%d_%H%M%S)"
mkdir -p "${OUT_DIR}"

# Унифицированный сбор вывода команды в отдельный файл.
run_cmd() {
  local name="$1"
  shift
  {
    # Сохраняем команду в заголовке файла для воспроизводимости.
    echo "# Command: $*"
    "$@"
  } >"${OUT_DIR}/${name}.txt" 2>&1 || true
}

# Базовая информация о хосте и времени.
run_cmd host_uname uname -a
run_cmd host_date date -u
# Сетевое состояние: адреса, маршруты, сокеты.
run_cmd net_ip_addr ip addr
run_cmd net_ip_route ip route
run_cmd net_ss ss -s
# Подробный список listening-портов и процессов.
run_cmd net_ss_listen ss -tulpn
# Системные сообщения ядра (может помочь при драйверных/линк-проблемах).
run_cmd net_dmesg dmesg

if [[ -n "${TARGET}" ]]; then
  # Базовая проверка достижимости целевого узла.
  run_cmd target_ping ping -c 4 -W 2 "${TARGET}"

  if command -v traceroute >/dev/null 2>&1; then
    # Трассировка маршрута до целевого узла.
    run_cmd target_traceroute traceroute -m 8 "${TARGET}"
  fi

  if command -v mtr >/dev/null 2>&1; then
    # mtr-отчет по пути до целевого узла.
    run_cmd target_mtr mtr -r -c 10 --report-wide "${TARGET}"
  fi
fi

if command -v tcpdump >/dev/null 2>&1; then
  # Версия tcpdump для понимания инструментального окружения.
  run_cmd tool_tcpdump_version tcpdump --version
fi

if command -v mtr >/dev/null 2>&1; then
  # Версия mtr для диагностики маршрутизации/потерь.
  run_cmd tool_mtr_version mtr --version
fi

if command -v dig >/dev/null 2>&1; then
  # Проверяем DNS-резолв имени (если передан параметр --dns).
  if [[ -n "${DNS_NAME}" ]]; then
    run_cmd dns_dig_target dig +short "${DNS_NAME}"
  fi

  # Версия dig для контекста окружения.
  run_cmd tool_dig_version dig -v
fi

echo "Support bundle created: ${OUT_DIR}"
