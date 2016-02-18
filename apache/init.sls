# Install apache / httpd

{% if grains['os_family'] == 'RedHat' %}
    {% set httpd = 'httpd' %}

{% elif grains['os_family'] == 'Debian' %}
    {% set httpd = 'apache2' %}

{% endif %}


"Install apache / httpd":
  pkg.installed:
    - name: {{ httpd }}

"Confirm service starts":
  service.enabled:
    - name: {{ httpd }}