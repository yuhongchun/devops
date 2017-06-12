import requests

user_info = {'ips': ['192.168.1.21','192.168.1.22'], 'password': '123'}
r = requests.post("http://192.168.1.118:1234/ansible/playbook/", data=user_info)

print r.text
