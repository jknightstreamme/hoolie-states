
{% set workingminion = pillar.get('minionid', '') %}
{% set funtype = pillar.get('funtype', '') %}


{% set status = salt['mine.get'](tgt=workingminion, fun=funtype, expr_form='glob') %}

{% set mymessage = status[workingminion] %}

"Send status message of app":
  slack.post_message:
    - name: slack-message
    - channel: '#{{ pillar['slack']['channel'] }}'
    - from_name: {{ pillar['slack']['from_name'] }}
    - api_key: {{ pillar['slack']['api_key'] }}
    - message: "{{ mymessage }}"