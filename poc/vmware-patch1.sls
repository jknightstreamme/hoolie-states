# Update salt server files
"Update the vmware cloud file with custom config":
  file.managed:
    - name: /usr/lib/python2.7/dist-packages/salt/cloud/clouds/vmware.py
    - source: salt://filestore/vmware.py-v1