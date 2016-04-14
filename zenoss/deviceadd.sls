
#Add device to Zenoss based off grains
# deviceclass


"Add device to Zenoss":
  event.send:
    - name: zenoss/add/device
    - data:
        deviceclass: {{ grains['deviceclass'] }} 
        title: {{ grains['id'] }}
        devicename: {{ grains['fqdn_ip4'] }}
        serialnumber: {{ grains['serialnumber'] }}

