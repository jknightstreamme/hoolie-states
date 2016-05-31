

{% set role = grains.get('roles', 'no good') %}
{% set d = pillar.get('netpend', 'none') %}
{% set b = d.[role]  %}

'test':
  file.touch:
    - name: {{ b.[path] }}