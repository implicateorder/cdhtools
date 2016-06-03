#!/bin/sh

# Install git and clone the cm_api python client, set up groundwork for cm automation

BASEDIR=/root/scripts

if [ ! -f /usr/bin/wget ]; then
    yum install -y wget
fi
if [ ! -f /usr/bin/git ]; then
    yum install -y git
fi
mkdir -p /root/cm_api
cd /root/cm_api
git clone https://github.com/cloudera/cm_api.git

# make the python client
cd python
if [ ! -f /usr/bin/python ]; then
    yum install -y python
fi
python setup.py install

cd $BASEDIR

# Set up the mysql DB

sh mysql-setup.sh

# set up the Cloudera manager instance

sh setup-cm.sh

