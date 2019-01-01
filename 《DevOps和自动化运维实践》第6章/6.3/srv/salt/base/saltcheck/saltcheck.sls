/usr/bin/salt.sh:
  file.managed:
    - source: salt://saltcheck/saltcheck.sh
    - user: root
    - group: root
    - mode: 755
    - backup: minion

/etc/cron.d/salt_agent.cron:
  file.managed:
    - source: salt://saltcheck/salt_agent.cron
    - user: root
    - group: root
    - mode: 644
- backup: minion
