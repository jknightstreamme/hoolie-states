


# Deploy web content for site 1


# Deploy Site 1 Configuration file
"Site 1 apache config file":
  file.managed:
    - name: /etc/httpd/conf.d/site1.conf
    - source: salt://apache/site1.conf
    - makedirs: True
    - mode: 600


# Restart httpd service if configuration file updated

