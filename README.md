# P4 Language Tutorials on Barge with Vagrant

This repo creates a [P4 Language Tutorials](https://github.com/p4lang/tutorials) Environment in a [Docker](https://www.docker.com/) container on [Barge](https://github.com/bargees/barge-os) with [Vagrant](https://www.vagrantup.com/) instantly.

## Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
- [Docker Community Edition Client](https://www.docker.com/community-edition#download) (optional)

## Start Up an Environment for the P4 Tutorials

```
$ vagrant up
$ vagrant ssh
[bargee@barge ~]$ docker run -it --rm --privileged -v /lib/modules:/lib/modules:ro -v /vagrant/tutorials:/home/p4/tutorials --name p4-tutorials --hostname p4-barge ailispaw/p4-tutorials:v2
p4@p4-barge:~$ 
```

## Run a Tutorial

```
p4@p4-barge:~$ cd tutorials/exercises/basic
p4@p4-barge:~/tutorials/exercises/basic$ make build
mkdir -p build pcaps logs
p4c-bm2-ss --p4v 16 --p4runtime-file build/basic.p4info --p4runtime-format text -o build/basic.json basic.p4
p4@p4-barge:~/tutorials/exercises/basic$ make run
mkdir -p build pcaps logs
sudo python ../../utils/run_exercise.py -t topology.json -b simple_switch_grpc
Reading topology file.
Building mininet topology.
Switch port mapping:
s1:  1:h1 2:s2  3:s3
s2:  1:h2 2:s1  3:s3
s3:  1:h3 2:s1  3:s2
.
.
.

mininet> 
```

### To Login a Mininet Node

Because it doesn't have a GUI window, we can not use mininet's (g|x)term command.  
You can use the `./contrib/term.sh` script in another terminal instead.

- Open another terminal.
- Then,

```
$ vagrant ssh
[bargee@barge ~]$ /vagrant/contrib/term.sh h1
root@p4-barge:~# PS1='\u@<h1>:\w\$ '
root@<h1>:~# 
```

- Or if you have Docker client in your local machine, you can log into the node directly.

```
$ ./contrib/term.sh h1
root@p4-barge:~# PS1='\u@<h1>:\w\$ '
root@<h1>:~# ifconfig
h1-eth0   Link encap:Ethernet  HWaddr 00:00:00:00:01:01
          inet addr:10.0.1.1  Bcast:10.0.1.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:18 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1416 (1.4 KB)  TX bytes:90 (90.0 B)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
