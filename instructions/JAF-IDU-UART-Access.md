# JAF IDU UART Access

_Disclaimer: This is ONLY for educational purposes, No one is responsible for any type of damage. So be aware._

## Steps

1. Strip apart the IDU and find the 4 uart pins. Some models have pins already soldered, others are just unpopulated pads. **NOTE:** The pin layout is NOT standardized across all models. Verify your model in the "Hardware Specifics" section below before connecting.

2. Only connect Rx, Tx, and GND. Do not connect the VCC (3.3V) pin to your usb-to-ttl or serial converter device. Doing so may supply power to the board externally and fry your IDU.

3. Install Putty (or your preferred serial terminal), use the configurations below, and connect the IDU to your serial converter.

4. Power on the IDU and observe the text stream. If you see garbled text, check your connections, verify logic levels (most are 3.3V), or try reversing the Rx and Tx pins.

## Hardware Specifics

### JIDU6801 (and others with standard layout)
Most models follow a generic pattern (usually marked on the PCB):
![Standard UART pin layout](../assets/6801-UART-Pins.png)
*(Assuming standard layouts like GND-TX-RX-VCC)*

### JIDU6411 (IPQ9554) 1.8V
This model has an unpopulated 4-pin header labeled **J1** located between the LAN ports and the USB port. **This layout is unconventional and dangerous if miswired.** VCC is located between TX and RX.

![JIDU6411 J1 Header Location](../assets/6411-UART-Pins.png)

### JIDU6401 (MT7986A) 3.3V
Unpopulated header near the power port.

![JIDU6401 J1 Header Location](../assets/6401-UART-Pins.png)

Pinout (left to right): GND, TX, RX

### JIDU6101 (MT7986A) 3.3V & JIDU6111 (IPQ9554) 1.8V
Unpopulated 4-pin header labeled J1, located near the top of the board close to the RF shield.

![JIDU6101/JIDU111 J1 Header Location](../assets/6101-6111-UART-Pins.png)

Pinout (top to bottom): GND, RX, TX, VCC

### JIDU6601 (MT7986A) 3.3V
Unpopulated 5-pin header. GND is labeled separately on the left; RX and TX are labeled over the two middle pins. The 5th pin is unlabeled/unused.

![JIDU6601 J1 Header Location](../assets/6601-UART-Pins.png)

Pinout (left to right): GND, (unused), RX, TX, (unused)

### JIDU6611 (IPQ9554) 1.8V
Header JE415, silkscreened UART_TXD1 / UART_RXD1 / DGND / DVDD_3V3.

![JIDU6611 J414 Header Location](../assets/6611-UART-Pins.png)

Pinout (left to right): TX, RX, GND, VCC

### JIDU6701 (MT7986A) 3.3V & JIDU6711 (IPQ9554) 1.8V
Small breakout daughtercard with a 4-pin header, silkscreened TX RX 3.3V GND.

![JIDU6701/JIDU6711 J1 Header Location](../assets/6701-6711-UART-Pins.png)

Pinout (top to bottom): TX, RX, VCC, GND

### JIDU6811 (IPQ9554) 1.8V
Small breakout daughtercard with a 4-pin header, silkscreened TX RX 3.3V GND.

![JIDU6811 J1 Header Location](../assets/6811-UART-Pins.png)

Pinout (left to right): TX, RX, VCC (3.3V), GND

### JIDU6911 (IPQ9554) 1.8V
Header J1003, near the USB port.

![JIDU6911 J1003 Header Location](../assets/6911-UART-Pins.png)

Pinout (top to bottom): TX, RX, GND, VCC



**Verified Pinout (Top to Bottom):**
1. **GND**
2. **TX** (Router output)
3. **VCC** (3.3V) - **CAUTION: DO NOT CONNECT**
4. **RX** (Router input)

**Important note on series resistors (JIDU6411):** If you use a series resistor to protect your adapter's RX pin during probing, it *must* be low impedance. Tests confirmed that high-value resistors (e.g., 10kΩ) will act as an RC filter at this baud rate, killing the high-speed signaling and preventing keystrokes from interrupting U-Boot. Use 1kΩ to 4.7kΩ max, or connect directly if your logic levels match.

## Terminal Configs 🐮

**BaudRate:** 115200 
**DataBits:** 8 
**StopBits:** 1 
**Parity:** None 
**FlowControl:** None

## General Troubleshooting

The standard 115200 baud has been verified on JIDU6801,JIDU6401,JIDU6201,JIDU6101,JIDU6601,JIDU6701,JIDU6411,JIDU6111,JIDU6611,JIDU6711,JIDU6811 and JIDU6911. If you encounter garbled text on other models, try other common baud rates (like 57600 or 9600). If issues persist, verify your USB-to-TTL converter is working correctly by doing a loopback test (connecting TX to RX on the converter itself).
