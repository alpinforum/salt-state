prometheus_user:
  user.present:
    - name: prometheus
    - home: /etc/prometheus

/etc/prometheus:
  file.directory:
    - user: prometheus
    - group: prometheus
    - require:
      - prometheus_user
