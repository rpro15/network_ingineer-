# Скрипты: запуск и назначение

## Список

- `net_health_check.sh` - базовая проверка сетевого состояния
- `run_dpi_smoke.sh` - L3 triage smoke: быстрая локализация и evidence для инцидента
- `collect_support_bundle.sh` - сбор артефактов для эскалации

## Опции `run_dpi_smoke.sh`

- `--target <host-or-ip>` - проверка целевого сервера/узла (рекомендуется)
- `--count <n>` - количество ping-пакетов (по умолчанию `4`)
- `--timeout <sec>` - timeout ping (по умолчанию `2`)
- `--check-public` - добавить опциональную проверку до `8.8.8.8`
- `--strict-gateway` - считать недоступность default gateway критической ошибкой
- `--help` - справка

Дополнительно скрипт сохраняет:

- `ss -tulpn` (listening-порты)
- `traceroute` и `mtr` до target (если утилиты доступны)
- `dig` для target, если target задан как hostname

## Опции `collect_support_bundle.sh`

- `--target <host-or-ip>` - доп. проверка до конкретного узла (`ping`/`traceroute`/`mtr`)
- `--dns <name>` - проверка DNS-резолва имени через `dig`
- `--help` - справка

## Запуск в Linux

```bash
chmod +x scripts/*.sh
./scripts/net_health_check.sh
./scripts/run_dpi_smoke.sh
./scripts/run_dpi_smoke.sh --target 10.10.0.15 --count 5 --timeout 2
./scripts/run_dpi_smoke.sh --target app.internal.local --check-public
./scripts/run_dpi_smoke.sh --target 10.10.0.15 --strict-gateway
./scripts/run_dpi_smoke.sh --target app.internal.local
./scripts/collect_support_bundle.sh
./scripts/collect_support_bundle.sh --target 10.10.0.15 --dns app.internal.local
```

## Запуск из Windows через WSL

```powershell
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && chmod +x scripts/*.sh && ./scripts/net_health_check.sh'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh --target 10.10.0.15 --count 5 --timeout 2'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh --target app.internal.local --check-public'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh --target 10.10.0.15 --strict-gateway'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/collect_support_bundle.sh'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/collect_support_bundle.sh --target 10.10.0.15 --dns app.internal.local'
```

## Что должно появиться

- после L3 triage: папка `proverka_l3_YYYYMMDD_HHMMSS`
- после support bundle: папка `support_bundle_YYYYMMDD_HHMMSS`

## Как использовать в L3-инциденте

1. Запустить triage на affected ноде с `--target`.
2. Проверить `otchet_l3_triage.md` и `ping_*.txt`.
3. Проверить `mtr_*`, `traceroute_*`, `dig_*` и `socket_listen.txt`.
4. При `FAIL` приложить папку в тикет и перейти к protocol-specific диагностике.

После выполнения скрипт выводит короткий итог в консоль:

- `[ИТОГ] L3 triage: PASS` или `FAIL`
- `[ПРЕДУПРЕЖДЕНИЯ] ...` (если есть)
- `[ОТЧЕТ] <путь>/otchet_l3_triage.md`
