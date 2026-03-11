# Lab Topology (Reference)

## Goal

Provide a repeatable topology for validating routing, switching, and DPI behavior before deployment to partner/customer sites.

## Logical Zones

- `MGMT`: management subnet for devices and jump host
- `CORE`: transit and control-plane segment
- `SERVICE`: services used for validation (DNS, collector, test apps)
- `CLIENT`: synthetic user and traffic generators

## Example Address Plan

- `MGMT`: `10.10.0.0/24`
- `CORE`: `10.20.0.0/24`
- `SERVICE`: `10.30.0.0/24`
- `CLIENT`: `10.40.0.0/24`

## Traffic Paths to Validate

1. `CLIENT -> SERVICE` application traffic over routed path
2. `CLIENT -> INTERNET-SIM` path with policy and QoS controls
3. `CLIENT-MULTICAST` to group distribution path using IGMP/PIM

## Device Roles

- `edge-r1`: edge and BGP policy boundary
- `core-r1`: internal OSPF area and service reachability
- `sw1`: access switching with VLAN trunking and LACP uplinks
- `dpi-node`: receives mirrored traffic or inline path depending on scenario

## Validation Points

- Reachability and convergence after link flap
- VLAN isolation and trunk consistency
- Route policy correctness for preferred and backup paths
- QoS class mapping under load
- DPI signature detection accuracy and false positive control
