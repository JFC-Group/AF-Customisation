
Note: This list is still under review, the information in this table maybe be inaccurate to some extent. 

# 📦 List of IDUs

| Model   | Manufacturer                  | Firmware Prefix    | Bootloader Access | DebugPorts | RootAccess | Openwrt_version | Known Issues ?                                          |
| ------- | ----------------------------- | ------------------ | ----------------- | ---------- | ---------- | --------------- | ------------------------------------------------------- |
| IDU6201 | ALPHA    (MTK7986A)           | JIO_JIDU6J01_R     | ✅                 | uart       | ✅          | 21.02-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6101 | Arcadyan (MTK7986A)           | ARCNJIO_JIDU6101_R | ✅                 | uart       | ✅          | 21.02-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6801 | GMOB     (MTK7986A)           | GMOBJIO_JIDU6801_R | ✅                 | uart       | ✅          | 21.02-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6601 | SPED     (MTK7986A)           | SPEDJIO_JIDU6601_R | ✅                 | uart       | ✅          | 21.02-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6401 | Sercomm  (MTK7986A)           | SRCMJIO_JIDU6401_R | ✅                 | uart       | ✅          | 21.02-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6701 | Skyworth (MTK7986A)           | SKYWJIO_JIDU6701_R | ✅                 | uart       | ✅          | 21.02-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6811 | Telpa    (MTK7986A)           | JIO_JIDU6J11_R     | ✅                 | uart       | ✅          | 19.07-SNAPSHOT  | Some users faced setting not persisting across reboots. |
| IDU6111 | Arcadyan (IPQ9554/AP-AL02-C1) | JIO_JIDU6J11_R     | ✅                 | uart       | ✅          | 19.07-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6411 | Sercomm  (IPQ9554)            | JIO_JIDU6J11_R     | ✅                 | uart       | ✅          | 19.07-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6611 | SPED     (IPQ9554)            | JIO_JIDU6J11_R     | ✅                 | uart       | ✅          | 19.07-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6911 | Askey    (IPQ9554)            | JIO_JIDU6J11_R     | ✅                 | uart       | ✅          | 19.07-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           |
| IDU6711 | Skyworth (IPQ9554)            | JIO_JIDU6J11_R     | ✅                 | uart       | ✅          | 19.07-SNAPSHOT  | 160mhz wont work on fw v2.0.9                           | 

# 📡 List of ODUs
| Model     | Manufacturer / Assembler      | Module Used       | Firmware_release         | DebugPorts                                         | RootAccess                  | Extra Info                                                                                                                   |
| --------- | ----------------------------- | ----------------- | ------------------------ | -------------------------------------------------- | --------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| JODU51641 | Sercomm                       | COMPAL/NXP(SDX65) | JODU51641_REL_23_00_0_S  | uart❌ usb✅(adb+fastboot)                         | yes✅, via usb -> adb       | adb and fastboot are exposed only after holding the hw reset btn for ~3 sec. Fastboot is persistent for an entire boot duration if triggered correctly. Device is bootloader unlocked                                                                                                                             |
| JODU51642 | Sercomm                       | COMPAL/NXP(SDX65) | JODU51642_REL_23_00_0_S  | uart❌ usb✅(adb+fastboot)                         | yes✅, via usb -> adb       | adb and fastboot are exposed only after holding the hw reset btn for ~3 sec. Fastboot is persistent for an entire boot duration if triggered correctly. Device is bootloader unlocked |
| JODU51643 | Sercomm                       | COMPAL/NXP(SDX65) | JODU51643_REL_37_00_00_S | uart❌ usb❌(doesn’t expose any port)              | No❌, usb❌                 |                                                                                                                              |
| JODU51740 | GeneralMobile                 | RG520F-JO(SDX65)  | JODU51740_REL_1315_01_12_S| uart❌ usb✅(exposes only fastboot)               | No❌, fastboot only device  | Device is bootloader unlocked, flashing is possible.                                                                         |
| JODU51741 | GeneralMobile                 | RG520F-JO(SDX65)  | JODU51741_REL_1315_01_33_S| uart❌ usb✅(exposes only fastboot)               | No❌, fastboot only device  | Device is bootloader unlocked, flashing is possible.                                                                         |
| JODU52040 | Askey                         | RG500Q-EA (SDX55) | JODU52040_REL_07_27_00_S | uart✅(Password Locked) usb✅(Full adb shell access) | yes✅, via usb -> adb -> ssh | FW is full readonly, kernel lacks overlayfs support, ssh access isn't persistent.                                            |
| JODU52041 | Askey                         | RG500Q-EA(SDX65)  | JODU52041_REL_02_32_00_S | uart✅(Password Locked) usb✅(Full adb shell access) | yes✅, via usb -> adb -> ssh | Same as above. LOCKED on latest fw                                                                                           |
| JODU52121 | LUXSHARE                      | RG200U-JO(SDX65)  | JODU52121_REL_01_15_00_S | uart❌ usb❌                                         | No❌, usb❌                  |                                                                                                                              |
| JODU52140 | SPPEDTECH / NEOLYNC / LUXSLAM | RG520F-JO(SDX65)  | JODU52140_REL_01_25_00_S | uart✅ usb✅(exposes only fastboot)                  | No❌, uart console locked    | LOCKED on latest FW                                                                                                          |
| JODU52240 | Arcadyan                      | RG520F-JO(SDX65)  | JODU52240_REL_01_23_00_S | uart❌ usb✅(exposes only fastboot)                  | No❌, fastboot only device   | Latest FW updates have disabled the web UI abilities.                                                                        |
| JODU52540 | HFCL                          | HFCL_CPE_CORE_MB(SDX65) | JODU52540_REL_25_01_05_S | uart✅ usb❌                                   | yes✅, uart console locked   | LOCKED on latest FW                                                                                                                              |
| JODU52420 | Skyworth                      | UN65A (SDX65)     | JODU52420_REL_01_27_00_S | uart❌ usb❌                                         | No❌, usb❌                  | LOCKED on latest FW                                                                                                                              |
#### TBD: To be determined yet  


