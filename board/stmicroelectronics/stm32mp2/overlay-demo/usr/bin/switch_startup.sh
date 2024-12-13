#!/bin/sh

REF_ETH_INTERFACE=eth0
IP_REF_NAME=42080000.bus/42080000.bus:ttt-sw@4c000000/4c000000.deip-sw

load_modules() {
	modprobe 8021q
	modprobe bridge
	modprobe sch_prio
	modprobe sch_mqprio
	modprobe stm32_deip
	modprobe edgx_pfm_lkm netif="$REF_ETH_INTERFACE:0"
}

# read mac address
get_mac() {
    read MAC </sys/class/net/$REF_ETH_INTERFACE/address
    echo "[INFO]: Mac Address of $REF_ETH_INTERFACE: $MAC"
}

get_soc_path() {
    devicetree_path=$(ls -1 -d /sys/devices/platform/* | grep "/soc" | head -n 1)
    if [ -d "$devicetree_path" ];
    then
        SOC_PATH=$devicetree_path
    else
        echo "[ERROR]: /sys/devices/platform/soc* is not available"
        echo ""
        exit 1
    fi

}

wait_sysfs() {
    path=$1
            for i in $(seq 0 5)
        do
            if [ ! -e "$path" ]; then
                break;
            else
                sleep 0.5s
            fi
        done
}

st_configure() {
    get_soc_path
    wait_sysfs $SOC_PATH/$IP_REF_NAME/net/sw0p3/phy/mdiobus
    if [ -e $SOC_PATH/$IP_REF_NAME/net/sw0p3/phy/mdiobus ]; then
        echo -n stmmac-1:04 > $SOC_PATH/$IP_REF_NAME/net/sw0p3/phy/mdiobus
        echo -n stmmac-1:05 > $SOC_PATH/$IP_REF_NAME/net/sw0p2/phy/mdiobus
    else
        echo "[ERROR]: $SOC_PATH/$IP_REF_NAME/net/sw0p3/phy/mdiobus not available"
        echo ""
        exit 1
    fi

    echo 170 > /sys/class/net/sw0p2/phy/delay1000tx_min
    echo 200 > /sys/class/net/sw0p2/phy/delay1000tx_max
    echo 170 > /sys/class/net/sw0p3/phy/delay1000tx_min
    echo 200 > /sys/class/net/sw0p3/phy/delay1000tx_max
    echo 520 > /sys/class/net/sw0p2/phy/delay1000rx_min
    echo 570 > /sys/class/net/sw0p2/phy/delay1000rx_max
    echo 520 > /sys/class/net/sw0p3/phy/delay1000rx_min
    echo 570 > /sys/class/net/sw0p3/phy/delay1000rx_max
}

set_interfaces_up()
{
    get_mac
    ip link set dev sw0ep address $MAC
    ip link set dev sw0ep up
    ip link add name br0 type bridge
    ip link set dev br0 up
    ip link set dev sw0p1 master br0 up
    ip link set dev sw0p2 master br0 up
    ip link set dev sw0p3 master br0 up
    ip link set dev sw0ep up
}

echo "[INFO]: Load switch modules"
load_modules
echo "[INFO]: ST configuration of IP"
st_configure
echo "[INFO]: ST set brigde interface"
set_interfaces_up
