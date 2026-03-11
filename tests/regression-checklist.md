# Регрессионный чек-лист

Используется перед каждым candidate release.

## Control Plane

- [ ] OSPF-соседства стабильны
- [ ] BGP-пиринги в expected-состоянии
- [ ] IS-IS-соседства проверены (если используется)
- [ ] failover маршрутизации протестирован (primary down/up)

## Data Plane

- [ ] VLAN-сегментация подтверждена
- [ ] LACP-бандл в здоровом состоянии
- [ ] QoS/H-QoS политики применены корректно
- [ ] multicast join/leave ведет себя ожидаемо
- [ ] MPLS forwarding проверен (если используется)

## DPI

- [ ] positive detection проходит целевой порог
- [ ] false positive в допустимом диапазоне
- [ ] протестированы граничные кейсы (fragmentation/retransmission/mixed)
- [ ] counters/logs выгружены в evidence

## Operations and Support

- [ ] приложен результат `scripts/net_health_check.sh`
- [ ] проверен `scripts/collect_support_bundle.sh`
- [ ] заполнен `tests/dpi-test-report-template.md`
- [ ] обновлен инцидентный шаблон для текущего релиза

