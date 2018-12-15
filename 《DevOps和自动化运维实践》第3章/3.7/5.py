#!/usr/bin/env python
#-*- encoding=utf-8 -*-
import urllib
import json
url='http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=dict2.index'

#建立一个字典
data = {}
data['i'] = '余洪春是帅哥'
data['from'] = 'AUTO'
data['to'] = 'AUTO'
data['smartresult'] = 'dict'
data['client'] = 'fanyideskwe'
data['salt'] = '1506219252440'
data['sign'] = '0b8cd8f9b8b14'
data['doctype'] = 'json'
data['version'] = '2.1'
data['keyfrom'] = 'fanyi.web'
data['action'] = 'FY_BY_CLICK'
data['typoResult'] = 'true'

#在这里还不能直接将data作为参数，需要进行一下数据的解析才可以
#encode是将Unicode的编码转换成utf-8编码
#data=urllib.urlencode(data).encode('utf-8')
#另一种写法，urlencode将字典转换成url参数
data = urllib.urlencode(data)
response=urllib.urlopen(url,data)

#decode作用是将其他形式的编码转换成python使用的Unicode编码
#html=response.read().decode('utf-8')
#另一种写法
html = response.read()
target=json.loads(html)
print(target['translateResult'][0][0]['tgt'])
