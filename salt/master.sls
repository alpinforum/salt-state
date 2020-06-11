include:
  - apt.repository.saltstack

/etc/ferm/conf.d/40-salt-zmq.conf:
  file.managed:
    - source: salt://salt/files/ferm.conf
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require_in:
      - /etc/ferm/conf.d
