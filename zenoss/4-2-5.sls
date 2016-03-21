# Install Zenoss 4.2.5


# Remove packages
"Remove all mysql libs":
  pkg.purged:
    - pkgs:
      - mysql-libs

# Install support packages
"Install zenoss required packages":
  pkg.installed:
    - pkgs: 
      - java-1.6.0-openjdk
      - mysql
      - mysql-libs
      - mysql-server
      - MySQL-python

"Setup mysql config file for Zenoss":
  file.managed:
    - source: salt://zenoss/my.cnf
    - name: /etc/my.cnf
    - user: root
    - group: root
    - require:
      - pkg: "Install zenoss required packages"

"Check mysql service":
  service.running:
    - names:
      - mysqld
    - require:
      - file: "Setup mysql config file for Zenoss"

"Configure localhost root user for mysql":
  mysql_user.present:
    - name: root
    - password: ''
    - host: localhost
    - require:
      - service: "Check mysql service"

"Configure root user for mysql":
  mysql_user.present:
    - name: root
    - password: ''
    - require:
      - service: "Check mysql service"

"Disable SELinux":
  selinux.boolean:
    - value: False
    - persist: True

"Set SELinux mode to permissive":
  selinux.mode:
    - name: permissive

"Install Zenoss Dep packages":
  pkg.installed:
    - sources:
      - zenossdeps: salt://zenoss/zenossdeps-4.2.x-1.el6.noarch.rpm
    - require:
      - selinux: "Set SELinux mode to permissive"

"Install Zenoss Core with packages":
  pkg.installed:
    - source: https://s3.amazonaws.com/salt-filestore/zenoss_core-4.2.5-2108.el6.x86_64.rpm
    - source_hash: 66850315878eaa406693d693a668bf2a-2
    - require:
      - pkg: "Install Zenoss Dep packages"
