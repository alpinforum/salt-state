include:
  - apt.https
  - apt.unattended-upgrades


{% if grains['osfinger'] == "Debian-9" %}
/etc/apt/sources.list:
  file.managed:
    - contents: |
        deb http://mirror.23media.de/debian stretch main contrib non-free
        deb-src http://mirror.23media.de/debian stretch main

        deb http://security.debian.org/debian-security stretch/updates main contrib non-free
        deb-src http://security.debian.org/debian-security stretch/updates main

        deb http://mirror.23media.de/debian stretch-updates main contrib non-free
        deb-src http://mirror.23media.de/debian stretch-updates main

stretch-backports:
  pkgrepo.managed:
    - name: deb http://mirror.23media.de/debian stretch-backports main contrib non-free
    - file: /etc/apt/sources.list.d/backports.list
    - clean_file: True
{% else %}
stretch-backports:
  pkgrepo.absent
{% endif %}

{% if grains['osfinger'] == "Debian-10" %}
/etc/apt/sources.list:
  file.managed:
    - contents: |
        deb http://mirror.23media.de/debian buster main contrib non-free
        deb-src http://mirror.23media.de/debian buster main

        deb http://security.debian.org/debian-security buster/updates main contrib non-free
        deb-src http://security.debian.org/debian-security buster/updates main

        deb http://mirror.23media.de/debian buster-updates main contrib non-free
        deb-src http://mirror.23media.de/debian buster-updates main

buster-backports:
  pkgrepo.managed:
    - name: deb http://mirror.23media.de/debian buster-backports main contrib non-free
    - file: /etc/apt/sources.list.d/backports.list
    - clean_file: True
{% else %}
buster-backports:
  pkgrepo.absent
{% endif %}
