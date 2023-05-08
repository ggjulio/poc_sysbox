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
    config.vm.network "forwarded_port", guest: 8080, host: 8080 # Jenkins
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

        # Upgrade kernel to version >= 5.12 (to avoid manual install of shiftfs)
        uname -r
        echo 'deb http://deb.debian.org/debian buster-backports main' | sudo tee /etc/apt/sources.list.d/buster-backports.list
        sudo apt update
        sudo apt -y -t bullseye-backports upgrade
    SHELL

    config.vm.provision :reload # reboot for kernel version upgrade

    config.vm.provision "shell", name: "Install sysbox", privileged: false,
        env: { "SYSBOX_URL" => SYSBOX_URL, "SYSBOX_SHA" => SYSBOX_SHA},
        inline: <<-SHELL
        set -eux

        uname -r # Must be 5.12 or higher (though probably version >= 6.1)
        sudo apt-get install -y linux-headers-$(uname -r)

        # Install sysbox && configure docker+sysbox
        sudo apt-get install -y jq
        wget -O /tmp/sysbox.deb "${SYSBOX_URL}"
        echo "${SYSBOX_SHA} /tmp/sysbox.deb" | sha256sum -c -
        sudo apt-get install -y /tmp/sysbox.deb

        # check sysbox's systemd units have been properly installed & daemons are running.
        sudo systemctl --no-pager status sysbox -n20


        # Make sure the default runtime is sysbox-runc in order to be able to preload docker images.
        cat /etc/docker/daemon.json \
            | jq '."default-runtime"="sysbox-runc"' \
            | sudo tee /etc/docker/daemon.json
        sudo systemctl restart docker.service

        # TODO: Setup jenkins to test jenkins+sysbox (with an agent node)
        # docker run -p 8080:8080 -p 50000:50000 --restart=on-failure jenkins/jenkins:lts-jdk11 # https://github.com/jenkinsci/docker/blob/master/README.md
        docker run --rm -d --runtime=sysbox-runc -p 8080:8080 -p 50000:50000 --restart=on-failure -P nestybox/jenkins-syscont

        echo done
    SHELL

end
