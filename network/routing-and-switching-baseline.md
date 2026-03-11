# Базовые проверки маршрутизации и коммутации

## Цель

Определить baseline-проверки L2/L3 до старта DPI-тестирования.

## L2 baseline

- trunk пропускает только ожидаемые VLAN
- роли root/secondary root в STP определены и стабильны
- LACP-бандлы в корректном состоянии

### Команды L2-проверки

- `show vlan brief`
- `show interfaces trunk`
- `show spanning-tree`
- `show etherchannel summary`

## L3 baseline

- OSPF-соседства `FULL`
- BGP-сессии `Established`, префиксы в ожидаемых диапазонах
- IS-IS-соседства стабильны (если используется)
- приоритет маршрутов соответствует failover-политике

### Команды L3-проверки

- `show ip ospf neighbor`
- `show ip route ospf`
- `show bgp ipv4 unicast summary`
- `show bgp ipv4 unicast`
- `show isis neighbors`
- `show isis database`

## MPLS baseline (если используется)

- LDP/label adjacency в ожидаемом состоянии
- label forwarding path согласован с проектом

### Команды MPLS-проверки

- `show mpls ldp neighbor`
- `show mpls forwarding-table`

## QoS и H-QoS baseline

- классы трафика корректно маппятся по DSCP/ACL
- приоритетная очередь не вызывает starvation default-класса
- parent/child-политики соответствуют расчетным rate-limit

### Команды QoS-проверки

- `show policy-map interface <if-name>`
- `show class-map`
- `show qos interface <if-name>`

## Multicast baseline

- IGMP join виден на принимающей стороне
- PIM-соседства и RP-путь стабильны

### Команды multicast-проверки

- `show ip igmp groups`
- `show ip pim neighbor`
- `show ip mroute`

## Типовые причины проблем

- рассинхрон STP после change-window
- некорректная BGP/route-policy фильтрация сервисных префиксов
- ошибка привязки QoS-политики к egress интерфейсу
- нестабильный RP/таймеры multicast

