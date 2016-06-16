{% set workingminion = pillar.get('minionid', '') %}


{% set siteip = salt['mine.get'](tgt=workingminion, fun='weburl', expr_form='glob') %}


"Check deployed site":
  http.query:
    - name: 'http://{{ siteip[workingminion][0] }}'
    - status: 200
    - fire_event: 'http/check/complete'


"Site did not deploy correctly":
  event.send:
    - name: 'http/check/failed/{{ workingminion }}'
    - onfail:
      - http: "Check deployed site"
