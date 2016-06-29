{% set sitename = pillar['sitename'] %}
{% set nodename = pillar['nodename'] %}
{% set refid = pillar['refid'] %}

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

"Hack a wait clause":
  salt.function:
    - tgt: 'saltmaster'
    - name: cmd.run
    - kwarg:
        name: 'sleep 20'

"Send cloud deploy message to slack":
  salt.state:
    - tgt: 'saltmaster'
    - sls:
      - slack.blast
    - pillar:
        mymessage: "{{ nodename }} cloud deploy done"


"Run check of application deployed":
  salt.state:
    - tgt: 'saltmaster'
    - sls:
      - checks.acme
    - pillar:
        minionid: "{{ nodename }}"

"Send wait message to slack":
  salt.state:
    - tgt: 'saltmaster'
    - sls:
      - slack.blast
    - pillar:
        mymessage: "Start wait for http check"


"Send message to slack with status of application":
  salt.state:
    - tgt: 'saltmaster'
    - sls:
      - slack.appstatus
    - pillar:
        funtype: "checks.http"
        minionid: "saltmaster"

"Destroy VM":
  salt.function:
    - tgt: 'saltmaster'
    - name: cloud.destroy
    - kwarg:
        names:
          - {{ nodename }}

# Need to build tag