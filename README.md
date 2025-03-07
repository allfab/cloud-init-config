# Mes configurations Cloud Init (user-data) pour le création de VMs ou d'instances avec Cloud-init

## Qu'est-ce que Cloud-init ?

Cloud-Init était au départ un projet propre à Ubuntu. Il permettait à l'époque de configurer certains paramètres par défaut comme la langue, le nom d'hôte, les clés SSH, les points de montage, etc. Il s'agit désormais d'un véritable standard de l'industrie du cloud.

## Comment ça fonctionne ?

Pour utiliser cloud-init, il faut au préalable créer un fichier de configuration `cloud-config`, dans la plupart des cas écrit en YAML. Ce fichier contient les directives qui seront exécutées lors du premier démarrage de l’instance. Il s'agit de créer un fichier de configuration (user-data) indiquant des paramètres à prendre en compte au premier démarrage.

### Mes fichiers `cloud-config`

Référence : https://cloudinit.readthedocs.io/en/latest/reference/examples.html

Si vous êtes curieux, le mot de passe haché est le suivant `Pa22word`.

Dans le fichier `cloud-config.yaml`, l'option `passwd` stocke le hachage (et non le mot de passe lui-même) du mot de passe que vous souhaitez utiliser pour cet utilisateur. Vous pouvez générer un hachage via :
```bash
mkpasswd --method=SHA-512 --rounds=4096 Pa22word
$6$rounds=4096$LRtCHGk0IrYsEBz3$8SKmYn7ITyv7OH5BXFjCvAJVMqChaCosx8YI.8dQdSujC59OkF67bT8gwpOkuykP9FkJtF4KOxtHgvmh4pUYc0
```
***La commande ci-dessus, crée à partir de `stdin`, un hachage de mot de passe SHA-512 avec 4096 tours de salage.***

#### Rocky Linux 9.5 Cloud Image

Référence : https://rockylinux.org/fr-FR/download

Voici la configuration utilisateur à déclarer avant le démarrage de la machine Cloud :
```yaml
#cloud-config
disable_root: false
packages:
  - vim-enhanced
  - sudo
  - epel-release
  - bind-utils
  - qemu-guest-agent
  - dnsmasq
runcmd:
  - - sysctl
    - -w
    - net.ipv6.conf.all.disable_ipv6=1
ssh_pwauth: True
users:
  - name: root
    passwd: $6$fgls6Nv/5eS$iozPi2/3f9SE7cR5mvTlriGkRZRSuhzFs0s6fVWzUXiL19E27hVgAo3mZwCdzlDsiUq1YRJeyPtql6FkPhMZP0
    lock_passwd: false
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA26evmemRbhTtjV9szD9SwcFW9VOD38jDuJmyYYdqoqIltDkpUqDa/V1jxLSyrizhOHrlJtUOj790cxrvInaBNP7nHIO+GwC9VH8wFi4KG/TFj3K8SfNZ24QoUY12rLiHR6hRxcT4aUGnqFHGv2WTqsW2sxz03z+W1qeMqWYJOUfkqKKs2jiz42U+0Kp9BxsFBlai/WAXrQsYC8CcpQSRKdggOMQf04CqqhXzt5Q4Cmago+Fr7HcvEnPDAaNcVtfS5DYLERcX2OVgWT3RBWhDIjD8vYCMBBCy2QUrc4ZhKZfkF9aemjnKLfLcbdpMfb+r7NwJsVQSPKcjYAJOckE8RQ== allfab@cloudinit-rockylinux
  - name: allfab
    gecos: Allfab
    passwd: $6$fgls6Nv/5eS$iozPi2/3f9SE7cR5mvTlriGkRZRSuhzFs0s6fVWzUXiL19E27hVgAo3mZwCdzlDsiUq1YRJeyPtql6FkPhMZP0
    lock_passwd: false
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA26evmemRbhTtjV9szD9SwcFW9VOD38jDuJmyYYdqoqIltDkpUqDa/V1jxLSyrizhOHrlJtUOj790cxrvInaBNP7nHIO+GwC9VH8wFi4KG/TFj3K8SfNZ24QoUY12rLiHR6hRxcT4aUGnqFHGv2WTqsW2sxz03z+W1qeMqWYJOUfkqKKs2jiz42U+0Kp9BxsFBlai/WAXrQsYC8CcpQSRKdggOMQf04CqqhXzt5Q4Cmago+Fr7HcvEnPDAaNcVtfS5DYLERcX2OVgWT3RBWhDIjD8vYCMBBCy2QUrc4ZhKZfkF9aemjnKLfLcbdpMfb+r7NwJsVQSPKcjYAJOckE8RQ== allfab@cloudinit-rockylinux
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - 192.168.10.100/24
      gateway4: 192.168.10.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 1.0.0.1
```
Il est également possible de paramétrer l'instance en DHCP :

```yaml
...
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
```
