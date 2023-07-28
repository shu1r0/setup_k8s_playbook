# vm name prefix
$name_prefix = "k8s-ansible-"

# enable vm gui
$gui = false


# ------------------------------------------------------------
# Description
# ------------------------------------------------------------
$description = <<'EOS'
# Vagrantfile for ansible

## User and Password
user: vagrant
password: vagrant
EOS


# ------------------------------------------------------------
# vagrant configuration
# ------------------------------------------------------------
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vbguest.auto_update = false

  config.vm.synced_folder './', '/home/vagrant/share', mount_options: ["dmode=775,fmode=664"]

  config.vm.provision "shell", path: "scripts/common.sh"

  # ----------- Workers -----------
  worker1_name = $name_prefix + "worker1"
  config.vm.define worker1_name do |worker|
    worker.vm.hostname = "worker1"
    worker.vm.box = "ubuntu/focal64"

    worker.vm.network "private_network",virtualbox__intnet: "inet0", ip: "192.168.100.12", netmask:"255.255.255.0"

    worker.vm.provision "shell", path: "scripts/setup_worker.sh"
    worker.vm.provision 'shell', inline: <<-SCRIPT
      echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
      sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
      sudo  systemctl restart sshd
    SCRIPT

    worker.vm.provider "virtualbox" do |vb|
      vb.name = worker1_name
      vb.gui = $gui
      vb.cpus = 2
      vb.memory = 2048
      vb.customize [
        "modifyvm", :id,
        "--vram", "32", 
        "--clipboard", "bidirectional",
        "--draganddrop", "bidirectional",
        "--ioapic", "on",
        '--graphicscontroller', 'vmsvga',
        "--accelerate3d", "off",
        "--hwvirtex", "on",
        "--nestedpaging", "on",
        "--largepages", "on",
        "--pae", "on",
        '--audio', 'none',
        "--uartmode1", "disconnected",
        "--description", $description
      ]
    end
  end

  worker2_name = $name_prefix + "worker2"
  config.vm.define worker2_name do |worker|
    worker.vm.hostname = "worker2"
    worker.vm.box = "ubuntu/focal64"

    worker.vm.network "private_network",virtualbox__intnet: "inet0", ip: "192.168.100.13", netmask:"255.255.255.0"

    worker.vm.provision "shell", path: "scripts/setup_worker.sh"
    worker.vm.provision 'shell', inline: <<-SCRIPT
      echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
      sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
      sudo systemctl restart sshd
    SCRIPT

    worker.vm.provider "virtualbox" do |vb|
      vb.name = worker2_name
      vb.gui = $gui
      vb.cpus = 2
      vb.memory = 2048
      vb.customize [
        "modifyvm", :id,
        "--vram", "32", 
        "--clipboard", "bidirectional",
        "--draganddrop", "bidirectional",
        "--ioapic", "on",
        '--graphicscontroller', 'vmsvga',
        "--accelerate3d", "off",
        "--hwvirtex", "on",
        "--nestedpaging", "on",
        "--largepages", "on",
        "--pae", "on",
        '--audio', 'none',
        "--uartmode1", "disconnected",
        "--description", $description
      ]
    end
  end

  # ----------- Master -----------
  master_name = $name_prefix + "master"
  config.vm.define master_name do |master|
    master.vm.hostname = "master"
    master.vm.box = "ubuntu/focal64"

    master.vm.network "private_network",virtualbox__intnet: "inet0", ip: "192.168.100.11", netmask:"255.255.255.0"

    master.vm.provision "shell", path: "scripts/setup_master.sh"
    master.vm.provision 'shell', inline: "cd /home/vagrant/share; ansible-playbook -i vagrant-hosts.yml playbooks/setup_k8s.yml"

    master.vm.provider "virtualbox" do |vb|
      vb.name = master_name
      vb.gui = $gui
      vb.cpus = 1
      vb.memory = 1024
      vb.customize [
        "modifyvm", :id,
        "--vram", "32", 
        "--clipboard", "bidirectional",
        "--draganddrop", "bidirectional",
        "--ioapic", "on",
        '--graphicscontroller', 'vmsvga',
        "--accelerate3d", "off",
        "--hwvirtex", "on",
        "--nestedpaging", "on",
        "--largepages", "on",
        "--pae", "on",
        '--audio', 'none',
        "--uartmode1", "disconnected",
        "--description", $description
      ]
    end
  end
  
end