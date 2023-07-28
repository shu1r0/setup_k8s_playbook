# Kubernetes setup with ansible

This repository uses ansible to set up Kubernetes clusters.


## usage
```
ansible-playbook -i vagrant-hosts.yml playbooks/setup_k8s.yml
```

## vagrant test
- Inventory file: `vagrant-hosts.yml`
- Playbooks: `setup_k8s.yml`
```
vagrant up
```
