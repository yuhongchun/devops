import requests

user_info = {'ips': ['223.87.1.210','119.44.18.156'], 'password': '123'}
r = requests.post("http://202.85.220.118:5000/ansible/playbook/", data=user_info)

print r.text
