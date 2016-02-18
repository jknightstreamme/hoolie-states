# Install apache / httpd

{% if grains['os_family'] == 'RedHat' %}
    {% set httpd = 'httpd' %}

{% elif grains['os_family'] == 'Debian' %}
    {% set httpd = 'apache2' %}

{% endif %}


"Install apache / httpd":
  pkg.installed:
    - name: {{ httpd }}

"Allow NameVirtualHost":
  file.replace:
    - name: '/etc/httpd/conf/httpd.conf'
    - pattern: 'NameVirtualHost *:80'
    - repl: '#NameVirtualHost *:80'
    - backup: False


"Confirm service starts":
  service.enabled:
    - name: {{ httpd }}
    - watch:
      - pkg: "Install apache / httpd"