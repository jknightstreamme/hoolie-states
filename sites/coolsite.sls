# Cool site pulls from
# https://github.com/trebortech/ACME.git

include:
  - git

{% set workingdir = "/usr/share/nginx/html/" %}
{% set sshkey = "acme-site-demo" %}

{% if pillar.get('version') is defined %}
{% set env = pillar['version'] %}
{% else %}
{% set env = grains.get('version', 'dev') %}
{% endif %}

####### STAGE KEYS #####################

"Push ssh keys for github":
  file.managed:
    - name: /root/.ssh/{{ sshkey }}.priv
    - source: salt://files/{{ sshkey }}.priv
    - makedirs: True
    - mode: 600
    - user: root
    - group: root

####### PULL IN ACME DEV CODE ##########

"Pull in ACME site code":
  git.latest:
    - name: git@github.com:trebortech/ACME.git
    - target: {{ workingdir }}
    - rev: {{ env }}
    - identity: /root/.ssh/{{ sshkey }}.priv
    - force_reset: True
    - force_checkout: True
    - require:
        - pkg: 'GIT software'

####### UPDATE GIT CONFIG  #############
"Setup {{ env }} email config":
  git.config_set:
    - name: user.email
    - value: rbooth@saltstack.com
    - repo: {{ workingdir }}
    - require:
        - git: "Pull in ACME site code"

"Setup {{ env }} name config":
  git.config_set:
    - name: user.name
    - value: trebortech
    - repo: {{ workingdir }}
    - require:
        - git: "Pull in ACME site code"

"Setup core editor":
  git.config_set:
    - name: core.editor
    - value: vim
    - repo: {{ workingdir }}
    - require:
        - git: "Pull in ACME site code"

