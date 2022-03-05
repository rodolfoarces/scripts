## SSH

Utilizar una sesión de SSH como proxy para otra sesión en un host no nateado (interno) de SSH

```
ssh -i ~/.ssh/id_rsa.1 -J user1@host_externo user2@host_interno
```

Tunel SSH para acceder a hosts internos con puertos no nateados

```
ssh -i ~/.ssh/id_rsa.1 user1@host_externo -L 8443:192.168.1.2:443
```

Local port: 8443

Remote IP: 192.168.1.1

Remote port: 443

Para acceder al host se conecta a https://localhost:8443 y esto genera un túnel a https://192.168.1.1:443

## Git

Utilizar una llave privada en particular para realizar comandos de git en un repositorio

```
GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa.1 -o IdentitiesOnly=yes' git push origin dev
```

[Más información](https://github.com/rarce-uaa/intro-devops/blob/main/unidades/01/Anotaciones.md)

## Networking

Comando de una sola línea para setear la configuración de red de una interfaz en las distribuciones de GNU/Linux que usan **nmcli**

```
sudo nmcli connection modify ens192 ipv4.address "10.0.255.3/24" ipv4.dns "10.0.255.2" ipv4.gateway "10.0.255.254"  && sudo nmcli connection up ens192
```

En este ejemplo la interfaz es **ens192**, el resto de los parámetros son autoexplicativos.
