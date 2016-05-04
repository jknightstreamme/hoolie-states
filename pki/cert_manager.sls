

"Copy Cert files to minion":
  file.recurse:
    - name: "c:\\stage\\"
    - source: salt://pki/files



"Install Cert":
  win_certmgr.cert_installed:
    - location: 'LocalMachine'
    - datastore: 'My'
    - certpath: 'c:\stage\test.crt'
