#!/usr/bin/env bash
# This file uses the following encoding: utf-8

# ===== #
#
# ▀█████████▄     ▄████████         Websites: HackingPassion.com | Bullseye0.com
#   ███    ███   ███    ███         Author: Jolanda de Koff | Bulls Eye
#   ███    ███   ███    █▀          GitHub: https://github.com/BullsEye0
#  ▄███▄▄▄██▀   ▄███▄▄▄             LinkedIn: https://www.linkedin.com/in/jolandadekoff
# ▀▀███▀▀▀██▄  ▀▀███▀▀▀             Facebook Group: https://www.facebook.com/groups/hack.passion/
#   ███    ██▄   ███    █▄          Facebook: https://www.facebook.com/profile.php?id=100069546190609
#   ███    ███   ███    ███         YouTube: https://www.youtube.com/@HackingPassion
# ▄█████████▀    ██████████         LBRY: https://lbry.tv/$/invite/@hackingpassion:9
#                                   Newsletter: https://hackingpassion.com/newsletter/
#          Bulls Eye..!
# ===== #

# Anon Eye v3.0.0
# Copyright (c) Sept 2026 Jolanda de Koff.
#
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
# See the LICENSE file in this repository for the full text.

########################################################################

# A notice to all nerds and n00bs...
# If you will copy the developer's work, it will not make you a hacker..!

########################################################################

RED='\033[1;31m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
NC='\033[0m'

B4CKUP="/var/lib/anon-eye"
M4RKER="$B4CKUP/active"
T0RUID="debian-tor"
BR0WSER="anonbrowser"
TR4NSPORT="9040"
DNSP0RT="5353"
S0CKSPORT="9050"
CTRLP0RT="9051"
V1RTNET="10.192.0.0/10"
N4TCHAIN="AE_NAT"
FLTCH41N="AE_OUT"
T0RTAG="AnonEye"
T0RSERVICE="tor@default"
M1NWAIT="10"
T3STED="kali parrot"
D1STRO=""
D1STNAME=""
L1KE=""

banner() {
    clear
    echo -e "${RED}"
    echo " ▄▄▄·  ▐ ▄        ▐ ▄     ▄▄▄ . ▄· ▄▌▄▄▄ ."
    echo "▐█ ▀█ •█▌▐█▪     •█▌▐█    ▀▄.▀·▐█▪██▌▀▄.▀·"
    echo "▄█▀▀█ ▐█▐▐▌ ▄█▀▄ ▐█▐▐▌    ▐▀▀▪▄▐█▌▐█▪▐▀▀▪▄"
    echo "▐█ ▪▐▌██▐█▌▐█▌.▐▌██▐█▌    ▐█▄▄▌ ▐█▀·.▐█▄▄▌"
    echo " ▀  ▀ ▀▀ █▪ ▀█▄▀▪▀▀ █▪     ▀▀▀   ▀ •  ▀▀▀ "
    echo -e "${NC}"
    echo -e "\t${BLUE}Anon Eye v3.0.0${NC}  ${RED}by Jolanda de Koff | Bulls Eye${NC}"
    echo -e "\t${BLUE}Github:${NC}  https://github.com/BullsEye0"
    echo -e "\t${BLUE}Website:${NC} https://HackingPassion.com"
    echo ""
    echo -e "\t${RED}Hi there, Shall we play a game..?${NC} 😃"
    echo ""
}

b00m() {
    echo ""
    echo -e "\n\t${BLUE}Anon Eye${NC} DONE... ${BLUE}I like to See Ya, Hacking Anywhere ..!${NC} 😃\n"
    exit 0
}

h0ld() {
    trap '' INT
}

r3lease() {
    trap b00m INT
}

r00tcheck() {
    if [[ $EUID -ne 0 ]]; then
        banner
        echo -e "${RED}[-] This tool needs root. Run it with sudo.${NC}"
        echo ""
        exit 1
    fi
}

d3tect() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        D1STRO="$ID"
        D1STNAME="$PRETTY_NAME"
        L1KE="$ID_LIKE"
    fi

    case "$D1STRO" in
        parrot|kali|debian|ubuntu|linuxmint|pop|elementary|zorin) ;;
        *)
            if [[ "$L1KE" != *debian* && "$L1KE" != *ubuntu* ]]; then
                banner
                echo -e "${RED}[-] This tool only runs on Debian based systems.${NC}"
                echo -e "${RED}[-] Detected: ${D1STNAME}${NC}"
                echo ""
                exit 1
            fi
            ;;
    esac

    if ! command -v systemctl &>/dev/null; then
        banner
        echo -e "${RED}[-] This tool needs systemd. Your system does not have systemctl.${NC}"
        echo -e "${RED}[-] Detected: ${D1STNAME}${NC}"
        echo ""
        exit 1
    fi

    for u in debian-tor toranon tor; do
        if id "$u" &>/dev/null; then
            T0RUID="$u"
            break
        fi
    done

    systemctl list-unit-files 2>/dev/null | grep -q "^tor@" || T0RSERVICE="tor"
}

