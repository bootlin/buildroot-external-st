# Using the switch

Applicable platforms: STM32MP257F-DK.

```
# switch_startup.sh
```

This script loads Linux modules and configure the switch.

```
# ip addr add 192.168.5.2 dev sw0ep
# ip route add 192.168.5.0/24 dev sw0ep
```

This configure the Switch internal port to IP 192.168.5.2/24.

```
# ping -I sw0ep 192.168.5.1
64 bytes from 192.168.5.1: seq=0 ttl=64 time=0.947 ms
64 bytes from 192.168.5.1: seq=1 ttl=64 time=0.450 ms
64 bytes from 192.168.5.1: seq=2 ttl=64 time=0.492 ms
...
```

Configure the host Ethernet port to IP 192.168.5.1/24.
Then if you run a ping and plug the Ethernet to ETH1 (sw0p3) or ETH3 (sw0p2)
port you will see the ping packet transmitted.

---

Note:
The devicetree description part that enable the switch in the devicetree is this:

```
&pinctrl {
        eth3_rgmii_pins_a: eth3-rgmii-0 {
                pins1 {
                        pinmux = <STM32_PINMUX('A', 6, AF14)>, /* ETH_RGMII_TXD0 */
                                 <STM32_PINMUX('A', 7, AF14)>, /* ETH_RGMII_TXD1 */
                                 <STM32_PINMUX('H', 6, AF14)>, /* ETH_RGMII_TXD2 */
                                 <STM32_PINMUX('H', 3, AF14)>, /* ETH_RGMII_TXD3 */
                                 <STM32_PINMUX('A', 3, AF14)>; /* ETH_RGMII_TX_CTL */
                        bias-disable;
                        drive-push-pull;
                        slew-rate = <3>;
                        st,io-retime = <1>;
                        st,io-clk-edge = <1>;
                };
                pins2 {
                        pinmux = <STM32_PINMUX('H', 2, AF14)>; /* ETH_RGMII_GTX_CLK */
                        bias-disable;
                        drive-push-pull;
                        slew-rate = <3>;
                        st,io-delay = <2>;
                };
                pins3 {
                        pinmux = <STM32_PINMUX('A', 9, AF14)>, /* ETH_RGMII_RXD0 */
                                 <STM32_PINMUX('A', 10, AF14)>, /* ETH_RGMII_RXD1 */
                                 <STM32_PINMUX('H', 7, AF14)>, /* ETH_RGMII_RXD2 */
                                 <STM32_PINMUX('H', 8, AF14)>, /* ETH_RGMII_RXD3 */
                                 <STM32_PINMUX('A', 2, AF14)>; /* ETH_RGMII_RX_CTL */
                        bias-disable;
                        st,io-retime = <1>;
                        st,io-clk-edge = <1>;
                };
                pins4 {
                        pinmux = <STM32_PINMUX('A', 5, AF14)>; /* ETH_RGMII_RX_CLK */
                        bias-disable;
                };
        };

        eth3_rgmii_sleep_pins_a: eth3-rgmii-sleep-0 {
                pins1 {
                        pinmux = <STM32_PINMUX('A', 6, ANALOG)>, /* ETH_RGMII_TXD0 */
                                 <STM32_PINMUX('A', 7, ANALOG)>, /* ETH_RGMII_TXD1 */
                                 <STM32_PINMUX('H', 6, ANALOG)>, /* ETH_RGMII_TXD2 */
                                 <STM32_PINMUX('H', 3, ANALOG)>, /* ETH_RGMII_TXD3 */
                                 <STM32_PINMUX('A', 3, ANALOG)>, /* ETH_RGMII_TX_CTL */
                                 <STM32_PINMUX('H', 2, ANALOG)>, /* ETH_RGMII_GTX_CLK */
                                 <STM32_PINMUX('A', 9, ANALOG)>, /* ETH_RGMII_RXD0 */
                                 <STM32_PINMUX('A', 10, ANALOG)>, /* ETH_RGMII_RXD1 */
                                 <STM32_PINMUX('H', 7, ANALOG)>, /* ETH_RGMII_RXD2 */
                                 <STM32_PINMUX('H', 8, ANALOG)>, /* ETH_RGMII_RXD3 */
                                 <STM32_PINMUX('A', 2, ANALOG)>, /* ETH_RGMII_RX_CTL */
                                 <STM32_PINMUX('A', 5, ANALOG)>; /* ETH_RGMII_RX_CLK */
                };
        };
};

&eth1 {
        status = "okay";
        pinctrl-0 = <&eth1_mdio_pins_mx>, <&eth1_rgmii_pins_mx>;
        pinctrl-1 = <&eth1_mdio_sleep_pins_mx>, <&eth1_rgmii_sleep_pins_mx>;
        pinctrl-names = "default", "sleep";
        phy-mode = "rgmii";
        max-speed = <1000>;
        st,eth-clk-sel;

        fixed_link: fixed-link {
                speed = <1000>;
                full-duplex;
        };

        mdio1 {
                #address-cells = <1>;
                #size-cells = <0>;
                compatible = "snps,dwmac-mdio";

                phy1_eth1: ethernet-phy@4 {
                        compatible = "ethernet-phy-id001c.c916",
                                     "ethernet-phy-ieee802.3-c22";
                        /* reset gpios is managed by default dual ethenet
                         * configuration
                         */
                        realtek,eee-disable;
                        reg = <4>;
                };

                phy2_eth1: ethernet-phy@5 {
                        compatible = "ethernet-phy-id001c.c916",
                                     "ethernet-phy-ieee802.3-c22";
                        realtek,eee-disable;
                        reg = <5>;
                };
        };
};

&switch0 {
        status = "okay";
        pinctrl-0 = <&eth3_rgmii_pins_a>;
        pinctrl-1 = <&eth3_rgmii_sleep_pins_a>;
        pinctrl-names = "default", "sleep";
        phy-mode = "rgmii";
        st,ethsw-internal-125;
};
```
