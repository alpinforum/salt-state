include:
  - systemd

unattended-upgrades:
  pkg.installed

/etc/apt/apt.conf.d/10periodic:
  file.managed:
    - source: salt://apt/files/10periodic
    - user: root
    - group: root
    - mode: '0644'

/etc/apt/apt.conf.d/50unattended-upgrades:
  file.managed:
    - source: salt://apt/files/50unattended-upgrades
    - user: root
    - group: root
    - mode: '0644'

/etc/systemd/system/apt-daily.timer.d/override.conf:
  file.managed:
    - source: salt://apt/files/apt-daily.timer
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

/etc/systemd/system/apt-daily-upgrade.timer.d/override.conf:
  file.managed:
    - source: salt://apt/files/apt-daily-upgrade.timer
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
