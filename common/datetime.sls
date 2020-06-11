include:
  - systemd

Europe/Berlin:
  timezone.system:
    - utc: {{ salt['pillar.get']('timezone', True) }}
    - require:
      - pkg: dbus
