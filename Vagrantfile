# -*- mode: ruby -*-
# vi: set ft=ruby :

valley_disk = './valley_disk.vdi'
mountain_disk = './mountain_disk.vdi'


Vagrant.configure("2") do |config|
  #! Do this before using: vagrant plugin install vagrant-cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
    config.cache.scope       = :box
  end

  #! Do this before using: vagrant plugin install vagrant-hostmanager
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  #! config.vm.provision "shell",
  #!   inline: "yum upgrade -y puppet" #! Remove for production!!!

  config.vm.synced_folder "..", "/sandbox"
  config.vm.synced_folder "../tada-tools/dev-scripts", "/dbin"
  config.vm.synced_folder "../../logs", "/logs"
  config.vm.synced_folder "../../data", "/data"
  # WARNING: DMO is using puppet version 3.8.6  (not version 4.*)
  # Uses Puppet version 4.3.2
  #!config.vm.box     = 'puppetlabs/centos-6.6-64-puppet'
  #!config.vm.box_url = 'https://atlas.hashicorp.com/puppetlabs/boxes/centos-6.6-64-puppet'
  config.vm.box     = 'vStone/centos-6.x-puppet.3.x'
  config.vm.box_url = 'https://atlas.hashicorp.com/vStone/boxes/centos-6.x-puppet.3.x'
  
  # Attempt to speed up connection to remote hosts
  # (e.g. connection to MARS services)
  config.vm.provider :virtualbox do |vb|
    # No luck with this pair; doesn't break, but still slow
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    #vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

    # Try this; won't boot from chimp16
    #vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
  end    
  

  config.vm.define "mountain" do |mountain|
    mountain.vm.network :private_network, ip: "172.16.1.11"
    mountain.vm.hostname = "mountain.test.noao.edu" 
    mountain.hostmanager.aliases =  %w(mountain)

    # COMMENT OUT TO SPEED VM CREATION (if small disk is good enough)
    # disk to use for cache
    #! mountain.vm.provider "virtualbox" do | v |
    #!   v.customize ['createhd', '--filename', mountain_disk,
    #!                '--size', 200 * 1024]
    #!   # list all controllers: "VBoxManage  list vms --long"
    #!   v.customize ['storageattach', :id, '--storagectl', 'IDE Controller',
    #!                '--port', 1, '--device', 0, '--type', 'hdd',
    #!                '--medium', mountain_disk]
    #! end
    #! mountain.vm.provision "shell", path: "disk2.sh"

    
    mountain.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path = ["modules", "../puppet-modules"]
      puppet.environment_path = "environments"
      puppet.environment = "pat"
      puppet.options = [
       '--verbose',
       '--report',
       '--show_diff',
       '--pluginsync',
       '--hiera_config /vagrant/hiera.yaml',
       #!'--debug', #+++ #! Remove for production!!!
       #'--graph',
       #'--graphdir /vagrant/graphs/mountain',
      ]
    end
  end

  config.vm.define "valley" do |valley|
    valley.vm.network :private_network, ip: "172.16.1.12"
    valley.vm.hostname = "valley.test.noao.edu"
    valley.hostmanager.aliases =  %w(valley)

    # COMMENT OUT TO SPEED VM CREATION
    # disk to use for cache
    #!valley.vm.provider "virtualbox" do | v |
    #!  v.customize ['createhd', '--filename', valley_disk,
    #!               '--size', 200 * 1024,  # megabytes
    #!              ]
    #!  # list all controllers: "VBoxManage  list vms --long"
    #!  v.customize ['storageattach', :id, '--storagectl', 'IDE Controller',
    #!               '--port', 1, '--device', 0, '--type', 'hdd',
    #!               '--medium', valley_disk]
    #!end
    #!valley.vm.provision "shell", path: "disk2.sh"

      
    valley.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "site.pp" 
      puppet.module_path = ["modules", "../puppet-modules"]
      puppet.environment_path = "environments"
      puppet.environment = "pat"
      puppet.options = [
       '--verbose',
       '--report',
       '--show_diff',
       '--pluginsync',
       '--hiera_config /vagrant/hiera.yaml',
       #!'--debug', #+++
       #'--graph',
       #'--graphdir /vagrant/graphs/valley',
      ]
    end
  end

  config.vm.define "mars" do |mars|
    mars.vm.network :private_network, ip: "172.16.1.13"
    mars.vm.hostname = "mars.test.noao.edu" 
    mars.hostmanager.aliases =  %w(mars)
    
    mars.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path = ["modules", "../puppet-modules"]
      puppet.environment_path = "environments"
      puppet.environment = "pat"
      puppet.options = [
        #!'--debug', #+++
        '--verbose',
        '--report',
        '--show_diff',
        '--pluginsync',
        '--hiera_config /vagrant/hiera.yaml',
      ]
    end
  end

end

