{% set ferm_enabled = True %}

ferm_conf_init:
  file.directory:
    - name: /etc/ferm/conf.d
    - makedirs: true

/etc/ferm/conf.d:
  file.directory:
    - require:
      - file: ferm_conf_init
    - makedirs: true
    - clean: true
    - user: root
    - group: root

# recursively delete legacy ferm.d folder
/etc/ferm.d:
  file.absent:
    # execute this last to ensure we first reinstall our ferm setup
    - order: last

# this fixes issues with file globbing, see https://github.com/saltstack/salt/issues/24436
/etc/ferm/conf.d/.keep:
  file.managed:
    - replace: False
    - require_in:
      - file: /etc/ferm/conf.d

# deprecated: dependency issues on boot made us move to the systemd unit
/etc/default/ferm:
  file.managed:
    - source: salt://ferm/files/ferm

/etc/systemd/system/ferm.service:
  file.managed:
    - source: salt://ferm/files/ferm.service
    - user: root
    - group: root
    - mode: '0644'

ferm:
  pkg.installed:
    - pkgs:
      - ferm
      - libnet-dns-perl
{%- if ferm_enabled %}
ferm-service:
  service.running:
    - name: ferm
    - enable: True
    - require:
      - file: /etc/systemd/system/ferm.service
    - watch:
      - file: /etc/ferm/ferm.conf
      - file: /etc/ferm/conf.d/*
{%- else %}
ferm-service:
  service.dead:
    - name: ferm
    - enable: False
{%- endif %}

include:
  - ferm.stateful
