# Flashing Stock OpenWrt on JAF IDUs

_Disclaimer: This is ONLY for educational purposes. Flashing third-party firmware can brick your device if done incorrectly. No one is responsible for any type of damage._

## Getting Root Access (required for the SSH method)

| Firmware Version        | Method                                                                 |
| ------------------------ | ----------------------------------------------------------------------|
| R.2.0.9 – R.2.0.18.2      | [breeze.sh](JAF-IDU-Root-Access.md)                                   |
| R.2.0.19.5 – R.3.2.3      | [Latest FW method](JAF-IDU-Latest-FW-Root-Access.md)                  |
| > R.3.2.3                 | The latest FW method works on some models only. If it doesn't work on yours, downgrade via UART to R.2.0.9, then use [breeze.sh](JAF-IDU-Root-Access.md). |

### Downgrading firmware via UART (MediaTek)

If the latest FW method doesn't work on your model and you're on firmware newer than R.3.2.3, downgrade to R.2.0.9 via UART, then use [breeze.sh](JAF-IDU-Root-Access.md).

> [!CAUTION]
> **DO NOT CONNECT VCC** when attaching your USB to TTL adapter. Doing so will permanently damage your board.

1. **Prepare a [TFTP server](https://github.com/PJO2/tftpd64/releases/).** Set a static IP on your PC's ethernet interface (e.g. `192.168.1.2`), and host the stock R.2.0.9 firmware image (download from the [firmware links table](https://github.com/JFC-Group/AF-Customisation/blob/main/instructions/List-OF-IDU's-and-ODU's.md#firmware-links), e.g. `6101.img`) with the TFTP server.

2. **Attach UART and power on the router.** When the U-Boot Boot Menu appears, select option **2. Upgrade firmware**.

   ```
   *** U-Boot Boot Menu ***

       1. Startup system (Default)
       2. Upgrade firmware
       3. Upgrade ATF BL2
       4. Upgrade ATF FIP
       5. Upgrade U-boot only
       6. Upgrade single image
       7. Load image
       8. Start Web failsafe
       0. U-Boot console
   ```

3. **Log in with the default account** when prompted (only IDU6101 asks for this — the other JIDU6J01 variants, IDU6201/6401/6601/6701, skip straight to step 4):

   ```
   Input Username==>admin
   Input Password==>admin
   ```

   > This is based on current firmware behavior and may change with a future update.

4. **Confirm "Run image after upgrading?"** with `y`.

5. **Select TFTP as the load method** (option `0`, default):

   ```
   Available load methods:
       0 - TFTP client (Default)
       1 - Xmodem
       2 - Ymodem
       3 - Kermit
       4 - S-Record

   Select (enter for default): 0
   ```

6. **Enter the network details and firmware file name:**

   ```
   Input U-Boot's IP address: 192.168.1.1
   Input TFTP server's IP address: 192.168.1.2
   Input IP netmask: 255.255.255.0
   Input file name: <e.g. 6101.img>
   ```

   > Only the `.img` file is needed here, not the `.sig` file.

The router will download the image over TFTP and flash it, then boot into R.2.0.9. From here, follow [breeze.sh](JAF-IDU-Root-Access.md) to get root.

---

## Flashing OpenWrt

Once you have root access (see above), you're ready to flash stock OpenWrt.

### MediaTek IDUs (MTK7986A)

- JIDU6J01 — IDU6201/6401/6601/6701
- JIDU6101 — IDU6101

> [!NOTE]
> These two use separate `.ubi` images — make sure you use the one matching your model.Download it from the [firmware table](https://github.com/JFC-Group/AF-Customisation/blob/main/instructions/List-OF-IDU's-and-ODU's.md#firmware-links).

> [!CAUTION]
> **Do NOT flash OpenWrt on JIDU6801 / JIDU6801 IN.** These models require an ESP32 to inject the `bootcmd`/`bootargs` variables on every boot, as those vars are not saveable on this hardware. This repo does not currently support that, so flashing OpenWrt will leave the device unable to boot without an ESP32-based workaround.

There are two ways to flash stock OpenWrt: via SSH (requires root access from the section above) or via UART.

> [!IMPORTANT]
> Back up your MFG partition before flashing either way — it holds device-specific data (calibration, serials, etc.) that you'll want if you ever need to revert.
>
> ```shell
> dd if=/dev/mtd7 of=/tmp/mfg.bin
> ```
>
> ```shell
> scp -O root@192.168.31.1:/tmp/mfg.bin .
> ```

#### Method 1: SSH

```shell
# PC
scp -O openwrt-mediatek-filogic-jiorouter_ax6000-jidu6j01/jidu6101-initramfs-factory.ubi root@192.168.31.1:/tmp/
```

```shell
# Router
ubidetach -m 6
ubiformat /dev/mtd6 -y -f /tmp/openwrt-mediatek-filogic-jiorouter_ax6000-jidu6j01/jidu6101-initramfs-factory.ubi
```

> [!NOTE]
> If `fw_setenv` below fails with `Warning: Bad CRC, using default environment`, the `u-boot-env` UBI volume has a different volume ID on your model. Run this script first, it finds the volume by name and fixes `/etc/fw_env.config` to point at the right device:
>
> ```shell
> cat > /tmp/fix_uboot_env.sh << 'EOF'
> #!/bin/sh
> # Finds the U-Boot env UBI volume by NAME (volume ID differs between IDU models)
> # and writes the matching device node into /etc/fw_env.config.
> #
> # Fields: device offset env_size sector_size num_sectors
> #   offset      = 0x0     (env starts at the beginning of the volume)
> #   env_size    = 0x80000 (U-Boot env size, CRC is calculated over this)
> #   sector_size = 0x1f000 (UBI LEB size: 128k PEB, 2k page)
> #   num_sectors = 5       (LEBs in the u-boot-env volume)
>
> for v in /sys/class/ubi/ubi0_*; do
>     case "$(cat "$v/name" 2>/dev/null)" in
>         ubootenv|u-boot-env|uboot-env)
>             echo "/dev/$(basename "$v") 0x0 0x80000 0x1f000 5" > /etc/fw_env.config
>             cat /etc/fw_env.config
>             exit 0
>             ;;
>     esac
> done
>
> echo "U-Boot env volume not found" >&2
> exit 1
> EOF
> chmod +x /tmp/fix_uboot_env.sh
> /tmp/fix_uboot_env.sh
> ```

```shell
fw_setenv bootcmd 'ubi detach; ubi part ubi2; ubi read 46000000 kernel; fdt addr $(fdtcontroladdr); fdt rm /signature; bootm 0x46000000'
fw_setenv dual_boot.current_slot 1
fw_setenv dual_boot.slot_0_invalid 1
fw_setenv dual_boot.slot_1_invalid 1
fw_setenv ipaddr
fw_setenv bootdelay 3
reboot
```

Router comes back up as OpenWrt (initramfs). Now flash sysupgrade to make it persistent:

```shell
scp -O openwrt-mediatek-filogic-jiorouter_ax6000-jidu6j01/jidu6101-squashfs-sysupgrade.bin root@192.168.1.1:/tmp/
```

```shell
sysupgrade /tmp/openwrt-mediatek-filogic-jiorouter_ax6000-jidu6j01/jidu6101-squashfs-sysupgrade.bin
```

#### Method 2: UART

##### Getting U-Boot creds via stock root access

```shell
strings /dev/mtd7
```

- **IDU6701** — labeled explicitly, just read them off:
  ```
  uboot_user_name=NXXXXXXX
  uboot_user_password=0422711NyPaYTFcP
  ```

- **IDU6201 / IDU6401** — not labeled, but present at a fixed location. Example from a 6401 unit (`strings /dev/mtd7`):
  ```
  RSVHGCKWXXXXXXX
  ...
  7956200WGQ62aaBk
  JIDU6401
  ```
  - **Username** = the last 8 digits of the RSN (`RSVHGCKWXXXXXXX` → `WXXXXXXX`)
  - **Password** = the string right before the model name — here, `7956200WGQ62aaBk`

- **IDU6601** — not present in the MFG strings at all, has to be computed from the serial number instead:
  - **Username** = last 8 digits of the serial number
  - **Password** = last 8 digits of the serial number, reversed, + `ycgngA==`

- **IDU6101** — no login required, U-Boot skips straight to the file upload prompt.

1. **Prepare a [TFTP server](https://github.com/PJO2/tftpd64/releases/).** Set a static IP on your PC's ethernet interface (e.g. default: ip `192.168.1.2`, gateway `192.168.1.1`). Download the initramfs image and host it with the TFTP server.

2. **Interrupt boot.** Attach UART and power on the router. When the boot menu appears, select Failsafe Mode, then press `Ctrl-C` to interrupt and enter the U-Boot prompt.

3. **Load and run the initramfs image** (use the `-initramfs-kernel.bin` matching your model — `jidu6101` for IDU6101, or `jidu6j01` for the IDU6201/6401/6601/6701 family):

   ```
   setenv ipaddr 192.168.1.1
   setenv serverip 192.168.1.2
   tftpboot 0x46000000 openwrt-mediatek-filogic-jiorouter_ax6000-<jidu6101|jidu6j01>-initramfs-kernel.bin
   fdt addr $(fdtcontroladdr)
   fdt rm /signature
   bootm
   ```

4. **Flash the sysupgrade image.** Place the matching `-squashfs-sysupgrade.bin` in `/tmp`, then run:

   ```
   sysupgrade /tmp/openwrt-mediatek-filogic-jiorouter_ax6000-<jidu6101|jidu6j01>-squashfs-sysupgrade.bin
   ```

   Alternatively, use the sysupgrade option in LuCI.

### Revert to Stock FW via UART (MediaTek only)

If you've flashed OpenWrt and want to go back to stock firmware, attach UART and power on the router. When the U-Boot Boot Menu appears, select option **2. Upgrade firmware**:

```
*** U-Boot Boot Menu ***

    1. Startup system (Default)
    2. Upgrade firmware
    3. Upgrade ATF BL2
    4. Upgrade ATF FIP
    5. Upgrade U-boot only
    6. Upgrade single image
    7. Load image
    8. Start Web failsafe
    0. U-Boot console
```

Then load the stock firmware image via TFTP the same way as in [Downgrading firmware via UART (MediaTek)](#downgrading-firmware-via-uart-mediatek) above.

If the upgrade fails with:

```
Remove UBI volume rootfs (id 1)
Creating dynamic volume rootfs of size 27770880
ubi0 error: ubi_create_volume: not enough PEBs, only 53 available
ubi0 error: ubi_create_volume: cannot create volume 1, error -28
*** Image not supported! ***
MT7986>
```

there isn't enough free space for the rootfs volume because OpenWrt's `rootfs_data` volume is still taking it up. At the `MT7986>` prompt, remove it:

```
ubi remove rootfs_data
```

Then reload the stock firmware image via TFTP the same way as before. It should flash successfully and auto-reboot.

Once it reboots, interrupt into U-Boot again and run:

```
setenv dual_boot.current_slot
setenv dual_boot.slot_0_invalid
setenv dual_boot.slot_1_invalid
setenv bootubi
setenv bootcmd
setenv bootdelay 3
saveenv
```

This clears the dual-boot/OpenWrt env vars set earlier and restores the stock boot environment.

### Fixing missing/wrong MAC address (IDU6101 / IDU6401)

If your MFG or u-boot-env MAC address is missing or wrong — usually from flashing with the wrong method or image — flash the sysupgrade image(download MAC-Fixed Build from the [firmware table](https://github.com/JFC-Group/AF-Customisation/blob/main/instructions/List-OF-IDU's-and-ODU's.md#firmware-links)), then over SSH run:

```shell
/etc/mac-fix.sh
```

Select your model, then enter the MAC address printed on the label on the back of the router's box. It'll then ask to reset — press `y` to confirm — a final reset is required to properly apply the Label MAC.

### Qualcomm IDUs (IPQ9554 — IDU6111, 6411, 6611, 6911, 6711, 6811)

> [!NOTE]
> OpenWrt support for the IPQ9554-based IDUs is still in active development and not yet stable — there are known driver issues and OOM (out-of-memory) problems. A flashing guide will be added here once it's in a usable state.
