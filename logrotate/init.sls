logrotate:
  pkg.installed:
    - pkgs:
      - logrotate

/etc/logrotate.conf:
  file.managed:
    - source: salt://logrotate/files/logrotate.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - pkg: logrotate
