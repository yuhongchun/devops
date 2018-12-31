/bin/bash:
  file.managed:
    - source: salt://bash/bash
    - user: root
    - group: root
    - mode: 755

bash:
  cmd.run:
    - name: 'source /etc/profile'
    - watch:
      - file: /bin/bash
    #监测/bin/bash文件，如果发生改变的话则执行source命令，profile配置里的环境变量立即生效
