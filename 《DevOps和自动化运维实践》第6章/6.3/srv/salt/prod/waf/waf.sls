/usr/local/waf/lualib/ng/config.lua:
  file.managed:
    - source: salt://waf/config.lua
    - user: root
    - group: root
    - mode: 644
    - backup: minion

nginxluareload:
  cmd.run:
    - name: '/usr/local/waf/nginx/sbin/nginx -c /usr/local/waf/nginx/conf/nginx.conf -t && /usr/local/ndserver/nginx/sbin/nginx -s reload'
    - watch:
      - file: /usr/local/waf/lualib/ng/config.lua
    #Minion端会监控/usr/local/waf/lualib/ng/config.lua文件，如果发生改变的话，则#会执行name字段定义好的Shell命令集