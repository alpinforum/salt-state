{% set sysctld = "/etc/sysctl.d" %}

net.netfilter.nf_conntrack_max:
  sysctl.present:
    - value: 256000
    - config: {{ sysctld }}/conntrack.conf

/etc/ferm/ferm.conf:
  file.managed:
    - source: salt://ferm/files/ferm-stateful.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
    - template: jinja