n0ttested() {
    if [[ " $T3STED " != *" $D1STRO "* ]]; then
        banner
        echo -e "${BLUE}[~] Detected: ${D1STNAME}${NC}"
        echo ""
        echo -e "${RED}[!] Anon Eye is tested on Kali and Parrot. Your system is not on that list.${NC}"
        echo -e "${RED}[!] It is built for Debian based systems and should work here, but nobody ran it yet.${NC}"
        echo ""
        read -rp "$(echo -e "    ${BLUE}Continue anyway? (Y/N): ${NC}")" g0on
        echo ""
        [[ "$g0on" =~ ^[Yy]$ ]] || exit 0
    fi
}

st4le() {
    [[ -f "$B4CKUP/adopted" ]] && ad0pt
    [[ -f "$M4RKER" ]] || return 0
    iptables -S OUTPUT 2>/dev/null | grep -q "$FLTCH41N" && return 0
    banner
    echo -e "${RED}[!] The marker says anonymous mode is on, but the firewall rules are gone.${NC}"
    echo -e "${RED}[!] That happens after a reboot or a hard stop.${NC}"
    echo ""
    echo -e "${BLUE}[~] Cleaning up what is left...${NC}"
    h0ld
    ch41ns_back
    dns0unlock
    v60n
    t1mez0ne_back
    t0rstrip
    s3rvice restart
    rm -f "$M4RKER"
    r3lease
    echo ""
    echo -e "${GREEN}[✓] Cleaned up. You can start again.${NC}"
    echo ""
    read -rp "$(echo -e "    ${BLUE}Press Enter to continue${NC}")"
}

f0reign() {
    if systemctl is-active anonsurfd &>/dev/null; then
        banner
        echo -e "${RED}[-] Parrot AnonSurf is running. Stop it first with: anonsurf stop${NC}"
        echo ""
        exit 1
    fi
    if iptables -t nat -S OUTPUT 2>/dev/null | grep -q -- "--to-ports 9040" && [[ ! -f "$M4RKER" ]]; then
        banner
        echo -e "${RED}[-] Another transparent proxy already redirects your traffic.${NC}"
        echo -e "${RED}[-] Clean that up first, this tool will not write over it.${NC}"
        echo ""
        exit 1
    fi
}

mk_b4ckup() {
    [[ -d "$B4CKUP" ]] || mkdir -p "$B4CKUP"
    chmod 700 "$B4CKUP"
}

