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
- [x] https://blog.nestybox.com/2020/09/23/perf-comparison.html
- [ ] https://blog.nestybox.com/2019/11/11/docker-sandbox.html
- [x] https://blog.nestybox.com/2019/11/11/build-inner-img.html
- [x] https://blog.nestybox.com/2019/09/29/jenkins.html

#### TODO
- [ ] check **all** alternatives to sysbox :https://blog.nestybox.com/2020/10/06/related-tech-comparison.html
- [ ] Check how jenkins could fail on uid:gid change from the syscontainer (the workspace directory)
- [ ] check how to setup a rootless docker with sysbox: https://rootlesscontaine.rs/

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
- https://blog.nestybox.com/2020/10/21/gitlab-dind.html


#### Random things

```sh
echo 1 > /proc/sys/kernel/sysrq && echo b > /proc/sysrq-trigger # this reboot the host if the container is privileged... too bad !
```

#### off topics
##### Jenkins concurrent build
- https://stackoverflow.com/questions/61866110/jenkins-concurrent-builds-on-docker-slaves
- https://stackoverflow.com/questions/72612186/jenkins-concurrent-builds-interfering-each-other
- https://stackoverflow.com/questions/50349630/how-do-jenkins-pipeline-builds-determine-the-workspace-folder?rq=2
- https://stackoverflow.com/questions/48553533/jenkins-docker-agent-and-workspaces
- https://github.com/jenkinsci/pipeline-model-definition-plugin/wiki/Controlling-your-build-environment
- https://stackoverflow.com/questions/50829491/scripted-jenkinsfile-docker-agent-how-to-specify-the-reusenode-flag-and-is-it-r
- https://www.jenkins.io/doc/book/pipeline/scaling-pipeline/
