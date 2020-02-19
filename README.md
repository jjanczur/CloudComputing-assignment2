# CloudComputing-assignment2

This is the repo imported from TU Berlin GitLab with the code for the assignment 2 in Cloud Computing course. 

We got **maximum number of points**, so enjoy our work.    
If you find it useful, you can give us a star.

## Tasks:

* Work on 1 host machine
   * Preferably your laptop (physical machine). If you don’t have Linux, use a VM.
* Prepare virtualization environments:
   * Qemu/KVM
   * Docker
* Write 2 new benchmarks:
   * Forksum
   * Nginx
* Execute benchmarks on different virtualization platforms

# CPU benchmark questions:

## 1. Look at your LINPACK measurements. How do they differ between the platforms, what are the main reasons for the differences?

* Native - Avg. 3387000,94 KFLOPS
* KVM    - Avg. 3383373,01 KFLOPS
* Qemu   - Avg.   49485,31 KFLOPS
* Docker - Avg. 3435431,58 KFLOPS

Benchmarks on native machine, KVM and Docker virtual machines yield similar results. CPU on QEMU without KVM is much slower. This happens, because emulation of the CPU done by QEMU is software based, thus it applies noticeable overhead.

# Memory benchmark questions:

## 1. Look at your memsweep measurements. How do they differ between the platforms, what are the main reasons for the differences?

* Native - Avg.  0,34 s
* KVM    - Avg.  0,52 s
* Qemu   - Avg. 20,47 s
* Docker - Avg.  0,34 s

In case of Docker, direct access to the MMU is performed => no overhead.

In case of KVM, a dedicated hardware unit is used to translate Guest Physical Address into Host Physical Address => small overhead.

In case of Qemu, shadow page tables are used. Every page fault leads to a so-called VM exit, i.e. switching the contexts from the guest to the host => quite expensive.


# Disk benchmark questions:

## 1. Look at your disk write measurements. How do they differ between the platforms, what are the main reasons for the differences?

* Native - Avg.  787,73 IOPS
* KVM    - Avg. 1038,48 IOPS
* Qemu   - Avg.  560,60 IOPS
* Docker - Avg.  381,17 IOPS

These results took us by surprise. We suspect that docker performance problems may be related to their overlayfs file system and the fact that docker image was created for each benchmark run - if a new overlay is created on the first write, that would incur significant performance overhead.


## 2. Which disk format did you use for qemu? How do you expect this benchmark to behave differently on other disk formats?

The disk format used was qcow2. The performance should have been higher if raw disk format was used. For other disk formats, we suspect that the performance would be slightly lower, since qcow2 is qemu's native disk format with the most features and support.


# Fork benchmark questions:

## 1. Look at your fork sum measurements. How do they differ between the platforms, what are the main reasons for the differences?

* Native - Avg.  0,81 s
* KVM    - Avg.  1,02 s
* Qemu   - Avg. 17,93 s
* Docker - Avg.  1,03 s

In case of Qemu, privileged instructions, needed for a fork, have to be trapped and emulated.

# Nginx benchmark questions:

## 1. Look at your nginx measurements. How do they differ between the platforms, what are the main reasons for the differences?

* Native - Avg.  0,14 s
* KVM    - Avg. 40,19 s
* Qemu   - Avg. 64,06 s
* Docker - Avg.  0,17 s

As expected native and docker are the fastest. The performance degradation in qemu is easily explained by the choice of networking backend used - User Networking (SLIRP) https://wiki.qemu.org/Documentation/Networking#User_Networking_.28SLIRP.29   
This networking backend doesn't require any root privileges and is easiest to use, but adds a lot of overhead.

## 2. How are these measurements related to the disk benchmark findings?

In our case the measurements do not seem to be related in any significant way.





## listing-setup.txt
## File containing all commands and inputs you used for installing the tools and preparing your VM image, including comments explaining what the commands do

### installing qemu with kvm support

`sudo apt install qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils`

### check if kvm kernel module is enabled

`sudo modinfo kvm`

### download debian wheezy image

`curl --output=debian.qcow2 https://people.debian.org/~aurel32/qemu/amd64/debian_wheezy_amd64_standard.qcow2`

### run debian in qemu
### kvm disabled

`sudo qemu-system-x86_64 -hda debian.qcow2 -m 1024 -nographic -net user,hostfwd=tcp::2222-:22 -net nic`

### kvm enabled

`sudo qemu-system-x86_64 -enable-kvm -hda debian.qcow2 -m 1024 -nographic -net user,hostfwd=tcp::2222-:22 -net nic`

### port 2222 on the host is forwarded to 22 (ssh) on the guest

### to ssh to the virtual machine

`ssh -p 2222 root@localhost # password is `root``

## guest machine

### check internet access in the virtualized os (qemu doesn't support icmp by default, so ping won't work)  
`dig google.com`

### setting up the guest system

```shell
apt-get update && apt-get upgrade
apt-get install -y fio gcc rsync
```

### Instal nginx

```shell
sudo apt-get upgrade
sudo apt-get update
sudo apt-get instal nginx
```

### Create a big file in a localhost localization
### This location is different on different systems

```shell
cd /usr/share/nginx/html/
sudo fallocate -l 512M big-file.txt
```

### Start nginx
`sudo service nginx start`

 For nginx download benchmarking we are using wrk.   
 wrk is a benchmarking tool.

### Instal wrk

```shell
sudo apt-get install build-essential libssl-dev git -y
git clone https://github.com/wg/wrk.git wrk
cd wrk
make
```

### move the executable to somewhere in your PATH, ex:
`sudo cp wrk /usr/local/bin`

 ## /guest-machine

### to synchronize a folder on host and remote machine
`rsync -avze "ssh -p 2222" $HOST_PATH root@localhost:$GUEST_PATH # rsync must be installed on both systems`

### To build image from Dockerfile e.g. for cpu benchmark
`docker build -f "cpu.Dockerfile" -t "cpu-benchmark"`

### To run just created image in docker container
`docker run "cpu-benchmark"`

### To run detached image, with ports mapping between host and container
`docker run -d -p 80:80 "nginx-benchmark"`
