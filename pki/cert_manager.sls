

"Copy Cert files to minion":
  file.recurse:
    - name: "c:\\stage\\"
    - source: salt://pki/files


"Install cert":
  cmd.run:
    - name: "certutil -addstore -user -f 'My' c:\\stage\\test.crt"


