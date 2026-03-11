#!/usr/bin/env bash
# Останавливаем выполнение при ошибках и неинициализированных переменных.
set -euo pipefail

# Публичные цели для базовой проверки связности.
TARGETS=("8.8.8.8" "1.1.1.1")

echo "=== Host and Time ==="
# Показываем имя хоста, где выполняется диагностика.
hostname
# Фиксируем UTC-время запуска для корреляции с логами.
date -u

echo
echo "=== Interface Summary ==="
# Кратко выводим интерфейсы и IP-адреса.
ip -br addr

echo
echo "=== Routing Table (main) ==="
# Проверяем маршрутную таблицу main.
ip route show table main

echo
echo "=== Socket Summary ==="
# Смотрим общее состояние сокетов TCP/UDP.
ss -s

echo
echo "=== Connectivity Checks ==="
for target in "${TARGETS[@]}"; do
  echo "Ping ${target}"
  # Проверяем доступность внешних целей, не прерывая скрипт при локальном сбое.
  ping -c 4 -W 2 "${target}" || true
done

echo
echo "=== Traceroute (if available) ==="
if command -v traceroute >/dev/null 2>&1; then
  # Показываем маршрут до внешней цели для быстрой локализации проблем по пути.
  traceroute -m 8 8.8.8.8 || true
else
  echo "traceroute not installed"
fi

echo
echo "Health check complete"
