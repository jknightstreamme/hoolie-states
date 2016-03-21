# Install Zenoss 4.2.5


# Remove packages
"Remove all mysql libs"
  pkg.purge:
    - pkgs:
      - mysql-libs

# Install support packages
"Install zenoss required packages":
  pkg.installed:
    - pkgs: 
      - openjdk
      - mysql
      - mysql-libs
      - mysql-server

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
      - pkg: "Setup mysql config file for Zenoss"

"Configure localhost root user for mysql":
  mysql_user.present:
    - name: root
    - password: ''
    - host: localhost
    - require:
      - pkg: "Check mysql service"

"Configure root user for mysql":
  mysql_user.present:
    - name: root
    - password: ''
    - require:
      - pkg: "Check mysql service"

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
    - sources:
      - zenoss_core-4.2.5: salt://zenoss/zenoss_core-4.2.5-2108.el6.x86_64.rpm
    - require:
      - pkg: "Install Zenoss Dep packages"
