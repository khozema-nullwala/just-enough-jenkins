# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  # To Setup the Jenkins Lab environment
  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = "ubuntu/xenial64"
    jenkins.vm.hostname = "jenkins.example.com"
    jenkins.vm.network "private_network", ip: "172.16.1.100"
    jenkins.vm.provider "virtualbox" do |v|
      v.name = "jenkins"
      v.memory = 5120
      v.cpus = 2
    end
  end
end