d3ps() {
    m1ssing=""
    for p in tor iptables ip6tables curl ss dig; do
        command -v "$p" &>/dev/null || m1ssing="$m1ssing $p"
    done

    if [[ -n "$m1ssing" ]]; then
        banner
        echo -e "${BLUE}[~] Detected: ${D1STNAME}${NC}"
        echo ""
        echo -e "${RED}[!] Missing:${m1ssing}${NC}"
        echo ""
        read -rp "$(echo -e "    ${BLUE}Install them now? (Y/N): ${NC}")" oeps
        echo ""
        if [[ "$oeps" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}[~] Installing...${NC}"
            apt-get update -y &>/dev/null
            apt-get install -y tor iptables curl iproute2 &>/dev/null
            apt-get install -y bind9-dnsutils &>/dev/null || apt-get install -y dnsutils &>/dev/null
            banner
            if command -v tor &>/dev/null; then
                echo -e "${GREEN}[✓] Congratulations, installation complete.${NC}"
            else
                echo -e "${RED}[-] Installation failed. Check your network and try again.${NC}"
                echo ""
                exit 1
            fi
            echo ""
        else
            echo -e "${RED}[-] Nothing to do without Tor.${NC}"
            echo ""
            exit 1
        fi
    fi
}

s3rvice() {
    systemctl "$1" "$T0RSERVICE" &>/dev/null
}

l1stens() {
    ss -ltnH 2>/dev/null | grep -q "127.0.0.1:$1[[:space:]]"
}

l1stensudp() {
    ss -lunH 2>/dev/null | grep -q "127.0.0.1:$1[[:space:]]"
}

t0rverify() {
    d3faults=""
    [[ -f /usr/share/tor/tor-service-defaults-torrc ]] && d3faults="--defaults-torrc /usr/share/tor/tor-service-defaults-torrc"
    tor $d3faults -f /etc/tor/torrc --verify-config &>/dev/null
}

p0rtof() {
    v4lue=$(grep -iE "^[[:space:]]*$1[[:space:]]" /etc/tor/torrc 2>/dev/null | head -n 1 | awk '{print $2}')
    v4lue="${v4lue##*:}"
    [[ "$v4lue" =~ ^[0-9]+$ ]] || return 1
    echo "$v4lue"
}

ad0pt() {
    tp0rt=$(p0rtof TransPort) || return 1
    dp0rt=$(p0rtof DNSPort) || return 1
    TR4NSPORT="$tp0rt"
    DNSP0RT="$dp0rt"
    cp0rt=$(p0rtof ControlPort) && CTRLP0RT="$cp0rt"
    return 0
}

t0rc0nfig() {
    [[ -f "$B4CKUP/torrc" ]] || cp /etc/tor/torrc "$B4CKUP/torrc"
    t0rstrip
    if ad0pt; then
        touch "$B4CKUP/adopted"
        echo -e "${BLUE}[~] Your system already has Tor ports of its own, using those${NC}"
        echo -e "${GREEN}[✓] TransPort ${TR4NSPORT}, DNSPort ${DNSP0RT}, ControlPort ${CTRLP0RT}${NC}"
        return 0
    fi
    rm -f "$B4CKUP/adopted"
    l3ftover=$(grep -nE "^[[:space:]]*(TransPort|DNSPort|ControlPort)[[:space:]]" /etc/tor/torrc)
    [[ -n "$l3ftover" ]] && return 1
    {
        echo "# ${T0RTAG} START"
        echo "VirtualAddrNetworkIPv4 ${V1RTNET}"
        echo "AutomapHostsOnResolve 1"
        echo "TransPort ${TR4NSPORT} IsolateClientAddr IsolateClientProtocol IsolateDestAddr IsolateDestPort"
        echo "DNSPort ${DNSP0RT}"
        echo "ControlPort ${CTRLP0RT}"
        echo "# ${T0RTAG} END"
    } >> /etc/tor/torrc
    return 0
}

t0rstrip() {
    sed -i "/# ${T0RTAG} START/,/# ${T0RTAG} END/d" /etc/tor/torrc
    sed -i -E "/^# ${T0RTAG}\$/,+6{/^# ${T0RTAG}\$/d;/^(VirtualAddrNetworkIPv4|AutomapHostsOnResolve|TransPort|DNSPort|SocksPort|ControlPort|CookieAuthentication)/d}" /etc/tor/torrc
}

p0rtowner() {
    ss -ltnpH 2>/dev/null | grep "127.0.0.1:$1[[:space:]]" | sed 's/.*users:((//;s/)).*//'
}

t0rdown() {
    systemctl reset-failed "$T0RSERVICE" &>/dev/null
    s3rvice stop
    w41t=0
    while [[ $w41t -lt 15 ]]; do
        l1stens "$TR4NSPORT" || return 0
        sleep 1
        w41t=$((w41t + 1))
    done
    return 1
}

t0rup() {
    if [[ -f "$B4CKUP/adopted" ]] && l1stens "$TR4NSPORT" && l1stensudp "$DNSP0RT"; then
        return 0
    fi
    if ! t0rdown; then
        h0lder=$(p0rtowner "$TR4NSPORT")
        echo -e "${RED}[-] Port ${TR4NSPORT} is still held by: ${h0lder:-unknown}${NC}"
        echo -e "${RED}[-] Close that first, this tool will not fight over the port.${NC}"
        return 1
    fi
    s3rvice start
    w41t=0
    while [[ $w41t -lt 30 ]]; do
        if l1stens "$TR4NSPORT" && l1stensudp "$DNSP0RT"; then
            return 0
        fi
        sleep 1
        w41t=$((w41t + 1))
    done
    return 1
}

dns0lock() {
    if [[ -L /etc/resolv.conf ]]; then
        readlink /etc/resolv.conf > "$B4CKUP/resolv.link"
        if systemctl is-active systemd-resolved &>/dev/null; then
            systemctl stop systemd-resolved &>/dev/null
            touch "$B4CKUP/resolved.stopped"
        fi
        rm -f /etc/resolv.conf
        echo "nameserver 127.0.0.1" > /etc/resolv.conf
    else
        [[ -f "$B4CKUP/resolv.conf" ]] || cp /etc/resolv.conf "$B4CKUP/resolv.conf" 2>/dev/null
        chattr -i /etc/resolv.conf &>/dev/null
        echo "nameserver 127.0.0.1" > /etc/resolv.conf
        chattr +i /etc/resolv.conf &>/dev/null
    fi
    echo -e "${GREEN}[✓] DNS locked to the local Tor resolver${NC}"
}

dns0unlock() {
    chattr -i /etc/resolv.conf &>/dev/null
    if [[ -f "$B4CKUP/resolv.link" ]]; then
        rm -f /etc/resolv.conf
        ln -s "$(cat "$B4CKUP/resolv.link")" /etc/resolv.conf
        rm -f "$B4CKUP/resolv.link"
        if [[ -f "$B4CKUP/resolved.stopped" ]]; then
            systemctl start systemd-resolved &>/dev/null
            rm -f "$B4CKUP/resolved.stopped"
        fi
    elif [[ -f "$B4CKUP/resolv.conf" ]]; then
        cp "$B4CKUP/resolv.conf" /etc/resolv.conf
        rm -f "$B4CKUP/resolv.conf"
    fi
    echo -e "${GREEN}[✓] DNS restored${NC}"
}

ch41ns() {
    iptables -t nat -N "$N4TCHAIN" &>/dev/null
    iptables -t nat -F "$N4TCHAIN"
    iptables -t nat -A "$N4TCHAIN" -m owner --uid-owner "$T0RUID" -j RETURN
    iptables -t nat -A "$N4TCHAIN" -p udp --dport 53 -j REDIRECT --to-ports "$DNSP0RT"
    tbb1nstalled && iptables -t nat -A "$N4TCHAIN" -m owner --uid-owner "$BR0WSER" -j RETURN
    iptables -t nat -A "$N4TCHAIN" -d 127.0.0.0/8 -j RETURN
    iptables -t nat -A "$N4TCHAIN" -d "$V1RTNET" -p tcp --syn -j REDIRECT --to-ports "$TR4NSPORT"
    iptables -t nat -A "$N4TCHAIN" -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A "$N4TCHAIN" -d 172.16.0.0/12 -j RETURN
    iptables -t nat -A "$N4TCHAIN" -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A "$N4TCHAIN" -p tcp --syn -j REDIRECT --to-ports "$TR4NSPORT"
    iptables -t nat -C OUTPUT -j "$N4TCHAIN" &>/dev/null || iptables -t nat -I OUTPUT 1 -j "$N4TCHAIN"

    iptables -N "$FLTCH41N" &>/dev/null
    iptables -F "$FLTCH41N"
    iptables -A "$FLTCH41N" -o lo -j ACCEPT
    iptables -A "$FLTCH41N" -m owner --uid-owner "$T0RUID" -j ACCEPT
    tbb1nstalled && iptables -A "$FLTCH41N" -m owner --uid-owner "$BR0WSER" -j ACCEPT
    iptables -A "$FLTCH41N" -m conntrack --ctstate INVALID -j DROP
    iptables -A "$FLTCH41N" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A "$FLTCH41N" -p udp --sport 68 --dport 67 -j ACCEPT
    iptables -A "$FLTCH41N" -d 127.0.0.0/8 -j ACCEPT
    iptables -A "$FLTCH41N" -d 10.0.0.0/8 -j ACCEPT
    iptables -A "$FLTCH41N" -d 172.16.0.0/12 -j ACCEPT
    iptables -A "$FLTCH41N" -d 192.168.0.0/16 -j ACCEPT
    iptables -A "$FLTCH41N" -p udp -j DROP
    iptables -A "$FLTCH41N" -j DROP
    iptables -C OUTPUT -j "$FLTCH41N" &>/dev/null || iptables -I OUTPUT 1 -j "$FLTCH41N"

    echo -e "${GREEN}[✓] All TCP goes through Tor, UDP blocked, local network still reachable, kill switch active${NC}"
}

ch41ns_back() {
    while iptables -t nat -C OUTPUT -j "$N4TCHAIN" &>/dev/null; do
        iptables -t nat -D OUTPUT -j "$N4TCHAIN"
    done
    iptables -t nat -F "$N4TCHAIN" &>/dev/null
    iptables -t nat -X "$N4TCHAIN" &>/dev/null

    while iptables -C OUTPUT -j "$FLTCH41N" &>/dev/null; do
        iptables -D OUTPUT -j "$FLTCH41N"
    done
    iptables -F "$FLTCH41N" &>/dev/null
    iptables -X "$FLTCH41N" &>/dev/null

    echo -e "${GREEN}[✓] Firewall rules removed, your own rules untouched${NC}"
}

v6off() {
    ip6tables -P INPUT DROP &>/dev/null
    ip6tables -P OUTPUT DROP &>/dev/null
    ip6tables -P FORWARD DROP &>/dev/null
    sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>/dev/null
    sysctl -w net.ipv6.conf.default.disable_ipv6=1 &>/dev/null
    echo -e "${GREEN}[✓] IPv6 disabled${NC}"
}

v60n() {
    sysctl -w net.ipv6.conf.all.disable_ipv6=0 &>/dev/null
    sysctl -w net.ipv6.conf.default.disable_ipv6=0 &>/dev/null
    ip6tables -P INPUT ACCEPT &>/dev/null
    ip6tables -P OUTPUT ACCEPT &>/dev/null
    ip6tables -P FORWARD ACCEPT &>/dev/null
    echo -e "${GREEN}[✓] IPv6 restored${NC}"
}

t1mez0ne() {
    if ! command -v timedatectl &>/dev/null; then
        echo -e "${RED}[-] No timedatectl, timezone left as it is${NC}"
        return
    fi
    [[ -f "$B4CKUP/timezone" ]] || timedatectl show -p Timezone --value > "$B4CKUP/timezone" 2>/dev/null
    timedatectl set-timezone Etc/UTC &>/dev/null
    n0wtz=$(timedatectl show -p Timezone --value 2>/dev/null)
    if [[ "$n0wtz" == "Etc/UTC" ]]; then
        echo -e "${GREEN}[✓] Timezone set to UTC${NC}"
    else
        echo -e "${RED}[-] Could not set the timezone, it is still ${n0wtz}${NC}"
    fi
}

t1mez0ne_back() {
    [[ -f "$B4CKUP/timezone" ]] || return
    pr3vtz=$(cat "$B4CKUP/timezone")
    if [[ -n "$pr3vtz" ]] && command -v timedatectl &>/dev/null; then
        timedatectl set-timezone "$pr3vtz" &>/dev/null
        echo -e "${GREEN}[✓] Timezone back to ${pr3vtz}${NC}"
    fi
    rm -f "$B4CKUP/timezone"
}

g0() {
    if [[ -f "$M4RKER" ]]; then
        echo -e "${RED}[-] Already running. Stop it first.${NC}"
        echo ""
        return
    fi

    h0ld
    echo -e "${BLUE}[~] Writing the Tor configuration...${NC}"
    if ! t0rc0nfig; then
        echo -e "${RED}[-] Your torrc already has listener lines of its own:${NC}"
        echo "$l3ftover" | sed 's/^/    /'
        echo -e "${RED}[-] Remove them from /etc/tor/torrc first. This tool will not write over them.${NC}"
        echo ""
        r3lease
        return
    fi

    if ! t0rverify; then
        echo -e "${RED}[-] Tor refuses this configuration. Nothing was changed.${NC}"
        echo -e "${RED}[-] Check it yourself with: tor -f /etc/tor/torrc --verify-config${NC}"
        t0rstrip
        echo ""
        r3lease
        return
    fi
    echo -e "${GREEN}[✓] Configuration accepted by Tor${NC}"

    echo -e "${BLUE}[~] Starting Tor and waiting for it to listen...${NC}"
    if ! t0rup; then
        echo -e "${RED}[-] Tor is not listening on ${TR4NSPORT} and ${DNSP0RT}.${NC}"
        echo -e "${RED}[-] This is what Tor said:${NC}"
        journalctl -u "$T0RSERVICE" -n 20 --no-pager 2>/dev/null | grep -iE "warn|err" | tail -4 | sed 's/^/    /'
        echo -e "${RED}[-] Full log: journalctl -u ${T0RSERVICE} -n 30${NC}"
        t0rstrip
        s3rvice restart
        echo ""
        r3lease
        return
    fi
    echo -e "${GREEN}[✓] Tor is listening on ${TR4NSPORT} and ${DNSP0RT}${NC}"

    dns0lock
    ch41ns
    v6off
    t1mez0ne
    touch "$M4RKER"
    r3lease
    echo ""
    wh0am1
}

st0p() {
    h0ld
    echo -e "${BLUE}[~] Shutting down anonymous mode...${NC}"
    ch41ns_back
    dns0unlock
    v60n
    t1mez0ne_back
    if [[ -f "$B4CKUP/adopted" ]]; then
        rm -f "$B4CKUP/adopted"
        echo -e "${GREEN}[✓] Your own Tor configuration was never touched${NC}"
    else
        t0rstrip
        s3rvice restart
    fi
    rm -f "$M4RKER"
    r3lease
    echo ""
    echo -e "${GREEN}[✓] Everything is back to normal${NC}"
    echo ""
}

c00kie() {
    for c in /run/tor/control.authcookie /var/run/tor/control.authcookie /var/lib/tor/control_auth_cookie; do
        if [[ -r "$c" ]]; then
            od -An -tx1 -v "$c" | tr -d ' \n'
            return 0
        fi
    done
    return 1
}

n3wnym() {
    c00k=$(c00kie) || return 1
    { exec 3<>"/dev/tcp/127.0.0.1/${CTRLP0RT}"; } 2>/dev/null || return 1
    printf 'AUTHENTICATE %s\r\nSIGNAL NEWNYM\r\nQUIT\r\n' "$c00k" >&3
    r3ply=$(timeout 5 cat <&3 2>/dev/null)
    exec 3>&-
    [[ "$r3ply" == *"250 OK"* ]]
}

n3wip() {
    if [[ ! -f "$M4RKER" ]]; then
        echo -e "${RED}[-] Anonymous mode is off, so a new circuit changes nothing about your address.${NC}"
        echo -e "${RED}[-] Start Anonymous Mode first.${NC}"
        echo ""
        return 1
    fi
    echo -e "${BLUE}[~] Asking Tor for a new circuit...${NC}"
    if ! l1stens "$CTRLP0RT"; then
        echo -e "${RED}[-] The control port is not open. Start Anonymous Mode first.${NC}"
        echo ""
        return 1
    fi
    if n3wnym; then
        sleep 5
        wh0am1
    else
        echo -e "${RED}[-] Tor did not accept the request on the control port${NC}"
        echo ""
        return 1
    fi
}

aut0ip() {
    read -rp "$(echo -e "    ${BLUE}Change the IP every how many seconds? ${NC}")" t1mer
    echo ""
    if ! [[ "$t1mer" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}[-] Numbers only..!${NC}"
        echo ""
        return
    fi
    if [[ "$t1mer" -lt "$M1NWAIT" ]]; then
        echo -e "${RED}[!] Asking faster than every ${M1NWAIT} seconds gives you nothing and loads the network.${NC}"
        t1mer="$M1NWAIT"
        echo -e "${BLUE}[~] Using ${M1NWAIT} seconds${NC}"
        echo ""
    fi
    echo -e "${BLUE}[~] Press x or 0 to go back to the menu${NC}"
    echo ""
    while true; do
        n3wip || break
        if read -rsn 1 -t "$t1mer" k3y; then
            case "$k3y" in
                x|X|0) break ;;
            esac
        fi
    done
    echo ""
}

mk_br0wser() {
    if ! id "$BR0WSER" &>/dev/null; then
        echo -e "${BLUE}[~] Creating the browser user ${BR0WSER}...${NC}"
        useradd -m -s /bin/bash "$BR0WSER" &>/dev/null
        if id "$BR0WSER" &>/dev/null; then
            echo -e "${GREEN}[✓] User ${BR0WSER} created${NC}"
        else
            echo -e "${RED}[-] Could not create the user${NC}"
            return 1
        fi
    fi
    return 0
}

tbb1nstalled() {
    id "$BR0WSER" &>/dev/null || return 1
    br0home=$(getent passwd "$BR0WSER" | cut -d: -f6)
    [[ -n "$br0home" ]] || return 1
    find "$br0home/.local/share/torbrowser" -name "start-tor-browser" -type f 2>/dev/null | grep -q .
}

t0screen() {
    us3rhome=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    xa=""
    [[ -f "$us3rhome/.Xauthority" ]] && xa="$us3rhome/.Xauthority"
    sudo -u "$SUDO_USER" env DISPLAY="${DISPLAY:-:0}" ${xa:+XAUTHORITY="$xa"} xhost +SI:localuser:"$BR0WSER" &>/dev/null
}

br0wserstart() {
    sudo -u "$BR0WSER" -H env DISPLAY="${DISPLAY:-:0}" torbrowser-launcher &>/dev/null &
}

br0wserstop() {
    pkill -u "$BR0WSER" &>/dev/null
    sleep 2
}

br0wser() {
    if ! command -v torbrowser-launcher &>/dev/null; then
        echo -e "${BLUE}[~] Tor Browser launcher is missing, installing it...${NC}"
        apt-get install -y torbrowser-launcher &>/dev/null
        if ! command -v torbrowser-launcher &>/dev/null; then
            echo -e "${RED}[-] Could not install torbrowser-launcher${NC}"
            echo ""
            return
        fi
        echo -e "${GREEN}[✓] torbrowser-launcher installed${NC}"
    fi
    mk_br0wser || return
    if [[ -z "$SUDO_USER" ]]; then
        echo -e "${RED}[-] Run this tool with sudo from your own account, the browser needs your screen${NC}"
        echo ""
        return
    fi
    t0screen

    if ! tbb1nstalled; then
        echo -e "${BLUE}[!] Tor Browser is not installed for ${BR0WSER} yet.${NC}"
        echo -e "${BLUE}[!] The download runs through Tor, so nobody sees you fetching it, and it is slow.${NC}"
        read -rp "$(echo -e "    ${BLUE}Download it now? (Y/N): ${NC}")" d0wn
        echo ""
        [[ "$d0wn" =~ ^[Yy]$ ]] || return
        echo -e "${BLUE}[~] Downloading through Tor, this takes a while...${NC}"
        br0wserstart
        w41t=0
        while [[ $w41t -lt 240 ]]; do
            tbb1nstalled && break
            sleep 10
            w41t=$((w41t + 1))
            [[ $((w41t % 6)) -eq 0 ]] && echo -e "${BLUE}[~] still busy, $((w41t / 6)) minutes so far${NC}"
        done
        if ! tbb1nstalled; then
            echo -e "${RED}[-] The download did not finish. Try again, Tor can be slow.${NC}"
            br0wserstop
            echo ""
            return
        fi
        echo -e "${GREEN}[✓] Tor Browser is installed for ${BR0WSER}${NC}"
        br0wserstop
        [[ -f "$M4RKER" ]] && ch41ns
        echo ""
    fi

    echo -e "${BLUE}[~] Starting Tor Browser as ${BR0WSER}, next to the system tunnel...${NC}"
    br0wserstart
    sleep 2
    echo -e "${GREEN}[✓] Tor Browser is starting with its own circuits${NC}"
    echo ""
}

k1llswitch() {
    if [[ ! -f "$M4RKER" ]]; then
        echo -e "${RED}[-] Start Anonymous Mode first, there is nothing to test${NC}"
        echo ""
        return
    fi
    echo -e "${BLUE}[!] This stops Tor for a moment and puts it back${NC}"
    read -rp "$(echo -e "    ${BLUE}Run the test? (Y/N): ${NC}")" t3st
    echo ""
    [[ "$t3st" =~ ^[Yy]$ ]] || return

    h0ld
    echo -e "${BLUE}[~] Stopping Tor...${NC}"
    s3rvice stop
    sleep 2
    l3ak=0
    echo -e "${BLUE}[~] Trying TCP without Tor...${NC}"
    if curl -s --max-time 8 -o /dev/null http://1.1.1.1; then
        echo -e "${RED}[-] TCP still gets out with Tor down${NC}"
        l3ak=1
    else
        echo -e "${GREEN}[✓] TCP is stopped${NC}"
    fi
    echo -e "${BLUE}[~] Trying ICMP without Tor...${NC}"
    if ping -c 2 -W 3 1.1.1.1 &>/dev/null; then
        echo -e "${RED}[-] ICMP still gets out, the filter rules are not holding${NC}"
        l3ak=1
    else
        echo -e "${GREEN}[✓] ICMP is stopped${NC}"
    fi
    echo ""
    if [[ $l3ak -eq 0 ]]; then
        echo -e "${GREEN}[✓] Nothing gets out with Tor down. The kill switch holds.${NC}"
    else
        echo -e "${RED}[-] Traffic leaks with Tor down. Do not trust this setup.${NC}"
    fi
    echo ""
    echo -e "${BLUE}[~] Starting Tor again...${NC}"
    if t0rup; then
        echo -e "${GREEN}[✓] Tor is back${NC}"
    else
        echo -e "${RED}[-] Tor did not come back. Use Restore All.${NC}"
    fi
    r3lease
    echo ""
}

st4tus() {
    echo -e "${BLUE}[~] System${NC}"
    echo -e "    ${D1STNAME}"

    echo ""
    echo -e "${BLUE}[~] Anonymous mode${NC}"
    [[ -f "$M4RKER" ]] && echo -e "${GREEN}[✓] Active${NC}" || echo -e "${RED}[-] Not active${NC}"

    echo ""
    echo -e "${BLUE}[~] Tor${NC}"
    systemctl is-active "$T0RSERVICE" &>/dev/null && echo -e "${GREEN}[✓] ${T0RSERVICE} is running${NC}" || echo -e "${RED}[-] ${T0RSERVICE} is not running${NC}"
    l1stens "$TR4NSPORT" && echo -e "${GREEN}[✓] Listening on ${TR4NSPORT}${NC}" || echo -e "${RED}[-] Nothing on ${TR4NSPORT}${NC}"
    l1stensudp "$DNSP0RT" && echo -e "${GREEN}[✓] Listening on ${DNSP0RT}${NC}" || echo -e "${RED}[-] Nothing on ${DNSP0RT}${NC}"
    l1stens "$CTRLP0RT" && echo -e "${GREEN}[✓] Control port ${CTRLP0RT} open${NC}" || echo -e "${RED}[-] No control port${NC}"

    echo ""
    echo -e "${BLUE}[~] Firewall${NC}"
    iptables -t nat -S OUTPUT 2>/dev/null | grep -q "$N4TCHAIN" && echo -e "${GREEN}[✓] TCP is redirected to Tor${NC}" || echo -e "${RED}[-] No redirect chain${NC}"
    iptables -S OUTPUT 2>/dev/null | grep -q "$FLTCH41N" && echo -e "${GREEN}[✓] Kill switch in place${NC}" || echo -e "${RED}[-] No kill switch${NC}"

    echo ""
    echo -e "${BLUE}[~] IPv6${NC}"
    v6st4t=$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6 2>/dev/null)
    [[ "$v6st4t" == "1" ]] && echo -e "${GREEN}[✓] IPv6 is disabled${NC}" || echo -e "${RED}[-] IPv6 is active${NC}"

    echo ""
    echo -e "${BLUE}[~] DNS${NC}"
    grep -q "127.0.0.1" /etc/resolv.conf 2>/dev/null && echo -e "${GREEN}[✓] DNS goes to the local Tor resolver${NC}" || echo -e "${RED}[-] DNS is not locked${NC}"

    echo ""
    echo -e "${BLUE}[~] Browser user${NC}"
    if tbb1nstalled; then
        echo -e "${GREEN}[✓] ${BR0WSER} has Tor Browser and is kept out of the redirect${NC}"
    elif id "$BR0WSER" &>/dev/null; then
        echo -e "${RED}[-] ${BR0WSER} exists but has no Tor Browser yet, so it still goes through the tunnel${NC}"
    else
        echo -e "${RED}[-] ${BR0WSER} does not exist yet${NC}"
    fi

    echo ""
    wh0am1
}

