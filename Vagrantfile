# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #
  # Supports local cache, don't wast bandwitdh
  # vagrant plugin install vagrant-cachier
  # https://github.com/fgrehm/vagrant-cachier 
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end

  config.vm.provider "vmware_fusion" do |vmware|
    vmware.gui = false
    vmware.vmx["numvcpus"] = "1"
    vmware.vmx["memsize"] = "1024"
  end

  # Puppet Master
  config.vm.define :master do |master_config|

    # forward ssh keys (easy access to github etc)
    master_config.ssh.forward_agent = true

    # base image
    master_config.vm.hostname = "puppet.ms.dev"
    master_config.vm.box = "thinktainer/precise64"

    # net
    master_config.vm.network :private_network, ip: "192.168.33.10"
    master_config.vm.network "forwarded_port", guest: 8081, host: 8081

    # allow github connections for all accounts
    master_config.vm.provision :shell,
      inline:
        "KNOWN_HOSTS=/etc/ssh/ssh_known_hosts;
         touch $KNOWN_HOSTS &&\
         ssh-keyscan -H github.com >> $KNOWN_HOSTS &&\
         chmod 600 $KNOWN_HOSTS"

    # Provision puppet and r10k via shell script
    master_config.vm.provision :shell, :path => "puppet_master.sh"
    master_config.vm.provision :shell, :path => "puppet_r10k.sh"

    # Enable the Puppet provisioner
    master_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "VagrantConf/manifests"
      puppet.manifest_file  = "default.pp"
      puppet.options        = "--verbose --modulepath /home/vagrant/modules"
    end
  end
end
