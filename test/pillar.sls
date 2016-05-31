

{% set role = grains.get('roles', 'no good') %}

'test':
  file.touch:
    - name: {{ pillar.get('netspend:{{ role }}:path', 'no go') }}