# Installation Guide Network & Internet Infrastructure - Windows Side

## Requirements

- 5 routers (for Windows side)
- 3 Layer 2 switches (for Windows side)
- A sufficient amount of ethernet (at least 7) & serial cables (at least 5)
- At least one console cable

## Physical configuration

1. Make sure the routers and switches have no configuration running. To remove possible configuration, refer to the router or switch manual.
2. Label the 5 routers accordingly:

- Router 1
- Router 3
- Router 4
- Router 5
- Router 6

3. Label the 3 switches accordingly:

- Switch 4
- Switch 5
- Switch 7

4. Plug in and connect the devices using the table below. `S0/1/0` & `S0/1/1` require serial cables, `G0/0/0`, `G0/0/1` & `F0/1` require ethernet cables.
5. For Router 4, plug `G0/0/0` into your internet source (modem, WAN switch,...)
6. `(if no firewall)` is optional configuration if the Zulu2 firewall is not present.

| Device   | S0/1/0                    | S0/1/1                    | G0/0/0              | G0/0/1             | F0/1     |
| -------- | ------------------------- | ------------------------- | ------------------- | ------------------ | -------- |
| Router 1 | (If no firewall) Router 6 | Router 3                  | Zulu2 when present  | -                  | -        |
| Router 3 | Router 4                  | Router 1                  | Router 2 (To LINUX) | -                  | -        |
| Router 4 | Router 3                  | Router 2 (To LINUX)       | WAN connection      | -                  | -        |
| Router 5 | Router 6                  | -                         | Switch 5            | Switch 4           | -        |
| Router 6 | Router 5                  | (If no firewall) Router 1 | Switch 7            | Zulu2 when present | -        |
| Switch 4 | -                         | -                         | -                   | -                  | Router 5 |
| Switch 5 | -                         | -                         | -                   | -                  | Router 5 |
| Switch 7 | -                         | -                         | -                   | -                  | Router 6 |

7. Turn on the devices.

## Configuration per device

1. Connect to Router 1 using a console cable by connecting the ethernet connector into the console port of Router 1 and plugging the USB side into your pc.
2. Connect to Router 1 using PuTTY or a similar program. Refer to their software manual if you don't know how to connect.
3. When asked if you would like to enter the initial configuration mode, type `no` and press enter.
4. Copy and paste the [configurations](https://github.com/HoGentTIN/p3ops-1920-red/blob/network/Netwerkbeheer/Configurations.md) from Router 1 into the device terminal screen. Use right click to paste.
5. This will secure the router with passwords, set up interfaces and routes, and filter access by IP.
6. Repeat steps 1-4 for every router.
7. Connect to Switch 4 using a console cable by connecting the ethernet connector into the console port of Switch 4 and plugging the USB side into your pc.
8. Connect to Switch 4 using PuTTY or a similar program. Refer to their software manual if you don't know how to connect.
9. When asked if you would like to enter the initial configuration mode, type `no` and press enter.
10. Copy and paste the [configurations](https://github.com/HoGentTIN/p3ops-1920-red/blob/network/Netwerkbeheer/Configurations.md) from Switch 4 into the device terminal screen. Use right click to paste.
11. This will secure the switch with passwords, create VLANs and assign the VLANs to interfaces.
12. Repeat steps 7-10 for every switch.

## Aftermath & Testing

- To log in on a configured device via a console connection, use the `Console2019` password.
- To gain elevated access, use the `Admin2019` password.
- To connect over the VTY lines, use the `Telnet2019` password.
- To set up end devices, refer to the [IP Table](https://github.com/HoGentTIN/p3ops-1920-red/blob/network/Netwerkbeheer/IP%20Table.md).
- To test the completed infrastructure, refer to the [Testplan](https://github.com/HoGentTIN/p3ops-1920-red/blob/network/Netwerkbeheer/Testplan.md).
