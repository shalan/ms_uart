# EF_UART

A universal Asynchronous Receiver/Transmitter (UART) Soft IP with the following features:
- A configurable frame format
    - Data bits could vary from 5 to 9 bits
    - Even, odd, stick, or no-parity bit generation/detection
    - One or Two stop bit generation
- Line-break detection
- Configurable receiver timeout
- Loopback capability for testing/debugging
- Glitch Filter on RX enable
- Matching received data detection 
- 16-byte TX and RX FIFOs with programmable thresholds
- 16-bit prescaler (PR) for programable baud rate generation
- Ten Interrupt Sources:
    + RX FIFO is full
    + TX FIFO is empty
    + RX FIFO level is above the set threshold
    + TX FIFO level is below the set threshold
    + Line break detection
    + Receiver data match
    + Frame Error
    + Parity Error
    + Overrun
    + Receiver timeout 


## Registers

|register name|offset|size|mode|description|
|---|---|---|---|---|
|rxdata|0000|9|r|RX Data register|
|txdata|0004|9|w|TX Data register|
|prescaler|000c|16|w|Prescaler|
|control|0008|5|w|UART Control Register|
|config|0010|14|w|UART Configuration Register|
|fifo_control|0014|16|w|FIFO Control Register|
|fifo_status|0018|16|r|FIFO Status Register|
|match|001c|9|w|Match Register|
|IM|0f00|10|w|Interrupt Mask Register; check the flags table for more details|
|RIS|0f08|10|w|Raw Interrupt Status; check the flags table for more details|
|MIS|0f04|10|w|Masked Interrupt Status; check the flags table for more details|
|IC|0f0c|10|w|Interrupt Clear Register; check the flags table for more details|

### RX Data register [Offset: 0x0, mode: r]

RX Data register

<img src="https://svg.wavedrom.com/{reg:[{name:'rxdata', bits:9},{bits: 23}], config: {lanes: 2, hflip: true}} "/>

### TX Data register [Offset: 0x4, mode: w]

TX Data register

<img src="https://svg.wavedrom.com/{reg:[{name:'txdata', bits:9},{bits: 23}], config: {lanes: 2, hflip: true}} "/>

### Prescaler [Offset: 0xc, mode: w]

Prescaler

<img src="https://svg.wavedrom.com/{reg:[{name:'prescaler', bits:16},{bits: 16}], config: {lanes: 2, hflip: true}} "/>

### UART Control Register [Offset: 0x8, mode: w]

UART Control Register

|bit|field name|width|description|
|---|---|---|---|
|0|en|1|UART enable|
|1|txen|1|UART Transmitter enable|
|2|rxen|1|UART Receiver enable|
|3|lpen|1|Loopback (connect RX and TX pins together) enable|
|4|gfen|1|UART Glitch Filer on RX enable|

<img src="https://svg.wavedrom.com/{reg:[{name:'en', bits:1},{name:'txen', bits:1},{name:'rxen', bits:1},{name:'lpen', bits:1},{name:'gfen', bits:1},{bits: 27}], config: {lanes: 2, hflip: true}} "/>

### UART Configuration Register [Offset: 0x10, mode: w]

UART Configuration Register

|bit|field name|width|description|
|---|---|---|---|
|0|wlen|4|Data word length: 5-9 bits|
|4|stp2|1|Two Stop Bits Select|
|5|parity|3|Parity Type: 000: None, 001: odd, 010: even, 100: Sticky 0, 101: Sticky 1|
|8|timeout|6|Receiver Timeout measured in number of bits|

<img src="https://svg.wavedrom.com/{reg:[{name:'wlen', bits:4},{name:'stp2', bits:1},{name:'parity', bits:3},{name:'timeout', bits:6},{bits: 18}], config: {lanes: 2, hflip: true}} "/>

### FIFO Control Register [Offset: 0x14, mode: w]

FIFO Control Register

|bit|field name|width|description|
|---|---|---|---|
|0|txfifotr|4|Transmit FIFO Level Threshold|
|8|rxfifotr|4|Receive FIFO Level Threshold|

