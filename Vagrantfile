require 'yaml'

settings = YAML.load_file 'vagrant_config.yml'

Vagrant.configure("2") do |config|

  config.vm.synced_folder ".", "/vagrant"
  config.vm.network :forwarded_port, host: 5433, guest: 5432
  config.vm.provision "shell", path: "provision.sh"

  # Provider LXC
  config.vm.provider :lxc do |lxc, config|
    config.vm.box = "fgrehm/trusty64-lxc"
    lxc.customize 'cgroup.memory.limit_in_bytes', '512M'
  end

  # Provider Virtualbox
  config.vm.provider :virtualbox do |vb, config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    vb.memory = 512
  end

  # Provider Digitalocean
  config.vm.provider :digital_ocean do |digital_ocean, config|
    config.vm.box = "digital_ocean"
    config.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    config.ssh.username = "vagrant"

    # the following setting are loaded from vagrant.yml file
    config.ssh.private_key_path = settings['digital_ocean']['private_key_path']
    digital_ocean.ssh_key_name = settings['digital_ocean']['ssh_key_name']
    digital_ocean.ca_path = settings['digital_ocean']['ca_path']
    digital_ocean.token = settings['digital_ocean']['token']
    digital_ocean.image = settings['digital_ocean']['image']
    digital_ocean.region = settings['digital_ocean']['region']
    digital_ocean.size = settings['digital_ocean']['size']
  end
end
