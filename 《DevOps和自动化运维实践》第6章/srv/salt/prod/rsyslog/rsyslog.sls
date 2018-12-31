/etc/rsyslog.conf:
  file.managed:
    - source: salt://rsyslog/rsyslog.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion

rsyslog:
  service.running:
    - enable: True
    - watch:
      - file: /etc/rsyslog.conf
    #watch选项会监控Minion端的/etc/rsyslog.conf文件，如果内容发生改变的话，rsyslog服务#也会重新启动
