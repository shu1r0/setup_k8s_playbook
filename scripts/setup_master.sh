#!/bin/bash

WORKER1="worker1.local"
WORKER2="worker2.local"


sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

sudo apt-get install -y sshpass

# vagrant user key
ssh-keygen -t ed25519 -f /home/vagrant/.ssh/id_ed25519 -N ""
sudo chmod 600 /home/vagrant/.ssh/id_ed25519
sudo chown "vagrant:vagrant" /home/vagrant/.ssh/id_ed25519
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no /home/vagrant/.ssh/id_ed25519.pub vagrant@${WORKER1}:/home/vagrant/
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${WORKER1} "cat id_ed25519.pub | tee -a .ssh/authorized_keys"
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${WORKER1} "cat id_ed25519.pub | sudo tee -a /root/.ssh/authorized_keys"
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no /home/vagrant/.ssh/id_ed25519.pub vagrant@${WORKER2}:/home/vagrant/
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${WORKER2} "cat id_ed25519.pub | tee -a .ssh/authorized_keys"
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${WORKER2} "cat id_ed25519.pub | sudo tee -a /root/.ssh/authorized_keys"

# root user key
sudo ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -N ""
sudo chmod 600 /root/.ssh/id_ed25519
sudo sshpass -p "vagrant" scp -o StrictHostKeyChecking=no /root/.ssh/id_ed25519.pub vagrant@${WORKER1}:/home/vagrant/id_ed25519_root.pub
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${WORKER1} "cat id_ed25519_root.pub | tee -a .ssh/authorized_keys"
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${WORKER1} "cat id_ed25519_root.pub | sudo tee -a /root/.ssh/authorized_keys"
sudo sshpass -p "vagrant" scp -o StrictHostKeyChecking=no /root/.ssh/id_ed25519.pub vagrant@${WORKER2}:/home/vagrant/id_ed25519_root.pub
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${WORKER2} "cat id_ed25519_root.pub | tee -a .ssh/authorized_keys"
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@${WORKER2} "cat id_ed25519_root.pub | sudo tee -a /root/.ssh/authorized_keys"