<img src="https://svg.wavedrom.com/{reg:[{name:'txfifotr', bits:4},{bits: 4},{name:'rxfifotr', bits:4},{bits: 20}], config: {lanes: 2, hflip: true}} "/>

### FIFO Status Register [Offset: 0x18, mode: r]

FIFO Status Register

|bit|field name|width|description|
|---|---|---|---|
|0|rx_level|4|Receive FIFO Level|
|8|tx_level|4|Transmit FIFO Level|

<img src="https://svg.wavedrom.com/{reg:[{name:'rx_level', bits:4},{bits: 4},{name:'tx_level', bits:4},{bits: 20}], config: {lanes: 2, hflip: true}} "/>

### Match Register [Offset: 0x1c, mode: w]

Match Register

<img src="https://svg.wavedrom.com/{reg:[{name:'match', bits:9},{bits: 23}], config: {lanes: 2, hflip: true}} "/>

## Interrupt Flags

|bit|flag|width|
|---|---|---|
|0|TX_EMPTY|1|
|1|RX_FULL|1|
|2|TX_LEVEL_BELOW|1|
|3|RX_LEVEL_ABOVE|1|
|4|LINE_BREAK|1|
|5|MATCH|1|
|6|FRAME_ERROR|1|
|7|PARITY_ERROR|1|
|8|OVERRUN|1|
|9|TIMEOUT|1|

## Usage Guidelines:
1. Set the prescaler according to the required transmission and receiving baud rate where  ```Baud_rate = Bus_Clock_Freq/((Prescaler+1)*16)``` . Setting the prescaler is done through writing to the prescaler register
2. Configure the frame format by : 
    * Choosing the number of data bits which could vary from 5 to 9. This is done by setting the ```wlen``` field in the ```config``` register
    * Choosing whether the stop bits are one or two by setting the ```stb2``` bit in ```config``` register where ‘0’ means one bit and ‘1’ means two bits
    * Choosing the parity type by setting ```parity``` field in ```config``` register where 000: None, 001: odd, 010: even, 100: Sticky 0, 101: Sticky 1
3. Set the receiver timeout value which fires the ```timeout``` interrupt after a certain amount of bits are received. This would be useful when the message received is not a multiple of the FIFO’s width.Timeout can be set by writing to the ```timeout``` field in the ```config``` register
4. Set the FIFO thresholds  by writing to the ```rxfifotr``` and ```txfifotr``` fields in ```fifo_control``` register. This would fire ```rx_level_above``` and ```tx_level_below``` interrupts when the RX FIFO level is above the threshold and TX FIFO level is below the threshold.
5. Enable the UART as well as RX or TX or both by setting ```en``` , ```txen```, and ```rxen``` bits to ones in the ```control``` register
6. To optionally connect the RX signal to the TX signal so the UART transmits whatever it receives then enable loopback by setting the ```loopback``` bit to one in the ```control``` register.
7. To optionally enable glitch filter on RX , set the ```gfen``` bit to one in the ```control``` register.
8. To read what was received , you can read ```rxdata``` register. Note: you should check that there is something in the FIFO before reading using the interrupts registers.
9. To optionally check if the data received matches a certain value by writing to the ```match``` register. This would fire the ```match``` interrupt if the received data matches the match value.
10. To transmit, write to the ```txdata``` register. Note: you should check that the FIFO is not full before adding something to it using the interrupts register to avoid losing data. 

## Installation:
You can either clone repo or use [IPM](https://github.com/efabless/IPM) which is an open-source IPs Package Manager
* To clone repo
```git clone https://github.com/efabless/EF_UART.git```

* To download via IPM , follow installation guides [here](https://github.com/efabless/IPM/blob/main/README.md) then run 
```ipm install EF_UART```

## Simulation:
### Run Verilog TB:
2. Clone [IP_Utilities](https://github.com/shalan/IP_Utilities) repo under ``EF_UART/`` directory
3. In the directory ``EF_UART/verify/utb/`` run ``make APB-RTL``

### Run cocotb UVM TB:
