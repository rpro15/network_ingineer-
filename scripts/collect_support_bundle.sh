#!/usr/bin/env bash
# Строгий режим: падение при ошибках и неинициализированных переменных.
set -euo pipefail

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
# Системные сообщения ядра (может помочь при драйверных/линк-проблемах).
run_cmd net_dmesg dmesg

if command -v tcpdump >/dev/null 2>&1; then
  # Версия tcpdump для понимания инструментального окружения.
  run_cmd tool_tcpdump_version tcpdump --version
fi

if command -v mtr >/dev/null 2>&1; then
  # Версия mtr для диагностики маршрутизации/потерь.
  run_cmd tool_mtr_version mtr --version
fi

echo "Support bundle created: ${OUT_DIR}"
