{% set url = salt['pillar.get']('url', 'http://i.giphy.com/FB7yASVBqPiFy.gif') %}
{% set keyword = salt['pillar.get']('keyword', 'Kick Minion') %}
{% set lamdahost = salt['pillar.get']('lamdahost', 'docker-aws1') %}
{% if lambdahost == 'docker-aws1' %}
/usr/share/nginx/html/aws.html:
  file.recurse:
    - source: salt://sites/saltconf16/aws.html
    - template: jinja
    - defaults:
        aws_gif: {{ url }}
        aws_keyword: {{ keyword }}
{% elif lambdahost == 'docker-linode1' %}
/usr/share/nginx/html/linode.html:
  file.recurse:
    - source: salt://sites/saltconf16/linode.html
    - template: jinja
    - defaults:
        linode_gif: {{ url }}
        linode_keyword: {{ keyword }}
{% elif lambdahost == 'docker-linode1' %}
/usr/share/nginx/html/local.html:
  file.recurse:
    - source: salt://sites/saltconf16/local.html
    - template: jinja
    - defaults:
        local_gif: {{ url }}
        local_keyword: {{ keyword }}
{% endif %}