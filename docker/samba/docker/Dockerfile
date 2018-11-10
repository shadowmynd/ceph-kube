FROM ubuntu:18.04
LABEL MAINTAINER='Brandon M <brandon@shadowmynd.com>'

RUN apt update

RUN apt install -y samba

RUN echo $'\n \
[global]\n \
  workgroup = WORKGROUP\n \
  server string = %h\n \
  dns proxy = no\n \
  log file = /var/log/samba/log.%m\n \
  max log size = 1000\n \
  vfs objects = ceph\n \
  syslog = 1\n \
#  passdb backend = ldapsam:ldap://azuread\n \
  log level = 1 auth:5 winbind:5\n \
  panic action = /usr/share/samba/panic-action %d\n \
  server role = standalone server\n \
  unix password sync = no\n \
  usershare allow guests = no\n \
  guest ok = no\n \
[homes]\n \
  root preexec = /usr/local/samba/private/create_mount.sh %S\n \
  comment = User Directories\n \
  browseable = yes\n \
  read only = no\n \
  create mask = 0755\n \
  directory mask = 0755\n \
  path = /storage/%S\n \
  valid users = %S\n \
  ceph:user_id = %S\n \
  writable = yes\n \
    ' > /etc/samba/smb.conf && \
    service smbd stop

EXPOSE 137/udp 138/udp 139 445

HEALTHCHECK --interval=60s --timeout=15s \
             CMD smbclient -L '\\localhost' -U '%' -m SMB3

COPY samba.sh /usr/bin/

COPY create_mount.sh /usr/local/samba/private/

CMD [ "/usr/bin/samba.sh" ]