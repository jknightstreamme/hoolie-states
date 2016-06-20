{% set sitename = pillar['sitename'] %}
{% set nodename = pillar['nodename'] %}

"Deploy New Server":
  salt.function:
    - tgt: 'saltmaster'
    - name: cloud.profile
    - kwarg:
        profile: {{ sitename }}
        names:
          - {{ nodename }}
        vm_overrides:
          tag:
            'Environment': 'Testing'
          minion:
            master: 10.5.0.239


"Send cloud deploy message to slack":
  salt.state:
    - tgt: 'saltmaster'
    - sls:
      - slack.blast
    - pillar:
      mymessage: "{{ nodename }} cloud deploy done"


"Wait for highstate to complete":
  salt.wait_for_event:
    - name: "salt/job/highstate/complete/*"
    - id_list:
      - {{ nodename }}
    - require:
      - salt: "Deploy New Server"

"Run check of application deployed":
  salt.state:
    - tgt: 'saltmaster'
    - sls:
      - checks.acme
    - pillar:
        minionid: "{{ nodename }}"
    - require:
      - salt: "Wait for highstate to complete"

"Wait for http status":
  salt.wait_for_event:
    - name: "*state_result*/{{ nodename }}"
    - id_list:
      - saltmaster
    - require:
      - salt: "Run check of application deployed"