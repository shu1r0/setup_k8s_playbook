# vm name prefix
$name_prefix = "k8s-"

# enable vm gui
$gui = false

# ------------------------------------------------------------
# options
# ------------------------------------------------------------
$description = <<'EOS'
# Vagrantfile for ansible

## User and Password
user: vagrant
password: vagrant
EOS

$customize_options = [
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

# ------------------------------------------------------------
# vagrant configuration
# ------------------------------------------------------------
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vbguest.auto_update = false
  config.vm.synced_folder './', '/home/vagrant/share', mount_options: ["dmode=775,fmode=664"]
  config.vm.provision "shell", path: "scripts/common.sh"

  # ----------- k8s master -----------
  master_name = $name_prefix + "master"
  config.vm.define master_name do |worker|
    worker.vm.hostname = "master"
    worker.vm.box = "ubuntu/focal64"

    worker.vm.network "private_network",virtualbox__intnet: "inet0", ip: "192.168.100.12", netmask:"255.255.255.0"

    worker.vm.provision 'shell', inline: <<-SCRIPT
      echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
      sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
      sudo  systemctl restart sshd
    SCRIPT

    worker.vm.provider "virtualbox" do |vb|
      vb.name = master_name
      vb.gui = $gui
      vb.cpus = 2
      vb.memory = 2048
      vb.customize $customize_options
    end
  end

  # ----------- k8s workers -----------
  worker0_name = $name_prefix + "worker0"
  config.vm.define worker0_name do |worker|
    worker.vm.hostname = "worker0"
    worker.vm.box = "ubuntu/focal64"

    worker.vm.network "private_network",virtualbox__intnet: "inet0", ip: "192.168.100.13", netmask:"255.255.255.0"

    worker.vm.provision 'shell', inline: <<-SCRIPT
      echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
      sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
      sudo systemctl restart sshd
    SCRIPT

    worker.vm.provider "virtualbox" do |vb|
      vb.name = worker0_name
      vb.gui = $gui
      vb.cpus = 2
      vb.memory = 2048
      vb.customize $customize_options
    end
  end

  worker1_name = $name_prefix + "worker1"
  config.vm.define worker1_name do |worker|
    worker.vm.hostname = "worker1"
    worker.vm.box = "ubuntu/focal64"

    worker.vm.network "private_network",virtualbox__intnet: "inet0", ip: "192.168.100.14", netmask:"255.255.255.0"

    worker.vm.provision 'shell', inline: <<-SCRIPT
      echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
      sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
      sudo systemctl restart sshd
    SCRIPT

    worker.vm.provider "virtualbox" do |vb|
      vb.name = worker1_name
      vb.gui = $gui
      vb.cpus = 2
      vb.memory = 2048
      vb.customize $customize_options
    end
  end

  # ----------- control node (ansible) -----------
  control_name = $name_prefix + "control"
  config.vm.define control_name do |control|
    control.vm.hostname = "control"
    control.vm.box = "ubuntu/focal64"

    control.vm.network "private_network",virtualbox__intnet: "inet0", ip: "192.168.100.11", netmask:"255.255.255.0"

    control.vm.provision "shell", path: "scripts/setup_control.sh"
    control.vm.provision 'shell', inline: "cd /home/vagrant/share; ansible-playbook -i vagrant-hosts.yml setup_k8s.yml"

    control.vm.provider "virtualbox" do |vb|
      vb.name = control_name
      vb.gui = $gui
      vb.cpus = 1
      vb.memory = 1024
      vb.customize $customize_options
    end
  end
end
