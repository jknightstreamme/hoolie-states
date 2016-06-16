{% set workingminion = pillar.get('minionid', '') %}


{% set siteip = salt['mine.get'](tgt=workingminion, fun='weburl', tgt_type='glob')[0] %}


"Check deployed site":
  http.query:
    - name: 'http://{{ siteip }}'
    - status: 200