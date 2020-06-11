{%- from 'prometheus/map.jinja' import prometheus with context -%}
include:
  - prometheus.common

prometheus tarball:
  archive.extracted:
    - source: https://github.com/prometheus/prometheus/releases/download/v{{ prometheus['release'] }}/prometheus-{{ prometheus['release'] }}.linux-amd64.tar.gz
    - source_hash: sha256={{ prometheus['release_hash'] }}
    - if_missing: /opt/prometheus-{{ prometheus['release'] }}.linux-amd64
    - name: /opt
    - user: root
    - group: root
    - watch_in:
      - service: prometheus.service
    - require_in:
      - service: prometheus.service

/etc/prometheus/rules:
  file.recurse:
    - source: salt://prometheus/files/prometheus/rules
    - file_mode: '0644'
    - user: root
    - group: root
    - dir_mode: '0755'
    - watch_in:
      - service: prometheus.service
    - require_in:
      - service: prometheus.service

/etc/prometheus/prometheus.yml:
  file.managed:
    - source: salt://prometheus/files/prometheus/prometheus.yml.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - /etc/prometheus
    - watch_in:
      - service: prometheus.service
    - require_in:
      - service: prometheus.service

/etc/default/prometheus:
  file.managed:
    - source: salt://prometheus/files/prometheus/prometheus
    - user: root
    - group: root
    - mode: '0644'
    - watch_in:
      - service: prometheus.service
    - require_in:
      - service: prometheus.service

/etc/systemd/system/prometheus.service:
  file.managed:
    - source: salt://prometheus/files/prometheus/prometheus.service.j2
    - template: jinja
    - require:
      - archive: prometheus tarball
    - watch_in:
      - service: prometheus.service
    - require_in:
      - service: prometheus.service

prometheus.service:
  service.running:
    - enable: True
    - reload: True
    - require:
      - /etc/prometheus
    - watch:
      - /etc/prometheus
