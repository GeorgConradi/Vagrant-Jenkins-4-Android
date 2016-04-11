# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 9000, host: 9000
  
  # basic provisioning
  # config.vm.provision "shell", path: "scripts/basics.sh"
  config.vm.provision "shell" do |basics|
    basics.path = "scripts/basics.sh"
    #just to show how parameter passing would work
    basics.args   = Time.now.getutc.to_s
  end
  
  # provision JENKINS
  # provide file containing list of plugins
  config.vm.provision "file", source: "./scripts/jenkins_plugins.txt", destination: "jenkins_plugins.txt"
  # config.vm.provision "shell", path: "scripts/jenkins.sh"
  config.vm.provision "shell" do |jenkins|
    jenkins.path = "scripts/jenkins.sh"
    #just to show how parameter passing would work
    jenkins.args   = Time.now.getutc.to_s
  end
end
