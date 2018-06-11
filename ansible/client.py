import requests

headers =  {'Content-Type': 'application/json'}
user_info = {'ips': ['192.168.1.21','192.168.1.22'], 'password': '123'}
r = requests.post("http://192.168.1.118:1234/ansible/playbook/", headers=headers,data=user_info)

print r.text
