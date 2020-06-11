/usr/local/sbin/checkrestart_exporter.sh:
  file.managed:
    - source: salt://prometheus/files/checkrestart_exporter.sh
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - prometheus-node-exporter.service


/etc/systemd/system/checkrestart_exporter.service:
  file.managed:
    - source: salt://prometheus/files/checkrestart_exporter.service
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: /usr/local/sbin/checkrestart_exporter.sh

/etc/apt/apt.conf.d/100-post-upgrade-checkrestart-prom:
  file.managed:
    - contents: "DPkg::Post-Invoke-Success { \"/bin/systemctl start checkrestart_exporter.service\"; };"
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: /usr/local/sbin/checkrestart_exporter.sh

/etc/systemd/system/checkrestart_exporter.timer:
   file.managed:
     - source: salt://prometheus/files/checkrestart_exporter.timer
     - user: root
     - group: root
     - mode: '0644'
     - require:
       - file: /usr/local/sbin/checkrestart_exporter.sh

checkrestart_exporter.timer:
  service.running:
    - enable: True
    - require:
      - file: /etc/tmpfiles.d/prometheus-node-exporter-textfiles.conf
      - file: /etc/systemd/system/checkrestart_exporter.service
      - file: /etc/systemd/system/checkrestart_exporter.timer
