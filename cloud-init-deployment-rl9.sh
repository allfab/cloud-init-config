#!/bin/bash

# mkdir -pv /var/lib/libvirt/images/rl9/{user-data,disk}
# virsh destroy RL9 && virsh undefine --domain RL9 --remove-all-storage --nvram

rm -f /var/lib/libvirt/images/rl9/disk/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2
cp /home/allfab/downloads/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 /var/lib/libvirt/images/rl9/disk

virt-install \
    --memory 2048 \
    --vcpus 2 \
    --name RL9 \
    --cloud-init 'user-data=/var/lib/libvirt/images/rl9/user-data/05-cloud-config.yaml' \
    --disk /var/lib/libvirt/images/rl9/disk/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2,device=disk,bus=virtio,format=qcow2 \
    --os-variant rocky9 \
    --virt-type kvm \
    --graphics none \
    --boot uefi,loader_secure=no \
    --import \
    --autoconsole none

    # % virt-install 
    # --memory 8192 
    # --vcpus 4 
    # --cloud-init 'user-data=/var/lib/libvirt/images/data' 
    # --os-variant rocky9 
    # --name testsystem.angelsofclockwork.net 
    # --disk $PWD/genclo9.5.qcow2 
    # --import 
    # --network bridge=br1000 
    # --boot uefi,loader_secure=no 
    # --autoconsole none
    # --disk /home/allfab/downloads/my-iso.iso,device=cdrom \