## Firmware links

| Firmware ID        | V2.0.9                                                                                | V2.0.16                                                            | V2.0.6                                                                                |
| ------------------ | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------ | --------------------------------------------------------------------------------------|
| ARCNJIO_JIDU6101_R | [Download](https://mega.nz/file/q9oURIQb#--QU1QC0MsjTGuY_jh0NIB0XVuEL5Qh7fsrgT34bGCM) |                                                                    | [Download](https://mega.nz/file/yfBzlQCC#gzLMWquytQFmYnaKWNs7-Q9G50WLY5-Skfg0mv9EpL4) |
| GMOBJIO_JIDU6801_R | [Download](https://mega.nz/file/fhJi3BiZ#Dp_WtubqyFGhrk33rYGgdKgQUw7ax0FmUHaisNYmyd8) | [Download](https://mega.nz/folder/31YTlSbI#Ar-aQK605GZqI_1zc_PZtw) | [Download](https://mega.nz/file/ObBziSaZ#JxQj-EwsxmEEQWWxdaB0B4SdvthQoZ-IYPIg_h45oMM) |
| SPEDJIO_JIDU6601_R | [Download](https://mega.nz/file/T5g03aLZ#AGr7fBJDbpa0dLXrL-bAdALjEBgAT1wVzL7ncA0RJq8) |                                                                    |                                                                                       |
| SRCMJIO_JIDU6401_R | [Download](https://mega.nz/file/Pkh0SbpB#kBpW7ls7Y2GJ7Y47DmgzzHNd-OCBSEBUoMblwyovp_E) |                                                                    | [Download](https://mega.nz/file/aaAUFLJS#SqmlLqISvgiuBkJeuCAZ8-yLRrdtKpumEf-1tMFP7SI) |
| SKYWJIO_JIDU6701_R | [Download](https://mega.nz/file/LgYkUTBJ#btKP77FlbvokfYR0mmBQCQEtCoLaAkIqjt7SpdKoiBI) |                                                                    |                                                                                       |
| JIO_JIDU6J11_R     | [Download](https://mega.nz/file/7GpSzCZY#2aV-yApylUX_Tl_DSzRvyuZqeP-J4VFtpTscjl0I_Rk) |                                                                    | [Download](https://mega.nz/file/TCwmxKSL#AHBbhk83IOv2eXPIYOQhIHdpmBfy4aH9MC1CUM65-eA) |

| Firmware ID              | Links                                                                                 | Notes                    |
| ------------------------ | ------------------------------------------------------------------------------------- | ------------------------ |
| JODU52041_REL_02_32_00_S | [Download](https://mega.nz/file/nsAwwDjT#Tme3W2k8VCRAB7b99L1wI0NVxwrBHB0_bJ51Ck2i0JQ) | ❌Locked FW, DO NOT FLASH |
| JODU52041_REL_02_25_00_S | [Download](https://mega.nz/file/iHoUEaAC#r-DonvgeDIyKkNhWS7P8pXftYW_3Tfc4LNO67D5lLvQ) | ✅Unlock FW               |	
| JODU52040_REL_07_27_00_S | [Download](https://mega.nz/file/7KhSBKoS#Qn9sCN7evlemmzv7_W9Vm7TmGNIbgNkkq3P2-QmKOc8) | ✅Unlock FW               |
| JODU52140_REL_01_15_00_S | [Download](https://mega.nz/file/iapBFCzZ#hyY0Xa_n_aJYMhd5FLglFYNMsN0D_3HIrc6YT8IVpn8) | ✅Unlock FW               | 
| JODU52240_REL_01_23_00_S | [Download](https://mega.nz/file/TSwQ2ZLI#Q2l5cpEubkwBPprzhHswMOo5oPNQ3VZlle2--Qgw26M) | ✅Unlock FW               |
| JODU52540_REL_25_01_14_S | [Download](https://mega.nz/file/GLpBxBqT#5E_Y4VXlJYTGe7sfcXJWS4zAmRJxEI5aWKND2kSjJwY) | ✅Unlock FW               |
| JODU51641_REL_31_00_00_S | [Download](https://mega.nz/file/mOQllaBC#RGu3Q7npYBjG-7u6dVshC2MSkaLw2IPrz6MkKAwDVJw) | ✅Unlock FW               |
| JODU51642_REL_31_00_00_S | [Download](https://mega.nz/file/TKpVFZha#aRtBJAMN562uE_MyZKtEiZwUPoJ3JfwigZPxcU747OI) | ✅Unlock FW               |
| JODU51643_REL_31_00_00_S | [Download](https://mega.nz/file/PLRzAZYI#XS3CQBLaPiT0yl3AfmX6TBpjsmrMBP4_Ef1FiCAg3Xw) | ✅Unlock FW               |
| JODU51740_REL_1315_01_28_S | [Download](https://mega.nz/file/XL41kBKa#_kubVpUhX8uhKU2xgAlpwLKWkOpq8XvRvccbwPmhk90)|✅Unlock FW               |
| JODU51741_REL_1315_01_28_S | [Download](https://mega.nz/file/qaIFXKiY#AUJcvWMmi_nWsyodS5fPgoNlbyFaI1RXynLyUKJMRLM)|✅Unlock FW               |
