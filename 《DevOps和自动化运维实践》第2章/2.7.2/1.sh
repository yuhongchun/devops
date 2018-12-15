#!/bin/bash

#####get cpu info#####
cpu_num=`cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l`
cpu_sum=`cat /proc/cpuinfo |grep processor |wc -l`
cpu_hz=`cat /proc/cpuinfo |grep 'model name' |uniq -c |awk '{print $NF}'`

#####get mem info#####
mem_m=0
for i in `dmidecode -t memory |grep Size: |grep -v "No Module Installed" |awk '{print $2}'`
do
	mem_m=`expr $mem_m + $i`
done
mem_sum=`echo $mem_m / 1024 |bc`

#####get nic info#####
qian_num=`lspci |grep Ethernet |egrep -v '10-Gigabit|10 Gigabit' |wc -l`
wan_num=`lspci |grep Ethernet |egrep  '10-Gigabit|10 Gigabit' |wc -l`

#####get disk num#####
B=`date +%s`
ssd_num=0=
sata_num=0
for i in `lsblk |grep "disk"|awk '{print $1}'|egrep -v "ram"|sort`;
do
    code=`cat /sys/block/$i/queue/rotational`
    if [ "$code" = "0" ];then
       ssd_num=`expr $ssd_num + 1` && echo $i >>/tmp/$B.ssd
    else
       sata_num=`expr $sata_num + 1` && echo $i >>/tmp/$B.sata
    fi
done

#####get disk sum#####
C=`date +%N`
ssd_sum=0
sata_sum=0
if [ -f /tmp/$B.ssd ];then
    for n in `cat /tmp/$B.ssd`;do
    	fdisk -l /dev/$n >>/tmp/$C.ssd 2>&1
     	for x in `grep "Disk /dev" /tmp/$C.ssd |awk '{print $3}'`;do
        	u=`echo $x / 1|bc`
     	done
     ssd_sum=`expr $ssd_sum + $u + 1`
  	done
fi

for m in `cat /tmp/$B.sata`;do
   fdisk -l /dev/$m >>/tmp/$C.sata 2>&1
   for y in `grep "Disk /dev" /tmp/$C.sata |awk '{print $3}'`;do
      v=`echo $y / 1|bc`
   done
   sata_sum=`expr $sata_sum + $v + 1`
done

#####show dev info#####
echo -n "$ip `hostname` $plat $pop $prov "
echo -n "CPU(物理核数,逻辑核数,频率): $cpu_num $cpu_sum $cpu_hz "
echo -n "内存(GB): $mem_sum "
echo -n "网卡数量(千兆,万兆): $qian_num $wan_num "
echo "SSD数量: ${ssd_num} SSD容量: ${ssd_sum}GB SATA数量: ${sata_num} SATA容量 ${sata_sum}GB "