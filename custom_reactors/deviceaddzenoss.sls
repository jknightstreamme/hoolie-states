{% if data['deviceclass'] is defined %}

{% set deviceclass = data['deviceclass']
{% set devicename = data['devicename']
{% set serialnumber = data['serialnumber']
{% set title = data['title']

{% endif %}

'Add device to Zenoss':
  runner.zenoss.add_device:
    - kwarg:
        deviceName: {{ devicename }}
        deviceClass: {{ deviceclass }}
        title: {{ title }}
        serialnumber: {{ serialnumber }}