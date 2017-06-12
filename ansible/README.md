# 介绍

Ansible是作为自动化运维的底层实现，功能很强大，但需要通过命令或playbook的yaml文件来实现，相对对运维人员而言，学习成本过大。所以这里要考虑到通过Flask Web框架来实现其二次封装，提供HTTP接口来实现远程调用。但我们在请求Ansbile API的时候，ansible默认本身是阻塞的，用户那边会一直处于等待状态，这样大家的用户体验也不好，所以这里会用rq来实现其非阻塞功能，即实现任务的异步化。

## 使用的开源软件
    Ansible
    Flask
    redis
    redis-queue

## 正式版本v0.1

## mydemo文件明细
   
    inventoryv0.1.py .... 正式的功能文件，版本为v0.1
    mytest.yml...... 用来实现初始化功能的ansible playbook的YAML文件。
    work.py...... 用rq来实现任务异步化（非阻塞）。
    client.py... 客户端测试脚本，不过感觉postman测试起来更加方便。
    
    

前期考虑用Celery框架来实现异步非阻塞的功能，但在实际使用及学习过程中发现使用较复杂，学习成本较大，改用更轻量级的rq来实现需求。 <br>


## 启动步骤

1.先启动redis-server，为了安全起见，只对127.0.0.1开放。

    /usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf

2.启动initial.py程序，开启Flask应用封装Ansible API。
   
    nohup python initialv0.1.py & 

3.启动work程序，开启rq队列任务。 
    
    nohup python work.py & 

4.我们可以在别的机器上执行POST请求，以http方式来执行Ansible playbook任务了，API接口为：
    
    http://192.168.1.118:1234/ansible/playbook/

此处需要跟公司的前端团队配合，需要初始化的设备IP列表以Form或Json的格式（推荐Json）的格式传递，我在Flask Web里面用了jinja2渲染成Ansible能识别的格式，下面是前端传递的例子：

    {	
	    "ips": 
	[
		"192.168.1.101",
		"192.168.1.102",
		"192.168.1.103"
	]
    }   
    
## postman测试图片如下：
![image](/postman.png)
    
    

此段http就可以执行hosts为initial[前端提供的需要初始化的IP机器列表]，另外名字为mytest的Ansible Playbook了，里面可以执行我们的初始化脚本。

## 后续工作

后续根据产品和前端的需求，进行功能性补充。 <br>
