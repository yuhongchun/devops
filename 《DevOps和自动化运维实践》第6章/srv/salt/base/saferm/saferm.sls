/usr/local/bin/safe-rm:
  file.managed:
    - source: salt://saferm/safe-rm
    - user: root
    - group: root
    - mode: 755

/etc/safe-rm.conf:
  file.managed:
    - source: salt://saferm/safe-rm.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion

saferm:
  cmd.run:
    - name: 'ln -s /usr/local/bin/safe-rm /usr/local/bin/rm; sed -i "s/PATH=/PATH=\/usr\/local\/bin:/" /root/.bash_profile; source /root/.bash_profile;'
    - watch:
      - file: /usr/local/bin/safe-rm
      - file: /etc/safe-rm.conf
#同时监测Minion端的/usr/local/bin/safe-rm和/etc/safe-rm.conf文件，如果有变化的话，则执行name字段定义好的Shell命令
