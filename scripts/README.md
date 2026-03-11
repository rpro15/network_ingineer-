# Скрипты: запуск и назначение

## Список

- `net_health_check.sh` - базовая проверка сетевого состояния
- `run_dpi_smoke.sh` - быстрый smoke-прогон с сохранением evidence
- `collect_support_bundle.sh` - сбор артефактов для эскалации

## Запуск в Linux

```bash
chmod +x scripts/*.sh
./scripts/net_health_check.sh
./scripts/run_dpi_smoke.sh
./scripts/collect_support_bundle.sh
```

## Запуск из Windows через WSL

```powershell
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && chmod +x scripts/*.sh && ./scripts/net_health_check.sh'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/collect_support_bundle.sh'
```

## Что должно появиться

- после smoke: папка `smoke_result_YYYYMMDD_HHMMSS`
- после support bundle: папка `support_bundle_YYYYMMDD_HHMMSS`
