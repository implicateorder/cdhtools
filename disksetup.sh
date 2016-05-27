#!/bin/sh

count=1
for i in `cat /var/tmp/disks `; do 
    parted --script $i mklabel gpt mkpart primary 0GB 4096GB
    mkfs.ext4 -E lazy_itable_init=1 -m0 -O sparse_super,dir_index,extent,has_journal ${i}1
    tune2fs -i0 -c0 ${i}1
    echo "${i}1 /data/${count} ext4 noatime,nodiratime 0 0" |tee -a /etc/fstab
    mkdir -p /data/${count}
    mount /data/${count}
    count=$((count + 1))
done


