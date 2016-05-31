

{% set role = grains.get('roles', 'no good') %}
{% set d = pillar.get('netspend', 'none') %}
{% set b = d[role]  %}
{% set c = b['path'] %}

'test':
  file.touch:
    - name: {{ b }}