#!/usr/bin/evn python
# -*- encoding:utf-8 -*-
import time
import os
import random
import time
import commands
import json
import jinja2
import ansible.runner
import logging
from flask import Flask, request, render_template, session, flash, redirect, url_for, jsonify
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
    data = json.loads(request.get_data())
    inst_ip = data["ips"]
    rendered_inventory = inventory_template.render({'hosts': inst_ip})
    hosts = NamedTemporaryFile(delete=False, suffix='tmp', dir='/tmp/ansible/')
    hosts.write(rendered_inventory)
    hosts.close()
    '''
    前端传递过来的Json数据，在Flask里面用了jinja2渲染成Ansible能识别的格式，并以临时文件的形式存在于/tmp/ansible/目录下
    /tmp/ansible/目录可以提前建立
    '''
    inventory = Inventory(hosts.name)
    vars = {}
    stats = callbacks.AggregateStats()
    playbook_cb = callbacks.PlaybookCallbacks()
    runner_cb = callbacks.PlaybookRunnerCallbacks(stats)
    pb = PlayBook(playbook='/root/ansible/mytest.yml', callbacks=playbook_cb, runner_callbacks=runner_cb, stats=stats,
                  inventory=inventory, extra_vars=vars)
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
        ret = {'status': 'in-queue'}
    elif job.is_started:
        ret = {'status': 'waiting'}
    elif job.is_failed:
        ret = {'status': 'failed'}
    return json.dumps(ret), 200


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)


