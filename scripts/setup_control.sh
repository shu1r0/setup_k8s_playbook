#!/bin/bash

TARGET_HOSTS=("master.local" "worker0.local" "worker1.local")

# install ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

sudo apt-get install -y sshpass

# key gen
ssh-keygen -t ed25519 -f /home/vagrant/.ssh/id_ed25519 -N ""
chmod 600 /home/vagrant/.ssh/id_ed25519
chown "vagrant:vagrant" /home/vagrant/.ssh/id_ed25519
sudo ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -N ""
sudo chmod 600 /root/.ssh/id_ed25519

for target in "${TARGET_HOSTS[@]}"; do
  # vagrant user key
  sshpass -p "vagrant" scp -o StrictHostKeyChecking=no /home/vagrant/.ssh/id_ed25519.pub vagrant@${target}:/home/vagrant/
  sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${target} "cat id_ed25519.pub | tee -a .ssh/authorized_keys"
  sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${target} "cat id_ed25519.pub | sudo tee -a /root/.ssh/authorized_keys"

  # root user key
  sudo sshpass -p "vagrant" scp -o StrictHostKeyChecking=no /root/.ssh/id_ed25519.pub vagrant@${target}:/home/vagrant/id_ed25519_root.pub
  sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${target} "cat id_ed25519_root.pub | tee -a .ssh/authorized_keys"
  sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${target} "cat id_ed25519_root.pub | sudo tee -a /root/.ssh/authorized_keys"
done
