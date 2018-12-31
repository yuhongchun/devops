#!/bin/bash

#!/bin/bash
# Salt-minion program check

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
salt_client=`ps -ef |grep 'salt-minion' |grep -v grep|wc -l`

salt_check() {
if [ $salt_client -ge 1 ]
then
echo "ok"
else
     /etc/init.d/salt-minion restart
fi
}

salt_check

