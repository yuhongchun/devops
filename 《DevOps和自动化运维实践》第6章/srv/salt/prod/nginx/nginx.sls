nginx_install:
  file.managed:
    - source: salt://nginx/nginx_install.sh
    - name: /root/anzhuang.sh
    - user: root
    - group: root
    - mode: 644