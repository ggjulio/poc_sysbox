Vagrant.configure("2") do |config|
    config.vm.box = "debian/bullseye64"

    config.vm.provider "virtualbox" do |vb|    
        vb.cpus = 4
        vb.memory = 8096
    end

    config.vm.synced_folder ".", "/home/vagrant/app", type: "virtualbox"
    config.vm.provision "shell", name: "Setting up VM", privileged: false,  inline: <<-SHELL
        set -eux
            
        sudo apt-get update
        sudo apt-get install ca-certificates curl gnupg

        # Install docker
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg

        echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt-get update
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



        sudo dnf -y install dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        sudo systemctl start docker
        sudo systemctl enable docker.service
        sudo systemctl enable containerd.service

        sudo groupadd docker || :
        sudo usermod -aG docker "${USER}"
        newgrp docker
        # docker ps 
        
    SHELL
        
    config.vm.provision "shell", name: "Install sysbox", privileged: false,  inline: <<-SHELL
        set -eux
        
        # Install sysbox && configure docker+sysbox
        docker ps
        sudo dnf install -y jq rsync git make
        git clone --recursive https://github.com/nestybox/sysbox.git
        (
            cd sysbox
            # TODO pin to specific version using git checkout $VERSION_RELEASE (ex release_v0.6.1)
            make sysbox # parallel works ? -j
            sudo make install
            sudo ./scr/docker-cfg \
                --sysbox-runtime=enable \
                --default-runtime=sysbox-runc \
                --userns-remap=disable \
                --force-restart \
                --verbose
                # userns-remap mode ?
                # TODO rootless
            sudo systemctl restart docker
            sudo /usr/bin/sysbox # TODO unecessary ? also, systemd enable ?
        )
        rm -rf sysbox
        sudo dnf uninstall -y git make
        sudo cat /var/log/sysbox-mgr.log
        echo done
    SHELL

end
