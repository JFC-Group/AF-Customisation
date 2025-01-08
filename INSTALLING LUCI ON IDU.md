### PERFORM Step:0 FIRST BECAUSE IF YOU ACCIDENTALLY FILL UP THE STORAGE YOUR ONLY OPTION WOULD BE TO RESET THE ROUTER. YOU WILL ENCOUNTER <U>500 INTERNAL SERVER ERROR</U> IF YOU MESSUP THE INSTALLATION IN BETWEEN AND YOU WONT BE ABLE TO RESET THE ROUTER VIA WEBUI; YOUR ONLY OPTION WOULD BE THE PHYSICAL RESET USING THE RESET BUTTON OR [RESETTING THE ROUTER VIA SSH](RESETTING%20THE%20ROUTER%20VIA%20SSH.md) 
## Step:0 
* Necessary because the internal storage is quite less and doesn't give us much space to work with 
* Expanding the root via using a usb overlay (did not find any other better way which did not involve risking the router):
	 * Follow this official guide CAREFULLY and you will be good to go 
	   https://openwrt.org/docs/guide-user/additional-software/extroot_configuration
	   
## Step:1 
* Remove these Folders ` rm -rf /www`

## Step:2 
* #### Check if uhttpd is running `ps aux | grep uhttpd*`
* #### Uninstalling Luci and all Luci related stuff:
``` bash
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

* During reinstalling these Luci packages a pkg named "libnl-tiny2022-11-01" will cause a conflict. DO NOT UNINSTALL THAT ; the error basically outlines two modules with similar purpose are having a conflict; the original pkg has lot of dependencies, so overwriting the file is better option.

* Now after uninstalling the stuff lot of things like configs remained ; we have to clear that too;
  1. check these folders if they are not empty use the commands bellow to empty them completely.
``` sh
ls /usr/lib/lua/luci/
ls /usr/share/luci/
ls /etc/config/luci
```

``` sh
rm -rf /usr/lib/lua/luci/
rm -rf /usr/share/luci/
rm -f /etc/config/luci
```


## Step:3 
* #### Reinstalling the Luci packages:
``` sh
opkg update
opkg install --force-overwrite luci
```

* You will receive this error (IF NOT JUST MOVE ALONG)
``` sh
Collected errors:
 * resolve_conffiles: Existing conffile /etc/config/luci is different from the conffile in the new package. The new conffile will be placed at /etc/config/luci-opkg.
```
 
 * Just replace the older Luci config with newer one:  ` mv /etc/config/luci-opkg /etc/config/luci`
*  Now if everything went well your /www will look something like this 
```
root@BlueNecko:/www# ls
cgi-bin      index.html   luci-static
```
* The default command which launches the uhttpd server works just fine for launching the stock Luci too 
* GO Launch Luci: https://192.168.31.1/cgi-bin/luci/ 
* The default password for luci will be the same you used to login via ssh 

## Note:
Many things dont work in the Luci interface yet because jio has used custom luci api endpoints for some services and for others are simply not implemented. This may/maynot be fixed later (someone has to dedicate their time to fixx all the mess jio has created)

* List of things not working in Luci:
	Firewall section (can only restart firewall)
	everykind of logging is borked (jio implemented it's own bs, further analysis needed)
	Opkg management
	Backup/Flash section
	Switch (it uses an unknown topology)

### BONUS: 
1. Use Btop if you want a nice cli based resource monitor either compile your own or can simply use the one i compiled for mine in the bin folder 
	* link: https://drive.google.com/drive/folders/1Om93J8oUOOn1MDMKNvqpbZeXX_Mmn0FK?usp=sharing

