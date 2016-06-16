"High State Completed":
  event.send:
    tag: 'salt/job/highstate/complete/{{ grains.get('id', '') }}'