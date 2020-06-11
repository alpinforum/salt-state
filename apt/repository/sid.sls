include:
  - apt.dependencies

# dont' prefer sid over $release, but take upgrades where necessary
sid:
  pkgrepo.managed:
    - humanname: sid
    - name: deb http://mirror.23media.de/debian sid main
    - file: /etc/apt/sources.list.d/sid.list
    - clean_file: True
    - require:
      - file: /etc/apt/preferences.d/sid-pinning

/etc/apt/preferences.d/sid-pinning:
  file.managed:
    - source: salt://apt/files/sid-pinning.j2
    - template: jinja
