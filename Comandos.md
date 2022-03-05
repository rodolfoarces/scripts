# RedHat/CentOS

# Networking

Comando de una sola línea para setear la configuración de red de una interfaz en las distribuciones de GNU/Linux que usan nmcli

```
sudo nmcli connection modify ens192 ipv4.address "10.0.255.3/24" ipv4.dns "10.0.255.2" ipv4.gateway "10.0.255.254"  && sudo nmcli connection up ens192
```

En este ejemplo la interfaz es **ens192**, el resto de los parámetros son autoexplicativos.
