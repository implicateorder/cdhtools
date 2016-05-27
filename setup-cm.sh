#!/bin/sh

# Check if the cloudera manager repo is available

if [ ! -f /etc/yum.repos.d/cloudera-manager.repo ]; then
   /usr/bin/wget http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/cloudera-manager.repo
   cp -pr cloudera-manager.repo /etc/yum.repos.d/
fi
yum clean all
yum install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server oracle-j2sdk1.7

# Prep the db.properties file

mkdir -p /etc/cloudera-scm-server
cat > /etc/cloudera-scm-server/db.properties <<EOF
com.cloudera.cmf.db.type=mysql
com.cloudera.cmf.db.host=localhost:3306
com.cloudera.cmf.db.name=scm
com.cloudera.cmf.db.user=scm
com.cloudera.cmf.db.password=cl0ud3ra!
EOF
chown cloudera-scm:cloudera-scm /etc/cloudera-scm-server/db.properties
chmod 0600 /etc/cloudera-scm-server/db.properties

# Prep the db.mgmt.properties file

cat > /etc/cloudera-scm-server/db.mgmt.properties <<EOF
com.cloudera.cmf.ACTIVITYMONITOR.db.type=mysql
com.cloudera.cmf.ACTIVITYMONITOR.db.host=localhost:3306
com.cloudera.cmf.ACTIVITYMONITOR.db.name=amon
com.cloudera.cmf.ACTIVITYMONITOR.db.user=amon
com.cloudera.cmf.ACTIVITYMONITOR.db.password=cl0ud3ra!
com.cloudera.cmf.REPORTSMANAGER.db.type=mysql
com.cloudera.cmf.REPORTSMANAGER.db.host=localhost:3306
com.cloudera.cmf.REPORTSMANAGER.db.name=rman
com.cloudera.cmf.REPORTSMANAGER.db.user=rman
com.cloudera.cmf.REPORTSMANAGER.db.password=cl0ud3ra!
com.cloudera.cmf.NAVIGATOR.db.type=mysql
com.cloudera.cmf.NAVIGATOR.db.host=localhost:3306
com.cloudera.cmf.NAVIGATOR.db.name=nav
com.cloudera.cmf.NAVIGATOR.db.user=nav
com.cloudera.cmf.NAVIGATOR.db.password=cl0ud3ra!
com.cloudera.cmf.NAVIGATORMETASERVER.db.type=mysql
com.cloudera.cmf.NAVIGATORMETASERVER.db.host=localhost:3306
com.cloudera.cmf.NAVIGATORMETASERVER.db.name=navms
com.cloudera.cmf.NAVIGATORMETASERVER.db.user=navms
com.cloudera.cmf.NAVIGATORMETASERVER.db.password=cl0ud3ra!
com.cloudera.cmf.ACTIVITYMONITOR.db.type=mysql
com.cloudera.cmf.ACTIVITYMONITOR.db.host=localhost:3306
com.cloudera.cmf.ACTIVITYMONITOR.db.name=amon
com.cloudera.cmf.ACTIVITYMONITOR.db.user=amon
com.cloudera.cmf.ACTIVITYMONITOR.db.password=cl0ud3ra!
com.cloudera.cmf.REPORTSMANAGER.db.type=mysql
com.cloudera.cmf.REPORTSMANAGER.db.host=localhost:3306
com.cloudera.cmf.REPORTSMANAGER.db.name=rman
com.cloudera.cmf.REPORTSMANAGER.db.user=rman
com.cloudera.cmf.REPORTSMANAGER.db.password=cl0ud3ra!
com.cloudera.cmf.NAVIGATOR.db.type=mysql
com.cloudera.cmf.NAVIGATOR.db.host=localhost:3306
com.cloudera.cmf.NAVIGATOR.db.name=nav
com.cloudera.cmf.NAVIGATOR.db.user=nav
com.cloudera.cmf.NAVIGATOR.db.password=cl0ud3ra!
com.cloudera.cmf.NAVIGATORMETASERVER.db.type=mysql
com.cloudera.cmf.NAVIGATORMETASERVER.db.host=localhost:3306
com.cloudera.cmf.NAVIGATORMETASERVER.db.name=navms
com.cloudera.cmf.NAVIGATORMETASERVER.db.user=navms
com.cloudera.cmf.NAVIGATORMETASERVER.db.password=cl0ud3ra!
EOF
chmod 0600 /etc/cloudera-scm-server/db.mgmt.properties
chown cloudera-scm:cloudera-scm /etc/cloudera-scm-server/db.mgmt.properties

# Start the service

/sbin/chkconfig cloudera-scm-server on
/sbin/service cloudera-scm-server start

