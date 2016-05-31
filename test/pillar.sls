

{% set role = grains.get('roles', 'no good') %}
{% set d = pillar.get('netpend', 'none') %}
{% set b = d[role]  %}
{% set c = b['path'] %}

'test':
  file.touch:
    - name: {{ c }}