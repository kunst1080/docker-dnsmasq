docker-dnsmasq
===

Dockerfile for dnsmasq and a setting example.
You can run a dnsmasq container and test it's behaviors.

## Overview

### How to build a dnsmasq container

```bash
make build-dnsmasq
```

### How to test

```bash
make build-all
make up
make test
make down
```

## What I could and could not do of the dnsmasq in docker-compose

### What I could
- Assign a domain to an IP address 
    - Both FQDN and wildcard domain are OK
- Assign a CNAME to a domain
- Assign a domain to a container
    - Both using name and using IP address are OK

### What I could not do and alternatives
- Assign a wildcard domain to a container using container name
    - Once set static IP to the container, you can assign a wildcard domain to the IP address

## Details of example

The `docker-compose.yml` has 3 containers.

- dnsmasq: static IP address - 10.0.9.9
- dnsclient: any IP address - maybe 10.0.9.2
- other-container: static IP address - 10.0.9.10

The "dnsmasq" container has some settings in `docker-compose.yml` using command-line.

- domain `*.localnet` is resolved to 10.0.7.1
- domain `test.localnet` is resolved to 10.0.7.2
- domain `cname.test` is resolved to extra.host
- domain `extra.host` is resolved to 10.0.7.3
    - The entry `10.0.7.3	extra.host` is written to "/etc/hosts" by `extra_hosts` setting.
- domain `hogehoge.test` is resolved to IP address of the "dnsclient" container
- domain `*.other-container.test` is resolved to 10.0.9.10 which is the "other-container" container
