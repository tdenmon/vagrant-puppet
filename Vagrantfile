Vagrant.require_version ">= 1.5.0"
require 'vagrant-hosts'
require 'vagrant-auto_network'

Vagrant.configure('2') do |config|

  config.vm.define :puppetmaster do |node|
    # An index of pre-built boxes can be found at:
    #
    #   https://vagrantcloud.com/puppetlabs
    node.vm.box = 'puppetlabs/ubuntu-14.04-64-puppet'

    node.vm.hostname = 'puppetmaster.puppetdebug.vlan'

    # Use vagrant-auto_network to assign an IP address.
    node.vm.network :private_network, :auto_network => true

    # Puppet Server requires a bit more memory, so tweak to suit
    node.vm.provider "virtualbox" do |v|
      v.customize [
        "modifyvm", :id,
        "--memory", "1024"
      ]
    end

    # Use vagrant-hosts to add entries to /etc/hosts for each virtual machine
    # in this file.
    node.vm.provision :hosts

    # Bootstrap the latest version of Puppet Server on Ubuntu and Set up a Puppet Server
    # that automatically signs certs from agents.
    #
    # For operating systems other than CentOS 6, a collection of bootstrap
    # scripts can be found here:
    #
    #   https://github.com/hashicorp/puppet-bootstrap
    #
    # The Puppet Labs installation docs also have some useful pointers:
    #
    #   http://docs.puppetlabs.com/guides/installation.html#installing-puppet-1
    bootstrap_script = <<-EOF
    if dpkg -s puppetserver > /dev/null 2>&1; then
      echo 'Puppet Server Installed.'
    else
      echo 'Installing Puppet Server.'
      apt-get update && apt-get install puppetserver -y
      echo '*.puppetdebug.vlan' > /etc/puppetlabs/puppet/autosign.conf
      sed -i 's/^JAVA_ARGS.*/JAVA_ARGS="-Xms512m -Xmx512m"/g' /etc/default/puppetserver
      puppet resource service puppetserver ensure=running enable=true
    fi
    EOF
    node.vm.provision :shell, :inline => bootstrap_script
  end

  config.vm.define :puppetagent do |node|
    node.vm.box = 'puppetlabs/ubuntu-14.04-64-puppet'

    node.vm.hostname = 'puppetagent.puppetdebug.vlan'

    node.vm.network :private_network, :auto_network => true
    node.vm.provision :hosts

    # Set up Puppet Agent to automatically connect with Puppet master
    bootstrap_script = <<-EOF
    if which puppet > /dev/null 2>&1; then
      echo 'Puppet Installed.'
    else
      echo 'Installing Puppet Agent.'
      apt-get udpate && apt-get install puppet -y
      puppet config set --section main server puppetmaster.puppetdebug.vlan
    fi
    if ! grep server /etc/puppetlabs/puppet/puppet.conf > /dev/null 2>&1; then
      echo 'Setting Server.'
      puppet config set --section main server puppetmaster.puppetdebug.vlan
    fi
    EOF
    node.vm.provision :shell, :inline => bootstrap_script
  end

end
