Jio has cleverly locked u-boot access behind a custom username and password that are unique for each model. But fear not, brave soul! Follow these sacred steps, and thou shalt be granted access to the realm of u-boot by the almighty gods themselves

### Step 1: Prepping the IDU :P 

Hop onto ssh on the IDU and run the commands below

* ##### Username: `/etc/mfg/gm_mtc/gm_factory_init.sh get sn`
* ##### Password: `/etc/mfg/gm_mtc/gm_factory_init.sh get uboot_passwd`

Simple yes ??? 

### Step 2: Cooking time :-)

connect your (usb-to-tll/arduino/esp32/whatever jank you got) to the uart ports and keep the enter key pressed so pause boot.

Enter Username and Password and voila you should be greeted into the uboot console


HERE'S A LIST OF WHAT YOU WOULD/SHOULD SEE ONCE IN UBOOT
```bash 
MT7986> ?

?         - alias for 'help'

base      - print or set address offset

bdinfo    - print Board Info structure

bl2       - BL2 utility commands

blkcache  - block cache diagnostics and control

boot      - boot default, i.e., run 'bootcmd'

bootd     - boot default, i.e., run 'bootcmd'

bootflow  - Boot flows

booti     - boot Linux kernel 'Image' format from memory

bootm     - boot application image from memory

bootmenu  - ANSI terminal bootmenu

bootp     - boot image via network using BOOTP/TFTP protocol

cmp       - memory compare

coninfo   - print console devices and information

cp        - memory copy

crc32     - checksum calculation

echo      - echo args to console

editenv   - edit environment variable

env       - environment handling commands

fdt       - flattened device tree utility commands

fip       - FIP utility commands

go        - start application at address 'addr'

gpio      - query and control gpio pins

help      - print command description/usage

httpd     - Start failsafe HTTP server

iminfo    - print header information for application image

imxtract  - extract a part of a multi-image

itest     - return true/false on integer compare

loadb     - load binary file over serial line (kermit mode)

loads     - load S-Record file over serial line

loadx     - load binary file over serial line (xmodem mode)

loady     - load binary file over serial line (ymodem mode)

loop      - infinite loop on address range

lzmadec   - lzma uncompress a memory region

md        - memory display

mm        - memory modify (auto-incrementing address)

mmc       - MMC sub system

mmcinfo   - display MMC info

mtd       - MTD utils

mtkautoboot- Display MediaTek bootmenu

mtkboardboot- Boot MTK firmware

mtkload   - MTK image loading utility

mtkupgrade- MTK firmware/bootloader upgrading utility

mw        - memory write (fill)

nand      - NAND utility

net       - NET sub-system

nfs       - boot image via network using NFS protocol

nm        - memory modify (constant address)

nmbm      - NMBM utility commands

panic     - Panic with optional message

pci       - list and access PCI Configuration Space

ping      - send ICMP ECHO_REQUEST to network host

pinmux    - show pin-controller muxing

printenv  - print environment variables

pstore    - Manage Linux Persistent Storage

pwm       - control pwm channels

random    - fill memory with random pattern

reset     - Perform RESET of the CPU

run       - run commands in an environment variable

saveenv   - save environment variables to persistent storage

setenv    - set environment variables

setexpr   - set environment variable as the result of eval expression

sleep     - delay execution for some time

smc       - Issue a Secure Monitor Call

source    - run script from memory

tftpboot  - load file via network using TFTP protocol

ubi       - ubi commands

ubifsload - load file from an UBIFS filesystem

ubifsls   - list files in a directory

ubifsmount- mount UBIFS volume

ubifsumount- unmount UBIFS volume

version   - print monitor, compiler and linker version
```