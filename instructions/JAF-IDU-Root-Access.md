# A walk-through onto getting root access in the JAF Series of Routers

_Disclaimer: This is ONLY for educational purposes, No one is responsible for any type of damage. So be aware._

**You can use [this script](../scripts/breeze.sh) to automatically get root access. Remember to have openssl, tar, and gunzip installed. The script only works in UNIX-like systems (Linux, macOS, BSD, etc.)**

## Intro

AF's firmware has drastically changed since JF, with a new firmware based on OpenWRT, it gets quite easier to handle than their proprietary buildroot based build on the JFs.

There are 5 "IDUs" (Indoor Units):
IDU6101 - Arcaydan
IDU6801 - GMOB
IDU6601 - SPED
IDU6401 - Sercomm
IDU6701 - Skyworth
IDU6811 - Telpa (IPQ9554)

Out of these, some are Mediatek-based, specifically the MTK7986 SoC. I have confirmed that IDU6801 and IDU6401 have the MTK Chipsets. The rest have not been confirmed.
Looking around at their new WebUI, they have switched to calling it JWRT, with most of the data coming from an API Endpoint WCGI. From the JWRT tags, we assumed that the firmware would be based on OpenWRT, especially when the MTK7986 does seem to have support by BananaPi's R3 Router.

## Gathering the Files

With the firmware in hand, and some `binwalk`ing around, we now have the rootfs. It was clear by now, both from the file structure and a lot of references, that the firmware was indeed based on OpenWRT, specifically some OpenWRT 21.02 Snapshot from March 2021 (as the packages suggest). The firmware has been frozen, meaning that it is incredibly insecure and forever stuck with the flaws in the packages installed. This is not that big of an issue if it was their own home-made firmware, but the fact that they are using `luci` and `uci` APIs for almost anything is really concerning.

## Breaking the encryption

History repeats itself, and it did yet again with the `server.key` being reutilized yet again as the encryption key for their Config Backups (well, actually they didn't; rather they used the string `"/etc/server.key"` to encrypt the config backup), not the case for their Debug Logs (dbglog) though. This time, they switched to AES-256 instead of AES-128 like the last time. A certain binary, `jcrypt`, acts as the sole encryption/decryption service. A lot of references throughout the system, with it even being used to restore the configuration. Doing a quick `strings` on jcrypt, it can be found that they are indeed using almost the same openssl encryption command, and to find the exact key, we just had to `strace` it a bit, which is quite easy with QEMU's AARCH64 Static Chroot.

Thus, the command stands:

```shell
openssl enc -pbkdf2 -in encryptedfile -out decryptedfile -d -aes256 -k "/etc/server.key"
```

_P.S.: Yeah this is funny how J used the string `"/etc/server.key"` to encrypt the backup rather than using the file itself. Even kids know that they should have used `-kfile` instead of `-k`_

As we unarchive the backup, we find that it is a snapshot of `/etc`, this makes things a lot more easier for us to achieve, because it contains both `passwd` and `shadow` files. It also contains `mwan3.user`, which is a shell script that activates when the Dual WAN Mode of the AF is activated. You can activate the Dual WAN from here: <https://192.168.31.1/#/WAN/DualWan>

## Figuring out the rest

Almost there. With `dropbear` already being installed in the firmware, it was just a matter of changing the password of root and getting dropbear to run. I decided to take the harder route and just change the root password hash in `/etc/shadow` (You can generate yours using this command: `openssl passwd -1 -salt ENTER_YOUR_SALT "ENTER_YOUR_PASSWORD"`) as the root FS is persistent, and rewriteable. But, you can also change the password as you start dropbear. It's simple from here.

Open `mwan3.user` in any text editor (code editors preferred), go to the last line, and add:

```shell
dropbear -p 0.0.0.0:22
```

and if you want to change the password, in the next line:

```shell
echo -e \"password\npassword\" | passwd root
```

Now to wrap up the backup and finally get root access, all you have to do is generate a `.tar.gz` of the file, and then re-encrypt it with the server.key with this command:

```shell
openssl enc -pbkdf2 -in decryptedfile -out encryptedfile -e -aes256 -k "/etc/server.key"
```

_P.S.: Yeah! Please don't re-encrypt the file with the actual `server.key`. Rather use the string `/etc/server.key`_

## Stairway to Heaven

Drop the encrypted tar.gz (remember to have .tar.gz as the extension of the file) into the backup restore, let the device reboot.
Now, go to <https://192.168.31.1/#/WAN/DualWan> and enable it, the device will reboot again, and now ssh should be up and running!

To persist everything and to be able to disable Dual WAN, you just need to add the dropbear command to the end of `/etc/rc.local`, and et voila!
You might need to do this every update, but at least not at restart from now on!

## Suggestions

Block `fota.slv.kai.jphone.net` at /etc/hosts:

```shell
0.0.0.0 fota.slv.kai.jphone.net
```

Disable TR-069 at /etc/config/tr069:
Replace `config acs` with:

```conf
config acs
    option periodic_enable '0'
    option enablecwmp '0'
    option interface 'eth0'
    option isConnected '1'
```

### Disable Wifi

```shell
ovsdb-client transact '[ "Open_vSwitch", { "op": "update", "table": "Wifi_Radio_Config", "where": [], "row": { "enabled": false } } ]'
```

### Enable Wifi

```shell
ovsdb-client transact '[ "Open_vSwitch", { "op": "update", "table": "Wifi_Radio_Config", "where": [], "row": { "enabled": true } } ]'
```

### Disable wifi auto restart

```shell
vim /usr/opensync/scripts/healthcheck.funcs.sh
```

Edit the file and set the value of Healthcheck_Enabled() to false instead of true.
