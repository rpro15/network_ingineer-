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

## Запуск в Linux

```bash
chmod +x scripts/*.sh
./scripts/net_health_check.sh
./scripts/run_dpi_smoke.sh
./scripts/run_dpi_smoke.sh --target 10.10.0.15 --count 5 --timeout 2
./scripts/run_dpi_smoke.sh --target app.internal.local --check-public
./scripts/run_dpi_smoke.sh --target 10.10.0.15 --strict-gateway
./scripts/collect_support_bundle.sh
```

## Запуск из Windows через WSL

```powershell
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && chmod +x scripts/*.sh && ./scripts/net_health_check.sh'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh --target 10.10.0.15 --count 5 --timeout 2'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh --target app.internal.local --check-public'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh --target 10.10.0.15 --strict-gateway'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/collect_support_bundle.sh'
```

## Что должно появиться

- после smoke: папка `smoke_result_YYYYMMDD_HHMMSS`
- после support bundle: папка `support_bundle_YYYYMMDD_HHMMSS`

## Как использовать в L3-инциденте

1. Запустить triage на affected ноде с `--target`.
2. Проверить `smoke_summary.md` и `ping_*.txt`.
3. При `FAIL` приложить папку в тикет и перейти к protocol-specific диагностике.
