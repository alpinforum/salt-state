include:
  - apt.https
  - apt.dependencies

saltstack-repo:
  pkgrepo.managed:
    - humanname: repo.saltstack.com
{%- if grains['osfinger'] == 'Debian-9' %}
    - name: deb http://repo.saltstack.com/py3/debian/9/amd64/latest/ stretch main
{%- else %}
    - name: deb http://repo.saltstack.com/py3/debian/10/amd64/latest/ buster main
{%- endif %}
    - file: /etc/apt/sources.list.d/saltstack.list
    - clean_file: True
{%- if grains['osfinger'] == 'Debian-9' %}
    - key_url: https://repo.saltstack.com/py3/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub
{%- else %}
    - key_url: https://repo.saltstack.com/py3/debian/10/amd64/latest/SALTSTACK-GPG-KEY.pub
{%- endif %}
    - require:
      - pkg: python-apt
      - pkg: apt-transport-https
