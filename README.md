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

## References
- [Kubernetes Setup Using Ansible and Vagrant | kubernetes](https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/)
