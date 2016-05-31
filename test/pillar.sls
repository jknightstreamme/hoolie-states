

{% set role = grains.get('role', '') %}

'test':
  file.touch:
    - name: {{ pillar.get('netspend:{{ role }}:path:', '') }}