SYSBOX_VERSION='0.6.1'
SYSBOX_URL="https://downloads.nestybox.com/sysbox/releases/v#{SYSBOX_VERSION}/sysbox-ce_#{SYSBOX_VERSION}-0.linux_amd64.deb"
SYSBOX_SHA='d57dc297c60902d4f7316e4f641af00a2a9424e24dde88bb2bb7d3bc419b0f04'

Vagrant.configure("2") do |config|
    config.vm.box = "debian/bullseye64"
    config.vagrant.plugins = "vagrant-reload"

    config.vm.provider "virtualbox" do |vb|    
        vb.cpus = 4
        vb.memory = 8096
    end

    config.vm.synced_folder ".", "/home/vagrant/poc_sysbox", type: "virtualbox"
    config.vm.provision "shell", name: "Setting up VM", privileged: false,  inline: <<-SHELL
        set -eux
            
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg

        # Install docker
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg

        echo \
            "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
            "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" \
            | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


        sudo systemctl start docker
        sudo systemctl enable docker.service
        sudo systemctl enable containerd.service

        cat /etc/group | grep docker # Docker group should be created automatication
        sudo docker ps

        # Upgrade kernel to version >= 5.12 (to avoid he need of shiftfs)
        uname -r
        echo deb http://deb.debian.org/debian buster-backports main contrib non-free \
            | sudo tee /etc/apt/sources.list.d/buster-backports.list
        sudo apt-get update
        sudo apt install -y -t buster-backports linux-image-amd64
        uname -r
        sudo shutdown -r now
        
        
    SHELL

    config.vm.provision :reload # reload for kernel version upgrade

    config.vm.provision "shell", name: "Install sysbox", privileged: false,
        env: { "SYSBOX_URL" => SYSBOX_URL, "SYSBOX_SHA" => SYSBOX_SHA},
        inline: <<-SHELL
        set -eux

        uname -r

        exit 0
        # Install sysbox && configure docker+sysbox
        docker ps
        sudo apt-get install -y jq git make
        wget -O /tmp/sysbox.deb "https://downloads.nestybox.com/sysbox/releases/v0.6.1/sysbox-ce_0.6.1-0.linux_amd64.deb"
        echo "${SYSBOX_SHA} /tmp/sysbox.deb" | sha256sum -c -
        sudo apt-get install -y /tmp/sysbox.deb
        # (
        #     cd sysbox
        #     # TODO pin to specific version using git checkout $VERSION_RELEASE (ex release_v0.6.1)
        #     make sysbox # parallel works ? -j
        #     sudo make install
        #     sudo ./scr/docker-cfg \
        #         --sysbox-runtime=enable \
        #         --default-runtime=sysbox-runc \
        #         --userns-remap=disable \
        #         --force-restart \
        #         --verbose
        #         # TODO userns-remap mode ? Make sure it doesn't conflic and change uid:gid owner of workspaces files (else jenkins agent process could fail if it need to modify them)
        #         # TODO rootless
        #     sudo systemctl restart docker
        #     sudo /usr/bin/sysbox # TODO unecessary ? also, systemd enable ?
        # )
        # rm -rf sysbox
        # sudo cat /var/log/sysbox-mgr.log
        echo done
    SHELL

end
