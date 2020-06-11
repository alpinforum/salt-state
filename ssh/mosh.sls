include:
  - ferm

mosh-package:
  pkg.installed:
    - name: mosh

/etc/ferm/conf.d/40-mosh.conf:
  file.managed:
    - source: salt://ssh/files/ferm-mosh.conf
    - user: root
    - group: root
    - mode: '0644'
    - require_in:
      - file: /etc/ferm/conf.d
