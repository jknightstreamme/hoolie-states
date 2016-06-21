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
    - name: "salt/state_result/*/http/check/succeeded/{{ nodename }}"
    - id_list:
      - 'saltmaster'

"Send message to slack with status of application":
  salt.state:
    - tgt: 'saltmaster'
    - sls:
      - slack.appstatus
    - pillar:
      - funtype: "checks.http"
      - minionid: "saltmaster"

