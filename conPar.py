#!/usr/bin/python
import ConfigParser
import os


config = ConfigParser.ConfigParser()
config.read('/root/scripts/etc/cluster.conf') or exit(1)

master = config.get('master', 'nodes')
workers = config.get('worker', 'nodes')
nodes = workers.split(" ")
for node in nodes:
    print(node)
