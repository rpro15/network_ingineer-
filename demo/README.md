# Сценарий демо (2-3 минуты)

## Цель

Показать практическую готовность к роли Network Engineer в DPI-направлении.

## Последовательность показа

1. Открыть `README.md` и за 20-30 секунд объяснить ценность проекта.
2. Показать `network/lab-topology.md` и ключевые пути трафика.
3. Запустить `scripts/net_health_check.sh` и коротко прокомментировать результат.
4. Показать `scripts/run_dpi_smoke.sh` и папку с generated evidence.
5. Открыть `tests/dpi-test-cases.md` и `tests/dpi-test-report-template.md`.
6. Открыть `docs/troubleshooting-case-study.md` как пример расследования.
7. Закрыть демо коротким выводом: что проверено, что зафиксировано, какие следующие шаги.

## Команды (Windows + WSL)

```powershell
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && chmod +x scripts/*.sh && ./scripts/net_health_check.sh'
wsl bash -lc 'cd /mnt/c/Users/rpro1/my_projects/network_ingineer- && ./scripts/run_dpi_smoke.sh'
```

## Чек-лист качества

- 1080p
- читабельный шрифт терминала
- без паролей и внутренней чувствительной информации
- без реальных данных клиента
