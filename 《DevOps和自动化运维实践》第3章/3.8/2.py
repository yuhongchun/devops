#!/usr/bin/env python
# -*- coding:utf-8 -*-
import smtplib
from email.mime.text import MIMEText
import string
import os

mail_host = "mail.example.com.cn"
mail_subject = "hostname名字不规则的机器列表"
# mail_reciver = ["yuhc@example.com.cn"]
mail_reciver = ["devops@example.com.cn", "admin@example.com.cn", "sa@example.com.cn"]
# mail_cc=["wangmiao@example.com.cn","nocdev@example.com"]
# mail_reliver以列表的形式存在，如果是单个收件地址，建议也以方式，即mail_reciver = ["yuhc@example.com.cn"]
mail_from = "yhc@example.com.cn"
text = open('/data/report/hostname_report.txt', 'r')
# body = string.join((text.read().strip()), "\r\n")
body = "ALL:\r\n" + "        你好，下面是我们全网内hostname名字不规范的列表，已经依次列出，麻烦将其改正并修正至 CMDB 系统，谢谢，列表如下所示：\r\n" + "\r\n" + text.read() + "\r\n" + "-------" + "\r\n" + "运维开发 | 余洪春"
text.close()

# body = str(body)
msg = MIMEText(body, format, 'utf-8')
msg['Subject'] = mail_subject
msg['From'] = mail_from
msg['To'] = ",".join(mail_reciver)
# msg['Cc'] = ",".join(mail_cc)
# 以下两行代码加上前面的MIMEText中的'utf-8'都是为了解决邮件正文乱码问题.
msg["Accept-Language"] = "zh-CN"
msg["Accept-Charset"] = "ISO-8859-1,utf-8"

# 发送邮件至相关人员
try:
    server = smtplib.SMTP()
    server.connect(mail_host, '25')
    # 注意这里用到了starttls
    server.starttls()
    server.login("yhc@example.com.cn", "yhc123456")
    server.sendmail(mail_from, mail_reciver, msg.as_string())

    server.quit()
except Exception, e:
    print "发送邮件失败" + str(e)