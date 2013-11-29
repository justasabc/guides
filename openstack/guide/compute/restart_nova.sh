#!/bin/bash
for a in libvirt-bin nova-compute nova-api ; do service "$a" stop; done
for a in libvirt-bin nova-compute nova-api ; do service "$a" start; done

