credits @sumishimii

A way to get temporary ssh access in Jio Outdoor Unit. (ONLY FOR THE MODELS SUPPORTING ADB ACCESS)
## Overview

The sshd binary exists on the Jio ODU at /usr/sbin/sshd. However, the root filesystem is read-only, which prevents modifying the sshd config directly or changing the root password, that's why I used SSH key-based auth to get access to the ODU.

>⚠️This method is not persistent and you'll lose ssh connection if the ODU is restarted.⚠️

## Steps to Enable SSH.
### **1. Generate an SSH key pair on your PC**

##### **For linux**:-
```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
```

##### **For windows**:-
```cmd
ssh-keygen -t rsa -b 2048
```
The id_rsa.pub file can be found at "C:\Users\username\\.ssh\id_rsa.pub",
> You can leave the passphrase empty.

**Once the keys are generated, copy the content of id_rsa.pub to the *authorized_keys* file.**

### **2. Push the get-ssh folder using adb.**
Use the get-ssh folder inside the scripts folder
```bash
adb push get-ssh/ /tmp/
```
to push the entire get-ssh folder to the /tmp directory of the ODU.

### **3. Run the run.sh Script in adb shell.**

```bash
adb shell
```
In adb shell run the following commands

```bash
cd /tmp/get-ssh/
```
```bash
[ ! -f /tmp/get-ssh/ssh_host_rsa_key ] && ssh-keygen -t rsa -f /tmp/get-ssh/ssh_host_rsa_key -N ''
[ ! -f /tmp/get-ssh/ssh_host_ecdsa_key ] && ssh-keygen -t ecdsa -f /tmp/get-ssh/ssh_host_ecdsa_key -N ''
[ ! -f /tmp/get-ssh/ssh_host_ed25519_key ] && ssh-keygen -t ed25519 -f /tmp/get-ssh/ssh_host_ed25519_key -N ''

/usr/sbin/sshd -f /tmp/get-ssh/sshd_config
```

You can now ssh into the ODU either directly from it's ipv4 address if you are in (router_mode/bridge_mode/connected to odu directly) OR instead a better way to access the ODU ssh would be using ssh tunnelling which we use for accessing the ODU webui. just change the dest ports from 443 to 22 and change 8443 to any free port on your (laptop/local device being used to access the ODU).

After establishing a ssh tunnel , proceed with the below command to access the ODU.
```bash
ssh root@localhost -P <whatever_port_you_used_instead_of_8443>
```

