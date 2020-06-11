/etc/ssh/sshd_config:
  file.append:
    - text: |
        Subsystem sftp internal-sftp

        Match Group sftp
          ChrootDirectory %h
          ForceCommand internal-sftp
          AllowTcpForwarding no

sftp-group:
  group.present:
    - name: sftp

{%- for name, user in salt['pillar.get']('sftp',{}).items() %}
sftp_{{name}}:
  user.present:
    - name: {{ name }}
    - groups:
      - sftp
      {%- for group in user.groups %}
      - {{ group }}
      {%- endfor %}
    - home: {{ user.directory }}
    - shell: /bin/false
    - password: {{ user.password }}

{{user.directory}}:
  file.directory:
    - makedirs: True
    - mode: 755
    - user: root
    - group: root
{%- endfor %}
