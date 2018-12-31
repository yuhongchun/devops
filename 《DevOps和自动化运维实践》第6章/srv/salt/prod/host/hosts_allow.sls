/etc/hosts.allow:
  file.managed:
    - source: salt://host/hosts.allow
    - user: root
    - group: root
    - mode: 644
    - backup: minion

hosts_allow:
  cmd.run:
    - name: 'md5sum /etc/hosts.allow'
    - watch:
      - file: /etc/hosts.allow
