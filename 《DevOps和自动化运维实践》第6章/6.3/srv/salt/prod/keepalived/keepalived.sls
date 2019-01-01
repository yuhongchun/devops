keepalived:
  file.managed:
- name: /root/keepalived.sh
#请注意此处的name指明了Minion端保存文件的详细路径
- source: salt://keepalived/keepalived.sh
    - user: root
    - group: root
    - mode: 644
    - backup: minion
cmd.run:
- name: bash /root/keepalived.sh
#此处的name则是指明了Minion端的执行的详细Shell命令
