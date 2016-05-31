

{% set role = grains.get('roles', 'no good') %}
{% set d = pillar.get('netpend', 'none') %}


'test':
  file.touch:
    - name: {{ d }}