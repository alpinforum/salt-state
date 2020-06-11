{{ saltenv }}:
  '*':
    - apt
    - apt.common-pkg
    - common.root
    - salt.minion
    - ssh.mosh
    #- ferm
    #- prometheus.node-exporter
    - systemd
    - logrotate
    - common.path
    # only on physical/kvm
    {%- if salt['grains.get']('virtual','physical') in ('physical','kvm') %}
    - common.datetime
    - common.haveged
    {%- endif %}
    {%- if salt['grains.get']('virtual','physical') in ('kvm') %}
    - common.kvm
    {%- endif %}
  'roles:salt-master':
    - match: pillar
    - salt.master
