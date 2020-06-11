{%- from 'prometheus/map.jinja' import prometheus with context -%}

include:
  - apt
  - prometheus.node-cron-collector
  - prometheus.checkrestart
  - ferm

prometheus-node-exporter:
  pkg.removed:
{%- if grains['osfinger'] == "Debian-9" %}
    - fromrepo: stretch-backports
    - require:
      - pkgrepo: stretch-backports
{%- endif %}
    - install_recommends: False
    - pkgs:
      - prometheus-node-exporter

node-exporter tarball:
  archive.extracted:
    - source: https://github.com/prometheus/node_exporter/releases/download/v{{ prometheus['node_exporter_release'] }}/node_exporter-{{ prometheus['node_exporter_release'] }}.linux-amd64.tar.gz
    - source_hash: sha256={{ prometheus['node_exporter_hash'] }}
    - if_missing: /opt/node_exporter-{{ prometheus['node_exporter_release'] }}.linux-amd64
    - name: /opt
    - user: root
    - group: root
    - watch_in:
      - service: prometheus-node-exporter.service

/etc/default/prometheus-node-exporter:
  file.managed:
    - source: salt://prometheus/files/prometheus-node-exporter
    - user: root
    - group: root
    - mode: '0644'

/etc/systemd/system/prometheus-node-exporter.service:
  file.managed:
    - source: salt://prometheus/files/prometheus-node-exporter.service.j2
    - template: jinja
    - watch_in:
      - service: prometheus-node-exporter.service

prometheus-node-exporter.service:
  service.running:
    - enable: True
    - require:
      - archive: node-exporter tarball
      - /etc/systemd/system/prometheus-node-exporter.service
      - /etc/default/prometheus-node-exporter
    - watch:
      - /etc/default/prometheus-node-exporter
      - node-exporter tarball

/etc/tmpfiles.d/prometheus-node-exporter-textfiles.conf:
  file.managed:
   - contents: |
           #Type Path                                     Mode UID  GID  Age Argument
           d     /run/prometheus-node-exporter/textfiles/ 0755 root root -   -
   - user: root
   - group: root
   - mode: '0644'
   - require:
     - pkg: prometheus-node-exporter

/var/prometheus:
  file.directory

reload tmpfiles:
  cmd.run:
    - name: systemd-tmpfiles --create
    - onchanges:
      - file: /etc/tmpfiles.d/prometheus-node-exporter-textfiles.conf

/etc/ferm/conf.d/40-prometheus.conf:
  file.managed:
    - source: salt://prometheus/files/node-exporter/ferm.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - pkg: ferm
    - require_in:
      - file: /etc/ferm/conf.d
