{% set zipversion = pillar.get('version', '9.20.00.0') %}

###############################
#
# maintainer    Robert Booth <rbooth@saltstack.com>
# maturity      new
# depends       
#               files/7zip/7z920-x64.msi
#               srv/salt/win/repo/7zip/
#
# platform      Windows
# description   Installs the 7Zip ap
# 
###############################

# Install
"Install 7Zip":
  pkg.installed:
    - name: 7zip
    - version: {{ zipversion }}


"Notification of install":
  slack.post_message:
    - channel: '#trebortech-demo'
    - from_name: 'Demo3'
    - message: '7Zip has been installed on {{ grains['id'] }}'
    - api_key: {{ pillar['slack']['api_key'] }}

  hipchat.send_message:
    - room_id: 'Demo3'
    - message: '7Zip has been installed on {{ grains['id'] }}'
    - from_name: 'Demo3'
    - api_version: {{ pillar['hipchat']['api_version'] }}
    - api_key: {{ pillar['hipchat']['api_key'] }}
