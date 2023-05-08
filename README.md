# poc_sysbox & Jenkins

Vagrantfiles are meant to simulate jenkins agents VM.
```sh
vagrant destroy -f && vagrant up
```
Then ssh inside the "jenkins agent"
```sh
vagrant ssh
```

Once inside, build the system container
```sh
cd /home/vagrant/poc_sysbox/alpine-system-image
docker build -t alpine-syscontainer . # Notice inner images being pulled
docker run --runtime=sysbox-runc -it alpine-syscontainer
```

#### To read
- [ ] https://github.com/nestybox/sysbox/blob/master/docs/user-guide/security.md
- [ ] https://docs.docker.com/engine/security/userns-remap/
#### Troubleshoot
- https://stackoverflow.com/questions/73525175/running-docker-in-sysbox-runtime-connected-to-the-specifc-network
#### Useful Ressources:
- https://github.com/nestybox/sysbox
- https://github.com/nestybox/sysbox-ee
- https://blog.nestybox.com/2019/09/13/system-containers.html
- https://www.docker.com/blog/docker-advances-container-isolation-and-workloads-with-acquisition-of-nestybox/
- https://github.com/nestybox/sysbox/blob/master/docs/developers-guide/README.md
- https://www.nestybox.com/sysbox
- https://blog.nestybox.com/2020/10/06/related-tech-comparison.html