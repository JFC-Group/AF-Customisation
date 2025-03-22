# Accessing the ODU WEB-UI from local network

_Disclaimer: This is ONLY for educational purposes, No one is responsible for any type of damage. So be aware._

1. Fetch the local link ip of the ODU using this command:

    ```shell
    ovsdb-client transact '[ 
        "Open_vSwitch", 
        {
            "op": "select",
            "table": "IPv6_Neighbors",
            "where": [["if_name", "==", "eth1"]],
            "columns": ["address"]
        }
    ]'
    ```

    ![ODU ipv6 address fetch](../assets/ODU_ipv6_address_fetch.png)

    _NOTE: If you don't get an ipv6 address in return then try restarting your router once. That should fix the issue most of the times if you haven't messed around the settings to much. If the issue still persists then reset the router and try again. If you still didn't get an ipv6 address stil in return then refer to last part._

2. Start a SSH tunnel from any local device:

    ```shell
    ssh -L 8443:[<local-link-ipv6-address>]:443 root@192.168.31.1
    ```

    * Substitute the local link ip with what you get as output from previous command. For example:

        ```shell
        ssh -L 8443:[fe80::9632:51ff:fe04:c136%eth1]:443 root@192.168.31.1
        ```

3. Access ODU via `https://localhost:8443`:

    ![ODU Login page image](../assets/ODU_Login_page_image.png)


### **UPDATE: Interface Update in Recent Jio ODU Firmware(Only for recent updates)**  

In the latest firmware updates (from **version JIDU6J11_R2.0.9**), the **`eth1` interface has been changed to `eth0`**. This means that when setting up SSH port forwarding, we have to now use:  

```sh
ssh -L 8443:[<IPv6 addr>%eth0]:443 root@192.168.31.1
```  

Additionally, when querying the **IPv6_Neighbors** table using `ovsdb-client`, we have to reference `eth0` instead of `eth1`:  

```sh
ovsdb-client transact '[ 
    "Open_vSwitch", 
    { 
        "op": "select", 
        "table": "IPv6_Neighbors", 
        "where": [["if_name", "==", "eth0"]], 
        "columns": ["address"] 
    } 
]'
```  

If you **still cannot find the address**, try looking for an interface similar to **`eth0.xxxx`**