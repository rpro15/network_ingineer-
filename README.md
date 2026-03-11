# Портфолио Network Engineer (DPI)

Практический проект-портфолио под вакансию инженера по сетевым решениям (DPI).

Основной фокус:

- инсталляция и сопровождение сетевого оборудования
- проектирование тестовых стендов
- методики тестирования (manual + smoke automation)
- диагностика и устранение сетевых проблем
- поддержка клиентов и качественная эскалация

## Оглавление

- [Коротко о проекте](#коротко-о-проекте)
- [Связь с требованиями вакансии](#связь-с-требованиями-вакансии)
- [Стек и технологии](#стек-и-технологии)
- [Быстрый старт](#быстрый-старт)
- [Структура репозитория](#структура-репозитория)
- [5-минутный маршрут для интервьюера](#5-минутный-маршрут-для-интервьюера)
- [Подготовка к собеседованию](#подготовка-к-собеседованию)
- [Важно перед публикацией](#важно-перед-публикацией)

## Коротко о проекте

Репозиторий демонстрирует базовую инженерную зрелость по сетевому направлению:

- L2/L3: `VLAN`, `Q-in-Q`, `STP`, `LACP`, `OSPF`, `BGP`, `IS-IS` (на уровне проверки)
- понимание `QoS/H-QoS`, `Multicast` (`IGMP/PIM`)
- подход к качеству DPI-сигнатур: точность, false positive, регресс
- практический troubleshooting-процесс и runbook-дисциплина

## Связь с требованиями вакансии

- Инсталляция/настройка/сопровождение: `network/`, `docs/runbook-first-response.md`
- Тестовые стенды и ПНР: `network/lab-topology.md`, `docs/quick-start-checklist.md`
- Методики тестирования: `network/dpi-signature-validation-method.md`, `tests/`
- Поиск и устранение неполадок: `docs/troubleshooting-case-study.md`
- Техническая поддержка клиентов: `docs/customer-support-ticket-template.md`, `scripts/collect_support_bundle.sh`

## Стек и технологии

- Linux: базовая диагностика и сбор evidence
- Сети: OSPF/BGP/IS-IS, VLAN/Q-in-Q/STP/LACP, QoS/H-QoS, IGMP/PIM
- Инструменты: `ip`, `ss`, `tcpdump`, `tshark`, `mtr`, `nmap`
- Bash-скрипты для smoke-проверок и support bundle

## Быстрый старт

1. Открыть `docs/quick-start-checklist.md`.
2. Прогнать `scripts/net_health_check.sh`.
3. Прогнать `scripts/run_dpi_smoke.sh`.
4. Сверить результат с `tests/regression-checklist.md`.
5. Заполнить `tests/dpi-test-report-template.md`.

## Структура репозитория

- `network/lab-topology.md` - логическая схема и зоны стенда
- `network/routing-and-switching-baseline.md` - baseline для L2/L3
- `network/dpi-signature-validation-method.md` - методика валидации DPI
- `tests/dpi-test-cases.md` - матрица тест-кейсов DPI
- `tests/regression-checklist.md` - чек-лист регрессии перед релизом
- `tests/dpi-test-report-template.md` - шаблон итогового отчета по прогону
- `docs/runbook-first-response.md` - runbook первичной реакции на инцидент
- `docs/troubleshooting-case-study.md` - пример расследования инцидента
- `docs/release-readiness-report-template.md` - шаблон release readiness отчета
- `docs/project-readiness-status.md` - текущий статус готовности проекта
- `scripts/net_health_check.sh` - сетевой health-check
- `scripts/run_dpi_smoke.sh` - L3 triage smoke для быстрой локализации инцидента
- `scripts/collect_support_bundle.sh` - сбор артефактов для эскалации
- `interview/ready-answers-junior.md` - готовые ответы под junior-профиль
- `interview/interview-cheatsheet-1page.md` - 1-страничная шпаргалка перед звонком

## 5-минутный маршрут для интервьюера

1. `README.md`
2. `network/dpi-signature-validation-method.md`
3. `tests/dpi-test-cases.md`
4. `docs/troubleshooting-case-study.md`
5. `interview/ready-answers-junior.md`

## Подготовка к собеседованию

- Основные ответы: `interview/ready-answers-junior.md`
- Вопросы тимлиду: `interview/questions-to-teamlead.md`
- Самопрезентация: `interview/self-intro-90-seconds.md`
- Шпаргалка 1 страница: `interview/interview-cheatsheet-1page.md`

## Важно перед публикацией

- Удалить чувствительные данные и реальные реквизиты.
- Проверить `docs/pre-publish-checklist.md`.
- Оставить только обезличенные примеры.
