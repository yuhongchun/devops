# 我们这个小型CDN项目已经开发了成熟的CMDB资产管理系统，Python脚本每隔30分钟会自动同步一次，对其分组进行同步更新
base:
  '*':
    - bash.bash
    - saferm.saferm
    - snmp.snmpd
    - saltcheck.saltcheck

prod:
  'host':
    - match: nodegroup
    - host.hosts
  'waf':
    - match: nodegroup
    - waf.waf
    - host.hosts
  'hadoop':
    - match: nodegroup
    - rsyslog.rsyslog
    - bash.bash
  'nginx':
    - match: nodegroup
    - host.hosts
    - nginx.nginx_install
  'gitlab':
    - match: nodegroup
    - gitlab.gitlab
  'rsyslog':
    - match: nodegroup
    - host.hosts
    - rsyslog.rsyslog
  'keepalived':
    - math: nodegroup
    - keepalived.keepalived