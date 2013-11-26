#!/bin/bash
echo "===================================================="
for a in libvirt-bin nova-network nova-compute nova-cert nova-api nova-objectstore nova-scheduler nova-volume novnc nova-consoleauth; do service "$a" stop; done

for a in libvirt-bin nova-network nova-compute nova-cert nova-api nova-objectstore nova-scheduler nova-volume novnc nova-consoleauth; do service "$a" start; done
echo "===================================================="
