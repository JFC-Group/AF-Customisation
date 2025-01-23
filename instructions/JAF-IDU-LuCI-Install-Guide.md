# Installing LuCI on JAF IDU

_Disclaimer: This is ONLY for educational purposes, No one is responsible for any type of damage. So be aware._

**WARNING: Perform step 0 first because if you accidentally fill up the storage your only option would be to reset the router. You will encounter _500 internal server error_ if you messup the installation in between and you wont be able to reset the router via webui; your only option would be the physical reset using the reset button or [Resetting the router via SSH](JAF-IDU-Reset-Via-SSH.md)**

## Step 0

- Necessary because the internal storage is quite less and doesn't give us much space to work with

- Expanding the root via using a usb overlay (did not find any other better way which did not involve risking the router):
- Follow [this official guide](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration) **CAREFULLY** and you will be good to go
- Reboot the device and run `df -h` and if you see your pendrive mounted at `/` then you are good to move ahead
- Facing error ???? check [Troubleshooting](##Troubleshooting) section 


## Step 1

- Remove these Folders `rm -rf /www`

## Step 2

- Check if uhttpd is running `ps aux | grep uhttpd*`

- Uninstalling Luci and all Luci related stuff

  _During reinstalling these Luci packages a pkg named `libnl-tiny2022-11-01` will cause a conflict. **DO NOT UNINSTALL THAT**; the error basically outlines two modules with similar purpose are having a conflict; the original pkg has lot of dependencies, so overwriting the file is better option._

  ```shell
  opkg remove --force-depends \
  liblucihttp-lua \
  liblucihttp0 \
  luci \
  luci-app-firewall \
  luci-app-opkg \
  luci-base \
  luci-compat \
  luci-lib-base \
  luci-lib-ip \
  luci-lib-jsonc \
  luci-lib-nixio \
  luci-mod-admin-full \
  luci-mod-network \
  luci-mod-status \
  luci-mod-system \
  luci-proto-ipv6 \
  luci-proto-ppp \
  luci-ssl-openssl \
  luci-theme-bootstrap \
  rpcd-mod-luci
  ```

- Now after uninstalling the stuff lot of things like configs remained ; we have to clear that too;
  1. Check these folders if they are not empty use the commands bellow to empty them completely.

      ```shell
      ls /usr/lib/lua/luci/
      ls /usr/share/luci/
      ls /etc/config/luci
      ```

      ```shell
      rm -rf /usr/lib/lua/luci/
      rm -rf /usr/share/luci/
      rm -f /etc/config/luci
      ```

## Step 3

- Reinstalling the Luci packages

  ``` sh
  opkg update
  opkg install --force-overwrite luci
  ```

- You will receive this error (IF NOT JUST MOVE ALONG)

  ``` sh
  Collected errors:
  * resolve_conffiles: Existing conffile /etc/config/luci is different from the conffile in the new package. The new conffile will be placed at /etc/config/luci-opkg.
  ```

- Just replace the older Luci config with newer one:  

  ```shell
  mv /etc/config/luci-opkg /etc/config/luci
  ```

- Now if everything went well your `/www/` will look something like this

  ```shell
  cgi-bin      index.html   luci-static
  ```

- The default command which launches the uhttpd server works just fine for launching the stock LuCI too

- Launch LuCI: <https://192.168.31.1/cgi-bin/luci/>

- The default password for LuCI will be the same you used to login via ssh

## Note

Many things dont work in the LuCI interface yet because J\*\* has used custom LuCI API endpoints for some services and for others are simply not implemented. This may or may not be fixed later (someone has to dedicate their time to fix all the mess j** has created)

- List of things not working in LuCI:
 Firewall section (can only restart firewall)
 everykind of logging is borked (j\*\* implemented it's own bs, further analysis needed)
 `opkg` management
 Backup / Flash section
 Switch (it uses an unknown topology)

## Bonus

1. Use `btop` if you want a nice CLI based resource monitor. You can either compile your own or you can simply use the one @pokewizardSAM compiled in the bin folder.

    Link: <https://drive.google.com/drive/folders/1Om93J8oUOOn1MDMKNvqpbZeXX_Mmn0FK?usp=sharing>

## Troubleshooting: 
* If you are facing Issues such as overlay not activating upon boot then follow the below steps to resolve them. Keep the dmesg output ready and search for `extroot` 
* ##### 1. extroot-not-configured:
	* Check the dmesg output and if that contains this message then you have Problematic configs. to check that do a `cat /etc/config/fstab` ; this should have rwm and extroot with a unique uuid defined with a `option target '/overlay'` in extroot section. If yours doesn't have that, then add it manually. For example see below 
	* ![](assets/Extroot-Fstab-Config.png)
* ##### 2. ubiblock0_1 not found:
	* To mitigate this error you have to Reflash your stock fw images. you can get a copy of fw from here https://small.fileditchstuff.me/s18/TGJFgrgUrrolDsBKDatu.tar.gz 
	* Extract the archive and flash your respective fw and then retry the extroot guide again 