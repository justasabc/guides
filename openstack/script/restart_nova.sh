#!/bin/bash
echo "killing dmidecode..."
killall -9 dmidecode
ps -ef | grep dmidecode
echo "================================================================"
virsh list
echo "================================================================"
for a in nova-network nova-compute nova-cert nova-api nova-objectstore nova-scheduler nova-volume novnc nova-consoleauth; do service "$a" stop; done

for a in nova-network nova-compute nova-cert nova-api nova-objectstore nova-scheduler nova-volume novnc nova-consoleauth; do service "$a" start; done
echo "================================================================"
nova-manage service list