wh0am1() {
    echo -e "${BLUE}[~] Checking your IP address...${NC}"
    my1p=$(curl -s --max-time 25 https://check.torproject.org/api/ip 2>/dev/null)
    if [[ -n "$my1p" ]]; then
        echo -e "${GREEN}[✓] ${my1p}${NC}"
    else
        echo -e "${RED}[-] Could not reach the IP check service${NC}"
    fi
    echo ""
}

dns0leak() {
    echo -e "${BLUE}[~] Which resolver your machine asks${NC}"
    echo ""
    grep "nameserver" /etc/resolv.conf 2>/dev/null | sed "s/^/    /"
    echo ""
    echo -e "${BLUE}[~] Asking for a name and reading who answered${NC}"
    s3rver=$(dig +time=5 +tries=1 example.com 2>/dev/null | grep "SERVER:" | sed 's/.*SERVER: //')
    if [[ -z "$s3rver" ]]; then
        echo -e "${RED}[-] No answer at all. Is Tor running?${NC}"
        echo ""
        return
    fi
    echo -e "    ${s3rver}"
    echo ""
    if [[ "$s3rver" == *"127.0.0.1"* ]]; then
        echo -e "${GREEN}[✓] Your names are resolved by Tor on this machine${NC}"
    else
        echo -e "${RED}[-] Your names go somewhere else. Start Anonymous Mode first.${NC}"
    fi
    echo ""
}

r3st0re() {
    h0ld
    echo -e "${BLUE}[~] Putting everything back, whatever state it is in...${NC}"
    ch41ns_back
    dns0unlock
    v60n
    t1mez0ne_back
    if [[ -f "$B4CKUP/adopted" ]]; then
        rm -f "$B4CKUP/adopted"
    else
        t0rstrip
        s3rvice restart
    fi
    rm -f "$M4RKER"
    r3lease
    echo -e "${GREEN}[✓] Everything is back the way it was${NC}"
    echo ""
}

menu() {
    echo -e "${BLUE}[+] 1.   Start Anonymous Mode${NC}"
    echo -e "${BLUE}[+] 2.   Stop Anonymous Mode${NC}"
    echo -e "${BLUE}[+] 3.   Change IP Address${NC}"
    echo -e "${BLUE}[+] 4.   Auto IP Change${NC}"
    echo -e "${BLUE}[+] 5.   Start Tor Browser${NC}"
    echo -e "${BLUE}[+] 6.   Status${NC}"
    echo -e "${BLUE}[+] 7.   Check DNS Leak${NC}"
    echo -e "${BLUE}[+] 8.   Check IP Address${NC}"
    echo -e "${BLUE}[+] 9.   Test Kill Switch${NC}"
    echo -e "${BLUE}[+] 10.  Restore All${NC}"
    echo -e "${BLUE}[x] 0.   Exit${NC}"
    echo ""
}

r00tcheck
d3tect
n0ttested
mk_b4ckup
st4le
f0reign
d3ps
r3lease

while true; do
    banner
    menu
    read -rp "$(echo -e "${RED}[+]${NC} ${RED}Enter your choice:${NC} ")" ch01ce
    echo ""

    case $ch01ce in
        1) g0 ;;
        2) st0p ;;
        3) n3wip ;;
        4) aut0ip ;;
        5) br0wser ;;
        6) st4tus ;;
        7) dns0leak ;;
        8) wh0am1 ;;
        9) k1llswitch ;;
        10) r3st0re ;;
        0) b00m ;;
        *)
            clear
            banner
            echo -e "${RED}[-] Invalid option..!${NC}"
            ;;
    esac

    read -rp "$(echo -e "    ${BLUE}Press Enter to continue${NC}")"
done
