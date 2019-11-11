#!/bin/bash

## Flush de Reglas

iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -Z
iptables -t nat -X

## Habilitamos el Forward
echo "1" > /proc/sys/net/ipv4/ip_forward

## Politicas

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

## Loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

## Reglas Locales - Navegacion
iptables -A OUTPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -m state --state NEW -j ACCEPT

## IN SSH desde Cliente2
iptables -A INPUT -s 192.168.20.2/32 -i eth2 -p tcp --dport 22 -m state --state NEW -j ACCEPT

## FW Al WebServer desde Cliente4
iptables -A FORWARD -i eth2 -o eth1 -s 192.168.20.4/32 -d 192.168.10.3/32 -p tcp --dport 8080 -m state --state NEW -j ACCEPT

## Salida a Internet solo desde Cliente3
iptables -A FORWARD -s 192.168.20.3/32 -i eth2 -o eth0 -m state --state NEW -j ACCEPT

## Masquerade
iptables -t nat -A POSTROUTING -s 192.168.20.3/32 -o eth0 -j MASQUERADE

## Permitimos las conexiones Establecidas y Relacionadas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
