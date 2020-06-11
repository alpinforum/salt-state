systemd_pkgs:
  pkg.latest:
{%- if grains['osfinger'] == "Debian-9" %}
    - fromrepo: stretch-backports
    - require:
      - pkgrepo: stretch-backports
{%- endif %}
    - pkgs:
      - systemd
      - libpam-systemd

dbus:
  pkg.installed

# systemctl daemon-reload if anything changed
service.systemctl_reload:
  module.run:
    - onchanges:
      - file: /etc/systemd/system/*

# disable some services inside lxc
{%- if salt['grains.get']('virtual','physical') == 'LXC' %}
sys-kernel-config.mount:
  service.dead:
    - enable: False

sys-kernel-debug.mount:
  service.disabled
{% endif %}
