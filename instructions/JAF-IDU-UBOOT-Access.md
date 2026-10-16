# JAF IDU U-Boot Access

_Disclaimer: This is ONLY for educational purposes, No one is responsible for any type of damage. So be aware._

_J** has cleverly locked u-boot access behind a custom username and password that are unique for each model. But fear not, brave soul! Follow these sacred steps, and thou shalt be granted access to the realm of u-boot by the almighty gods themselves._

## Step 1: Prepping the IDU :P

Hop onto [SSH on the IDU](./JAF-IDU-Root-Access.md) and run the commands below

- Username: `/etc/mfg/gm_mtc/gm_factory_init.sh get sn`
- Password: `/etc/mfg/gm_mtc/gm_factory_init.sh get uboot_passwd`

Simple, yes ???

## Step 2: Cooking time :-

1. Connect your (usb-to-tll/arduino/esp32/whatever jank you got) to the [UART ports](./JAF-IDU-UART-Access.md) and keep the enter key pressed to pause boot.

2. Enter Username and Password and VOILA! You should be greeted into the uboot console

## U-Boot Commands

**MediaTek MT7986A**

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

**Qualcomm IPQ95XX**

```
IPQ9574# ?
?       - alias for 'help'
aes_256 - AES 256 CBC/ECB encryption/decryption
aq_load_fw- LOAD aq-fw-binary
aq_phy_restart- Restart Aquantia phy
base    - print or set address offset
bdinfo  - print Board Info structure
bootelf - Boot from an ELF image in memory
bootipq - bootipq from flash device
bootm   - boot application image from memory
bootp   - boot image via network using BOOTP/TFTP protocol
bootvx  - Boot vxWorks from an ELF image
bootz   - boot Linux zImage image from memory
canary  - test stack canary
chpart  - change active partition
cmp     - memory compare
coninfo - print console devices and information
cp      - memory copy
crc32   - checksum calculation
dcache  - enable or disable data cache
derive_aes_256_key- Derive AES 256 key before encrypt/decrypt in TME-L based systems
detect_qcn9224- Detect qcn9224 version and populate it on qcn9224_version Env
dhcp    - boot image via network using DHCP/TFTP protocol
dm      - Driver model low level access
dpr_execute- Debug Policy Request processing

echo    - echo args to console
editenv - edit environment variable
env     - environment handling commands
erase   - erase FLASH memory
exectzt - execute TZT

exit    - exit script
false   - do nothing, unsuccessfully
fatinfo - print information about filesystem
fatload - load binary file from a dos filesystem
fatls   - list files in a directory (default /)
fatsize - determine a file's size
fatwrite- write file into a dos filesystem
fdt     - flattened device tree utility commands
flash   - flash part_name
        flash part_name load_addr file_size

flasherase- flerase part_name

flinfo  - print FLASH memory information
flupdate- flupdate set mmc/nand/nor ; flupdate clear

fuse_qcn9224- Fuse QCN9224 V2 fuses and argument is PCIe device ID
fuseipq - fuse QFPROM registers from memory

go      - start application at address 'addr'
help    - print command description/usage
i2c     - I2C sub-system
icache  - enable or disable instruction cache
imxtract- extract a part of a multi-image
ipq_mdio- IPQ mdio utility commands
ipq_mii - IPQ mii utility commands
is_sec_boot_enabled- check secure boot fuse is enabled or not

itest   - return true/false on integer compare
list_pci- Print the RC's PCIe details and attached device ID
list_qcn9224_fuse- Print QCN9224 fuse details from attached PCIe slots
loop    - infinite loop on address range
md      - memory display
mii     - MII utility commands
mm      - memory modify (auto-incrementing address)
mmc     - MMC sub system
mmcinfo - display MMC info
mtdparts- define flash/nand partitions
mtest   - simple RAM read/write test
mw      - memory write (fill)
nand    - NAND sub-system
nboot   - boot from NAND device
nfs     - boot image via network using NFS protocol
nm      - memory modify (constant address)
part    - disk partition related commands
pci     - list and access PCI Configuration Space
ping    - send ICMP ECHO_REQUEST to network host
printenv- print environment variables
protect - enable or disable FLASH write protection
qpic_nand- Switch between SBL and Linux kernel page on 4K NAND Flash.
reset   - Perform RESET of the CPU
run     - run commands in an environment variable
runmulticore- Enable and schedule secondary cores
saveenv - save environment variables to persistent storage
secure_authenticate- authenticate the signed image

setenv  - set environment variables
setexpr - set environment variable as the result of eval expression
sf      - SPI flash sub-system
showvar - print local hushshell variables
sleep   - delay execution for some time
smeminfo- print SMEM FLASH information
source  - run script from memory
test    - minimal test like /bin/sh
tftpboot- boot image via network using TFTP protocol
tftpput - TFTP put command, for uploading files to a server
true    - do nothing, successfully
tzt     - load and run tzt

uart    - UART sub-system
ubi     - ubi commands
usb     - USB sub-system
usbboot - boot from USB device
version - print monitor, compiler and linker version
IPQ9574#
```
