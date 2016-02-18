
{% set sites = [
    {'name': 'Site 1', 'src_files': 'site1', 'config_file': 'site1'},
    {'name': 'Site 2', 'src_files': 'site2', 'config_file': 'site2'}
    ] %}

{% if grains['os_family'] == 'RedHat' %}
    {% config_path = '/etc/httpd/config.d/' %}

{% elif grains['os_family'] == 'Debian' %}
    {% config_path = '/etc/apache2/sites-enabled/' %}

{% endif %}

{% for site in sites %}
"{{ site.name }} site files deploy":
  file.recurse:
    - name: /var/www/{{ site.src_files }}
    - source: salt://sites/{{ site.src_files }}

"{{ site.name }} apache config file":
  file.managed:
    - name: {{ site.config_path }}site1.conf
    - source: salt://apache/{{ site.config_file }}.conf
    - makedirs: True
    - mode: 600
{% endfor %}