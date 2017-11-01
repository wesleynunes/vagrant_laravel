Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
    config.vm.hostname = "laravelxenial"
    config.vm.network :private_network, ip: "192.168.33.97" 
    config.vm.synced_folder("./", "/var/www/html", :nfs => true)
    config.vm.provider "virtualbox" do |machine|
    	machine.memory = 2024
        machine.cpus = 2
    	machine.name = "laravelxenial"
    end
    config.vm.provision :shell, path: "setup.sh"
end
