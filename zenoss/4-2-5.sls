# Install Zenoss 4.2.5


# Remove packages
"Remove all mysql libs":
  pkg.purged:
    - pkgs:
      - mysql-libs

# Turn off firewall
"Firewall disabled":
  service.dead:
    - name: iptables
    - enable: False


# Install support packages
"Install zenoss required packages":
  pkg.installed:
    - pkgs: 
      - mysql
      - mysql-libs
      - mysql-server
      - MySQL-python
      - libaio
      - liberation-fonts-common
      - liberation-mono-fonts
      - liberation-sans-fonts
      - liberation-serif-fonts
      - libgcj
      - libgomp
      - libxslt
      - memcached
      - nagios-plugins
      - nagios-plugins-dig
      - nagios-plugins-dns
      - nagios-plugins-http
      - nagios-plugins-ircd
      - nagios-plugins-ldap
      - nagios-plugins-ntp
      - nagios-plugins-perl
      - nagios-plugins-ping
      - nagios-plugins-rpc
      - nagios-plugins-tcp
      - net-snmp
      - net-snmp-utils
      - patch
      - rabbitmq-server
      - redis
      - rrdtool
      - sysstat

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
      - rabbitmq-server
    - require:
      - file: "Setup mysql config file for Zenoss"

"Configure localhost root user for mysql":
  mysql_user.present:
    - name: root
    - allow_passwordless: True
    - host: localhost
    - require:
      - service: "Check mysql service"

"Configure root user for mysql":
  mysql_user.present:
    - name: root
    - allow_passwordless: True
    - require:
      - service: "Check mysql service"

"Disabled SELinux":
  file.replace:
    - name: /etc/sysconfig/selinux
    - pattern: 'SELINUX=enforcing'
    - repl: 'SELINUX=disabled'
    
"Set SELinux mode to permissive":
  selinux.mode:
    - name: permissive

"Install Zenoss oracle java":
  file.managed:
    - name: /tmp/jre-6u31-linux-x64-rpm.bin
    - source: salt://zenoss/jre-6u31-linux-x64-rpm.bin
    - mode: 700
  cmd.run:
    - name: /tmp/jre-6u31-linux-x64-rpm.bin

"Install Zenoss Dep packages":
  pkg.installed:
    - sources:
      - zenossdeps: salt://zenoss/zenossdeps-4.2.x-1.el6.noarch.rpm
      - compat-mysql55: salt://zenoss/compat-mysql55-5.5.45-1.el6.remi.x86_64.rpm
    - require:
      - selinux: "Set SELinux mode to permissive"

"Get Zenoss package":
  file.managed:
    - name: /tmp/zenoss_core-4.2.5-2108.el6.x86_64.rpm
    - source: https://s3.amazonaws.com/salt-filestore/zenoss_core-4.2.5-2108.el6.x86_64.rpm
    - source_hash: md5=41677639ca96a03c30d47e6a8b8fa1d5
    - require:
      - pkg: "Install Zenoss Dep packages"

"Install Zenoss Core with packages":
  cmd.run:
    - name: 'rpm -Uvh /tmp/zenoss_core-4.2.5-2108.el6.x86_64.rpm'
    - require:
      - file: "Get Zenoss package"

"Start Zenoss service":
  service.running:
    - name: zenoss
    - require:
      - cmd: "Install Zenoss Core with packages"
