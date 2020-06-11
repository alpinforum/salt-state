moreutils:
  pkg.installed

https://github.com/prometheus-community/node-exporter-textfile-collector-scripts.git:
  git.latest:
    - target: /opt/node-cron-collector
    - force_fetch: true
    - force_reset: true

https://github.com/janw/node-exporter-textfile-collector-scripts.git:
  git.latest:
    - target: /opt/node-cron-collector-alternative
    - force_fetch: true
    - force_reset: true

# APT
apt-collector:
  cron.present:
    - identifier: apt-collector
    - name: '/opt/node-cron-collector/apt.sh | sponge /var/prometheus/apt.prom'
    - minute: random
    - require:
      - git: https://github.com/prometheus-community/node-exporter-textfile-collector-scripts.git

{% if 'btrfs' in salt['pillar.get']('roles',[]) %}
# BTRFS
btrfs-cron-old:
  cron.absent:
    - name: '/opt/node-cron-collector/btrfs_stats.py | sponge /var/prometheus/btrfs.prom'
    - minute: '*/5'

btrfs-collector-cron:
  cron.present:
    - identifier: btrfs-collector
    - name: '/opt/node-cron-collector/btrfs_stats.py | sponge /var/prometheus/btrfs.prom'
    - minute: '*/5'
    - require:
      - git: https://github.com/prometheus-community/node-exporter-textfile-collector-scripts.git

{% endif %}

{% if 'ipmi' in salt['pillar.get']('roles',[]) %}
# IPMI
ipmitool:
  pkg.installed

ipmi-collector-old:
  cron.absent:
    - name: 'ipmitool sensor | /opt/node-cron-collector/ipmitool | sponge /var/prometheus/ipmi.prom'
    - minute: '*/5'

ipmi-collector-cron:
  cron.present:
    - identifier: ipmi-collector
    - name: 'ipmitool sensor | /opt/node-cron-collector/ipmitool | sponge /var/prometheus/ipmi.prom 2>/dev/null'
    - minute: '*/5'
    - require:
      - git: https://github.com/prometheus-community/node-exporter-textfile-collector-scripts.git
{% endif %}
{% if 'smart' in salt['pillar.get']('roles',[]) %}
# Smart
smart-collector-old:
  cron.absent:
    - name: 'PATH=$PATH:/usr/sbin; /opt/node-cron-collector-alternative/smartmon.sh | sponge /var/prometheus/smart.prom'
    - minute: '*/5'

smart-collector-cron:
  cron.present:
    - identifier: smart-collector
    - name: 'PATH=$PATH:/usr/sbin; /opt/node-cron-collector-alternative/smartmon.sh | sponge /var/prometheus/smart.prom'
    - minute: '*/5'
    - require:
      - git: https://github.com/janw/node-exporter-textfile-collector-scripts.git

{% endif %}
