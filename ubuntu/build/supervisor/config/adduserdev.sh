#!/bin/bash
passrd() {
    local password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-20} | head -n 1);
    echo $password;
}

adduserdev() {
    if [ `id -u $1 2>/dev/null || echo -1` -ge 0 ]; then
      echo "User $1 already exists"
    else
      passrd=$(passrd);
      adduser $1 --gecos "" --disabled-password;
      adduser $1 devs;

      if [ ! -d "/home/$1/.ssh" ]; then
          sudo -u $1 mkdir /home/$1/.ssh
          sudo -Hu $1 touch /home/$1/.ssh/authorized_keys
          ssh-keygen -t rsa -b 4096 -f /tmp/random -q -N "$passrd"
          cat /tmp/random.pub >> /home/$1/.ssh/authorized_keys
          printf "Copy private content below to ssh file\n\n"
          cat /tmp/random
          rm /tmp/random.pub /tmp/random
          printf "\n\nUsername with passphrase: $1 / $passrd\n";
      else
          chown -R $1:$1 /home/$1
      fi
    fi
}

if [[ "$(whoami)" != "root" ]]; then
  echo "You need sudo permission to run this command"
  exit 1
else
  adduserdev $1
fi