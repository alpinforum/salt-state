ssh-authorized-keys:
  file.append:
    - name: /root/.ssh/authorized_keys
    - makedirs: true
    - text:
{% for key in salt['pillar.get']('admin:ssh:authorized_keys', []) %}
      - {{ key }}
{% endfor %}
