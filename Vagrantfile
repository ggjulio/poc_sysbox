Vagrant.configure("2") do |config|
    config.vm.box = "almalinux/9"

    config.vm.provider "virtualbox" do |vb|    
        vb.cpus = 4
        vb.memory = 8096
    end

    config.vm.synced_folder ".", "/home/vagrant/app", type: "virtualbox"
    config.vm.provision "shell", name: "Setting up VM", privileged: false,  inline: <<-SHELL
        set -eux
            
        sudo dnf update
    SHELL

    config.vm.provision "shell", name: "Setting up more things", privileged: false,  inline: <<-SHELL

    SHELL

end
