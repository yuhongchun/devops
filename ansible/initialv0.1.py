#encoding:utf-8
#ansible 1.9.6
import time
import os
import random
import time
import commands
import json
import jinja2
import ansible.runner
import logging
from flask import Flask, request, render_template, session, flash, redirect,url_for, jsonify
from ansible.inventory import Inventory
from ansible.playbook import PlayBook
from ansible import callbacks
from tempfile import NamedTemporaryFile
from rq import Queue
from rq.job import Job
from redis import Redis
app = Flask(__name__)


conn = Redis()
q = Queue(connection=conn)  



@app.route('/hello')
def hello_world():
    return 'Hello World!'


@app.route('/ansible/playbook/', methods=['POST'])
def playbook():
    inventory = """
    [initial]
    {% for i in hosts %}
    {{ i }}
    {% endfor %}
    """
    
    inventory_template = jinja2.Template(inventory)
    #inst_ip  = [ i.encode('ascii') for i in request.form['ips']]
    #ips = [  i for i in request.form.getlist("ips") ]
    #inst_ip = request.form.get('ips')
    #inst_ip = json.loads(request.form.getlist('ips'))
    #inst_ip  = [ i.encode('ascii') for i in request.form.getlist('ips') ]
    #print inst_ip
    #print request.form
    print request.get_data()
    #data = request.get_data()
    #inst_ip = request.form.getlist('ips[]')
    #print data 
    #inst_ip = data['ips']
    #inst_ip = request.form.getlist('ips')
    data = json.loads(request.get_data())
    inst_ip = data["ips"]
    print inst_ip
    #inst_ip = ["192.168.1.3","192.168.1.4","192.168.1.5"]
    rendered_inventory = inventory_template.render({'hosts':inst_ip})
    hosts = NamedTemporaryFile(delete=False,suffix='tmp',dir='/tmp/ansible/')
    hosts.write(rendered_inventory)
    hosts.close()
    inventory = Inventory(hosts.name)
    print inventory

    vars = {}
    stats = callbacks.AggregateStats()
    playbook_cb = callbacks.PlaybookCallbacks()
    runner_cb = callbacks.PlaybookRunnerCallbacks(stats)
    # hosts = request.args.get('ip')
    # task = request.args.get('playbook')
    # vars['hosts'] = hosts
    # play = task + '.yml'
    pb = PlayBook(playbook='mytest.yml',callbacks=playbook_cb,runner_callbacks=runner_cb,stats=stats,inventory=inventory,extra_vars=vars)
    job = q.enqueue_call(pb.run, result_ttl=5000, timeout=2000)
    jid = job.get_id()
    if jid:
      app.logger.info("Job Succesfully Queued with JobID: %s" % jid)
    else:
      app.logger.error("Failed to Queue the Job")
    return jid  
    
@app.route("/ansible/results/<job_key>", methods=['GET'])
def get_results(job_key):
  job = Job.fetch(job_key, connection=conn)
  if job.is_finished:
      ret = job.return_value
  elif job.is_queued:
      ret = {'status':'in-queue'}
  elif job.is_started:
      ret = {'status':'waiting'}
  elif job.is_failed:
      ret = {'status': 'failed'}

  return json.dumps(ret), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=1234)
