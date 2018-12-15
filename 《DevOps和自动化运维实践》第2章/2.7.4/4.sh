#!/bin/bash
function rg_mkfs_interac(){
    read -p "请输入您要做的RAID级别，可选择项为0|1|5|10:" raid
    read -p "请输入哪些磁盘需要并进RAID，磁盘之间请用空格格开，例如sdb sdc等" mydev
    echo $raid
    echo $mydev
    # create md0
        rg_info "Create RAID..."
        mdadm -Ss
        yes | mdadm -C /dev/md0 --level=$raid --auto=yes $mydev >/dev/null
        mdadm -D /dev/md0 >/dev/null || rg_info 58 "Create RAID /dev/md0 failed."
            # public
            partprobe /dev/$DISK_SYS 2>/dev/null
            sleep 3
            # mkfs
            for i in {${DISK_SYS}4,md0}; do
                echo -n "$MKFS /dev/$i... "
                if $MKFS /dev/$i &>/dev/null; then
                echo OK
                else
                echo failed && rg_info 55 "mkfs $i failed"
                fi
            done
            rg_info "Create cache direcotry..." && mkdir -p /cache/{cache,logs}
            echo -e "/dev/${DISK_SYS}4 \t\t/cache/logs \t\t$FS \tdefaults \t0 0" >>/etc/fstab
            echo -e "/dev/md0 \t\t/cache/cache \t\t$FS \t$MOUNT_OPTS \t0 0" >>/etc/fstab
        echo "--"
#save mdadm.conf
        if (mdadm -Ds 2>/dev/null |grep -q .); then
            [ -f /etc/mdadm.conf ] && rg_info "Backup old mdadm.conf..." && /bin/cp /etc/mdadm.conf /etc/mdadm.conf.bak
            rg_info "Save RAID configration (mdadm.conf)..."
                if [ "$VER6" == 'yes' ]; then
                    mdadm -Ds |sed 's!/dev/md[^ ]*:\([0-9]\)!/dev/md\1!; s!metadata[^ ]* !!; s/$/ auto=yes/' >/etc/mdadm.conf
                else
                    mdadm -Ds |sed 's/$/ auto=yes/' >/etc/mdadm.conf
                fi
        fi
#mount all
        fgrep -q /cache /etc/fstab || rg_info 48 "Internal error: f_mkfs has BUG!"
        rg_info "挂载所有分区..."
        if mount -a; then
            rg_info "创建mkpart锁..."
            echo "$VERSION" >$MKFS_LOCK 2>/dev/null && chattr +i $MKFS_LOCK
            ret=0
        else
            rg_info 49 "mount -a 出错"
        fi
        return $ret
}
