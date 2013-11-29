apt-get purge -y mysql-server python-mysqldb
apt-get -y purge bridge-utils
apt-get -y purge ntp
apt-get -y purge tgt
apt-get -y purge open-iscsi open-iscsi-utils
apt-get -y purge rabbitmq-server memcached python-memcache
apt-get -y purge kvm libvirt-bin
apt-get -y purge keystone python-keystone python-keystoneclient
apt-get -y purge glance glance-api glance-client glance-common glance-registry python-glance
apt-get -y purge nova-api nova-cert nova-common nova-compute nova-compute-kvm nova-doc nova-network nova-objectstore nova-scheduler nova-volume nova-consoleauth novnc python-nova python-novaclient 
apt-get -y purge openstack-dashboard
