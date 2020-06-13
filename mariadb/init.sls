nginx-repo:
  pkgrepo.managed:
    - humanname: mariadb
    - name: deb http://ftp.hosteurope.de/mirror/mariadb.org/repo/10.4/debian {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/mariadb.list
    - clean_file: True
    - key_url: https://mariadb.org/mariadb_release_signing_key.asc

