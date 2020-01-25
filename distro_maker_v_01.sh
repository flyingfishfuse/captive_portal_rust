#!/bin/bash/
# TODO: add option to choose from LIVE_DISK.ISO or debootstrap
## $PROG Debo0tstrap Chro0t Generat0r v1 
##    This program makes a complete APT based distro in a folder and moves it to a disk
##    Of your choosing OR it can make a network accessible sandbox for you to do whatever in.
##    DO NOT WALK AWAY FROM THIS PROGRAM OR YOU WILL REGRET IT! A menu pops up and you have to 
##    Decide what you want to do!
## CURRENTLY ONLY 64-BIT BOOTLOADER IS WORKING
## Usage: $PROG [OPTION...] [COMMAND]...
## Options:
##   -u, --user USER          The username to be created                        (Default: moop)
##   -p, --password PASS      The password to said username                     (Default: password)
##   -e, --extra LIST         Space seperated list of extra packages to install (Default: micro)
##   -m, --smacaddress MAC    MAC Address of the Sandbox                        (Default: de:ad:be:ef:ca:fe)
##   -i, --sipaddress IP      IP Address of the Sandbox                         (Default: 192.168.0.3)
##   -h, --sifacename IFACE   Interface name for the Sandbox                    (Default: hakc1)
##   -l, --sandbox_location   Full Path of the Sandbox                          (Default: /home/moop/Desktop/sandbox)
##   -a, --architecture ARCH  AMD64, X86, ARM, what-have-you                    (Default: amd64)
##   -c, --compenent COMPO    Which repository components are included          (Default: main,contrib,universe,multiverse)
##   -r, --repositorie REPO   The Debian-based repository. E.g. "Ubuntu"        (Default: http://archive.ubuntu.com/ubuntu/)
##   -d, --device DEVICE      The device to install the Distro to               (Default: NONE THATS DANGEROUS!)
##   -s, --sandbox_only       Only makes the SANDBOX                            (Default: NONE)
##   -f, --filesystem_only    Only makes the disk and filesystem structure      (Default: NONE)
## 
## Commands:
##   -h, --help             Displays this help and exists <-- no existential crisis here!
##   -v, --version          Displays output version and exits
## Examples:
##   $PROG -i myscrip-simple.sh > myscript-full.sh
##   $PROG -r myscrip-full.sh   > myscript-simple.sh
## Thanks:
## https://www.tldp.org/LDP/abs/html/colorizing.html
## That one person on stackexchange who answered everything in one post.
## The internet and search engines!
## 
# https://stackoverflow.com/questions/14786984/best-way-to-parse-command-line-args-in-bash
PROG=${0##*/}
LOGFILE="$0.logfile"
set -euo pipefail
IFS=$'\n\t'
#SANDBOX user configuration
user()
{
	USER='moop'
}
password()
{
	PASSWORD='password'
}
extra()
{
	#Watch'ya watch'ya watch'ya want, watch'ya WANT?!?
	EXTRA_PACKAGES='micro'
}
sifacename()
{
	#SANDBOX external network interface configuration
	SANDBOX_IFACE_NAME='hakc1'
}
smacaddress()
{
	SANDBOX_MAC_ADDRESS='de:ad:be:ef:ca:fe'
}
sipaddress()
{
	SANDBOX_IP_ADDRESS='192.168.1.3'
}
sandbox_location()
{
	SANDBOX='/home/moop/Desktop/SANDBOX'
}
architecture()
{
	ARCH='amd64'
}
component()
{
	COMPONENTS='main,contrib,universe,multiverse'
}
respositorie()
{
	REPOSITORY='http://archive.ubuntu.com/ubuntu/'
}
device()
{
    WANNABE_LIVE_DISK = ""
}
sandbox_only()
{
    ONLY_SANDBOX = 0
}
filesystem_only()
{
	ONLY_FILESYSTEM = 0
}
#greps all "##" at the start of a line and displays it in the help text
help() {
  grep "^##" "$0" | sed -e "s/^...//" -e "s/\$PROG/$PROG/g"; exit 0
}
#Runs the help function and only displays the first line
version() {
  help | head -1
}
# run the [ test command; if it succeeds, run the help command. $# is the number of arguments
[ $# = 0 ] && help

# While there are arguments to parse:
# WHILE number of arguments passed to script is greater than 0 
# for every argument passed to the script DO
while [ $# -gt 0 ]; do

# assign results of `grep | tr` to CMD
# searches through THIS file :
# grep -m 1, stop after first occurance
# -Po, perl regex Print only the matched (non-empty) parts of a matching line, with each such part on a separate output line.

# ^## *$1, MATCHES all the "##" until the END of the "-letter" shell expansion argument 
# "|" MATCHES one OR the other
#  --\K[^= ]* , MATCHES all the "--words" arguments
    # The \K "resets the line position". Basically it means that with -o it will print the result
    # from \K to the end that matched the regex. It's often used together grep -Po 'blabla\Kblabla'
    # For example `echo abcde | grep -P 'ab\K..'` will print "de"
    
# tr - _ substitutes all - for _
  CMD=$(grep -m 1 -Po "^## *$1, --\K[^= ]*|^##.* --\K${1#--}(?:[= ])" ${0} | tr - _)
  if [ -z "$CMD" ]; then echo "ERROR: Command '$1' not supported"; exit 1; fi
  shift; eval "$CMD" $@ || shift $? 2> /dev/null
done

######################################################################
#
#      if command_exists whatever${SUFX}
#      then
#        whateverSUFFIX=${SUFX}
#        break
#      fi
#    done
#
#
#
#
#

#=========================================================
#            Colorization stuff
#=========================================================
black     = '\E[30;47m'
red       = '\E[31;47m'
green     = '\E[32;47m'
yellow    = '\E[33;47m'
blue      = '\E[34;47m'
magenta   = '\E[35;47m'
cyan      = '\E[36;47m'
white     = '\E[37;47m'
info_blue = '\033[1;36m'
warn_yell = '\033[1;33m'
fatal_red = '\033[1;31m'


alias Reset="tput sgr0"      #  Reset text attributes to normal
                             #+ without clearing screen.
cecho (){
	# Argument $1 = message
	# Argument $2 = color
	local default_msg="No message passed."
    # Doesn't really need to be a local variable.
	# Message is first argument OR default
	message   = ${1:-$default_msg}
	# olor is second argument OR white
	color     = ${2:$white}
	# extra message field in case you want uncolored stuff after the colored stuff
	last_word = ${3:''}
	if [ $color = 'lolz' ]
	then
		echo $message | lolcat
		return
	else
		message=${1:-$default_msg}   # Defaults to default message.
		color=${2:-$black}           # Defaults to black, if not specified.
		echo -e "$color"
		echo "$message"
		Reset                      # Reset to normal.
		echo "$last_word"
		return
    fi
}  

info()  { cecho "[INFO]" info_blue " $*"; }
warn()  { cecho "[WARNING]" warn_yello "$*"; }
fatal() { cecho "[FATAL] " fatal_red " $*" ; exit 1 ; }

echo "======================================================================="
echo "=================" cecho "--Debo0tstrap Chro0t Generat0r--" blue; echo "======================"
echo "======================================================================="
echo "==="
# HOST network interface configuration that connects to SANDBOX
# In my test this is a Wireless-N Range extender with OpenWRT connected through a Ethernet to USB connector
HOST_IFACE_NAME='enx000ec6527123'
INT_IP='192.168.1.161'
# HOST network interface configuration that connects to Command and Control 
# This is the desktop workstation you aren't using this script on because its stupid to do that.
IF_CNC='eth0'
IF_IP_CNC='192.168.0.44'
# Internet access for the LAN, This is your internet router.
GATEWAY='192.168.0.1'
error_exit(){
	cecho "$1" red "" 1>&2 >> $LOGFILE
	exit 1
}

get_permission () {

  warn 'This script might do terrible things.'

  read -rp  "Are you sure you wish to continue (Y/n)? " 
  if [ "$(echo "${REPLY}" | tr "[:upper:]" "[:lower:]")" = "n" ] ; then
    fatal 'Installation aborted'
  fi
}
check_os () {

  info "Detecting OS..."

  OS=$(uname)
  readonly OS
  info "Operating System: $OS"
  if [ "${OS}" = "Linux" ] ; then
    info "You appear to be on the correct OS"
    
  elif [ "${OS}" = "FreeBSD" || "OpenBSD" || "Darwin"]; then
    fatal "Cannot work on :" "$OS"
  fi
}

deboot_first_stage(){
##### Sequential commands with error checking ##########################################################################
	cecho "[+] Beginning Debootstrap" yellow
	if sudo debootstrap --components $COMPONENTS --arch $ARCH bionic $SANDBOX $REPOSITORY >> $LOGFILE; then
	    cecho "[+] Debootstrap Finished Successfully!" green
	else
		error_exit "[-]Debootstrap Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi

##### resolv.conf copy #################################################################################################
	echo "[+] Copying Resolv.conf" yellow
	if sudo cp /etc/resolv.conf $SANDBOX/etc/resolv.conf; then
	    cecho "[+] Resolv.conf copied!" green 
	else
		error_exit "[-]Copy Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi

##### sources.list copy ################################################################################################
    cecho "[+] Copying Sources.list" yellow
	if sudo cp /etc/apt/sources.list $SANDBOX/etc/apt/; then
	    cecho "[+] Sources.list copied!" green 
	else
		error_exit "[-]Copy Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi

##### Mount and bind the proper volumes ##################################################################################
############### /dev ###############
	cecho "[+] Mounting /dev"  yellow
	if sudo mount -o bind /dev $SANDBOX/dev; then
	    cecho "[+] Mounted!" green 
	else
		error_exit "[-]Mount Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi
############### /proc ###############
    cecho "[+] Mounting /proc" yellow
	if sudo mount -o bind -t proc /proc $SANDBOX/proc; then
	    cecho "[+] Mounted!" green 
	else
		error_exit "[-]Mount Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi
############# /sys ###############
    cecho "[+] Mounting /dev" yellow
	if sudo mount -o bind -t sys /sys $SANDBOX/sys; then
	    cecho "[+] Mounted!" green 
	else
		error_exit "[-]Mount Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi
}
############################### Finish setting up the basic system #########################################################
deboot_second_stage(){
	sudo chroot $SANDBOX
	useradd $USER 
	passwd  $USER
	login $USER
	sudo -S apt-get update
	sudo -S apt-get --no-install-recommends install wget debconf nano curl
	sudo -S apt-get update  #clean the gpg error message
	sudo -S apt-get install locales dialog  #If you don't talk en_US
	#sudo -S locale-gen en_US.UTF-8  # or your preferred locale
	#tzselect; TZ='Continent/Country'; export TZ  #Configure and use our local time instead of UTC; save in .profile
}

# begin setting up services
# TOFU: make a list of conf files needing to be changed 
# and have them ready to be opened one by one
# OR have them applied from a formatted file
deboot_third_stage()
{
	sudo -S apt install $EXTRA_PACKAGES

}

#takes an argument
check_for_space(){
    reqSpace=100000000
    availSpace=$(df "${1}" | awk 'NR==2 { print $4 }')
    if (( availSpace < reqSpace )); then
        echo "not enough Space" >&2
        exit 1
    fi
}
####################################################################################################################
# TOFOMOFO: check for disk space and throw a warning if needed                                                     #
partition_disk() {                                                                                                 #
# This creates the basic disk structure of an EFI disk with a single OS.                                           #
# You CAN boot .ISO Files from the persistance partition if you mount in GRUB2                                     #
#                                                                                                                  #
##### EFI ##########################################################################################################
    info "Creating EFI partition"
    if parted /dev/$WANNABE_LIVE_DISK --script mkpart EFI fat16 1MiB 100MiB; then
        cecho "[+] EFI Partition Created!" green
    else
		error_exit "[-]Partitioning EFI Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi

##### LIVE disk partition ##########################################################################################
    info " Creating EFI partition"
    if parted /dev/$WANNABE_LIVE_DISK --script mkpart live fat16 100MiB 3GiB; then
        cecho "[+] Live Disk Partition Created!" green
    else
		error_exit "[-]Partitioning Live Disk Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi

##### Persistance Partition ########################################################################################
    info " Creating EFI partition"
    if parted /dev/$WANNABE_LIVE_DISK --script mkpart persistence ext4 3GiB 100% ; then
        cecho "[+] Persistance Partition Created!" green
    else
		error_exit "[-]Partitioning Persistance Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi

##### Sets filesystem flag #########################################################################################
    info " Setting MSFTata Flag On EFI partition"
    if parted /dev/$WANNABE_LIVE_DISK --script set 1 msftdata on; then
        cecho "[+] MSFTdata Flag Set on EFI Partition!" green
    else
		error_exit "[-] MSFTdata Flag Setting On EFI Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi

##### Sets boot flag for legacy (NON-EFI) BIOS ######################################################################
    info " Setting Legacy Boot Flag On Live Disk"
    if parted /dev/$WANNABE_LIVE_DISK --script set 2 legacy_boot on; then
        cecho "[+] Legacy Boot Flag Set on Live Disk Partition!" green
    else
		error_exit "[-]NON-EFI Boot Sector Flag Setting On Live Disk Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi
 
 ##### Sets msftdata flag ############################################################################################
    info " Setting MSFTata Flag On Live Disk"
    if parted /dev/$WANNABE_LIVE_DISK --script set 2 msftdata on; then
        cecho "[+] MSFTdata Flag Set on Live Disk Partition!" green
    else
		error_exit "[-]MSFTdata Flag Setting On Live Disk Failed! Check the logfile!" 1>&2 >> $LOGFILE
	fi
}

mount_iso_on_temp() { 
    
    info "Mounting Live ISO on /tmp/live-iso"
    if mount -oro live.iso /tmp/live-iso; then
        cecho "[+] ISO Successfully Mounted On /tmp/live-iso!"
    else {
        error_exit "[-] Could Not Mount ISO! Check the logfile!" 1>&2 >> $LOGFILE
    }
    fi
}

format_disk(){
# Here we make the filesystems for the OS to live on
    
    ## EFI
    info " Creating Fat32 Filesystem For EFI on /dev/{$WANNABE_LIVE_DISK}1"
    if test -f /dev/{$WANNABE_LIVE_DISK}1; then
        if mkfs.vfat -n EFI /dev/{$WANNABE_LIVE_DISK}1; then
            cecho "[+] Created Fat32 Filesystem on EFI Partion " green
        else 
            error_exit "[-] Failed! Check the logfile!" 1>&2 >> $LOGFILE
        fi
    fi
    ## LIVE disk partition
    info " Creating Fat32 Filesystem on Live Disk Partition"
    if test -f /dev/{$WANNABE_LIVE_DISK}; then
        if mkfs.vfat -n LIVE /dev/{$WANNABE_LIVE_DISK}2; then
            cecho "[+] Created Fat32 Filesystem on Live Disk Partion " green
        else 
            error_exit "[-] Creation of Fat32 Filesystem on Live Disk Partition Failed! Check the logfile!" 1>&2 >> $LOGFILE
        fi
    fi

    ## Persistance Partition
    if test -f /dev/${$WANNABE_LIVE_DISK}; then
        info "Creating Filesystem On Persistance Partition"
        if mkfs.ext4 -F -L persistence /dev/{$WANNABE_LIVE_DISK}3; then
            cecho "[+] Created Ext4 Filesystem on Persistance Partion " green
        else 
            error_exit "[-] Creation of Ext4 Filesystem on Persistance Partition Failed! Check the logfile!" 1>&2 >> $LOGFILE
        fi
    fi
    
    # Creating Temporary work directories
    info "[+] Creating Temporary Work Directories"
    
    if mkdir /tmp/usb-efi /tmp/usb-live /tmp/usb-persistence /tmp/live-iso; then
        cecho "[+] Created Folders In /tmp" green
    else {
        error_exit "[-] Could Not Create Folders in /tmp ! Check the logfile!" 1>&2 >> $LOGFILE
    }
    fi
    
    # Mounting those directories on the newly created filesystem
    info "Mounting /tmp/usb-efi/ On dev/${WANNABE_LIVE_DISK}1"
    
    if mount /dev/${WANNABE_LIVE_DISK}1 /tmp/usb-efi; then
        cecho "[+] Mounted Sucessfully!" green
    else {
        error_exit "[-] Could Not Mount Folder On Partition! Check the logfile!" 1>&2 >> $LOGFILE
    }    
    fi
    
    #mount Live Partition
    info "Mounting /tmp/usb-live/ On dev/${WANNABE_LIVE_DISK}2"
    
    if mount /dev/${WANNABE_LIVE_DISK}2 /tmp/usb-live; then
        cecho "[+] Mounted Sucessfully!" green
    else {
        error_exit "[-] Could Not Mount Folder On Partition! Check the logfile!" 1>&2 >> $LOGFILE
    }
    fi

    info "Mounting /tmp/usb-persistence/ On dev/${WANNABE_LIVE_DISK}3"
    
    if mount /dev/${WANNABE_LIVE_DISK}3 /tmp/usb-persistence; then
        cecho "[+] Mounted Sucessfully!" green
    else {
        error_exit "[-] Could Not Mount Folder On Partition! Check the logfile!" 1>&2 >> $LOGFILE
    }
    # Mount the ISO on a temp folder to get the files moved
    
    fi

    #Mounts the ISO file if an ISO is used
    mount_iso_on_temp;

    if cp -ar /tmp/live-iso/* /tmp/usb-live; then
        cecho "[+] "
    else {

    }
    fi
    # IMPORTANT! This establishes persistance! UNION is a special mounting option 
    # https://unix.stackexchange.com/questions/282393/union-mount-on-linux
    info "Establishing Persistence!"
    if echo "/ union" > /tmp/usb-persistence/persistence.conf; then
        cecho "[+] Union Mount Of Persistence Partition On Root Filesystem Should Work Now!"
    else {
        error_exit "[-] Could Not Establish Persistence! Check the logfile!" 1>&2 >> $LOGFILE
    }

    # Install GRUB2
    # https://en.wikipedia.org/wiki/GNU_GRUB
    ## Script supported targets: arm64-efi, x86_64-efi, , i386-efi
    # TODO : Install 32bit brub2 then 64bit brub2 then `update-grub`
    #        So's we can install 32 bit OS to live disk.
    #########################
    ##      64-BIT OS       #
    #########################
    if [$BIT_SIZE = "32"]    
        if [$ARCH == "ARM"]
            cecho "[+] Installing GRUB2 for ${ARCH} to /dev/${WANNABE_LIVE_DISK}" yellow
            if grub-install --removable --target=arm-efi --boot-directory=/tmp/usb-live/boot/ --efi-directory=/tmp/usb-efi /dev/$WANNABE_LIVE_DISK ; then
                cecho "[+] GRUB2 Install Finished Successfully!" green
	        else
		        error_exit "[-]GRUB2 Install Failed! Check the logfile!" 1>&2 >> $LOGFILE
	        fi   
        else if [$ARCH == "X86"]
            cecho "[+] Installing GRUB2 for ${ARCH} to /dev/${WANNABE_LIVE_DISK}" yellow
            if grub-install --removable --target=i386-efi --boot-directory=/tmp/usb-live/boot/ --efi-directory=/tmp/usb-efi /dev/$WANNABE_LIVE_DISK; then
                cecho "[+] GRUB2 Install Finished Successfully!" green
	        else
		        error_exit "[-]GRUB2 Install Failed! Check the logfile!" 1>&2 >> $LOGFILE
	        fi
        else if [$ARCH == "X64"]
            cecho "[+] Installing GRUB2 for ${ARCH} to /dev/${WANNABE_LIVE_DISK}" yellow
            if grub-install --removable --target=X86_64-efi --boot-directory=/tmp/usb-live/boot/ --efi-directory=/tmp/usb-efi /dev/$WANNABE_LIVE_DISK ; then
	            cecho "[+] GRUB2 Install Finished Successfully!" green
	        else
		        error_exit "[-]GRUB2 Install Failed! Check the logfile!" 1>&2 >> $LOGFILE
	        fi
        else
            cecho "Something WIERD happened, Throw a banana and try again!"
    
    # Copy the MBR for syslinux booting of LIVE disk
    dd bs=440 count=1 conv=notrunc if=/usr/lib/syslinux/mbr/gptmbr.bin of=/dev/sdX
    
    # Install Syslinux
    # https://wiki.syslinux.org/wiki/index.php?title=HowTos
    syslinux --install /dev/${WANNABE_LIVE_DISK}2
    mv /tmp/usb-live/isolinux /tmp/usb-live/syslinux
    mv /tmp/usb-live/syslinux/isolinux.bin /tmp/usb-live/syslinux/syslinux.bin
    mv /tmp/usb-live/syslinux/isolinux.cfg /tmp/usb-live/syslinux/syslinux.cfg

    # Magic, sets up syslinux configuration and layouts 
    sed --in-place 's#isolinux/splash#syslinux/splash#' /tmp/usb-live/boot/grub/grub.cfg
    sed --in-place '0,/boot=live/{s/\(boot=live .*\)$/\1 persistence/}' /tmp/usb-live/boot/grub/grub.cfg /tmp/usb-live/syslinux/menu.cfg
    sed --in-place '0,/boot=live/{s/\(boot=live .*\)$/\1 keyboard-layouts=en locales=en_US/}' /tmp/usb-live/boot/grub/grub.cfg /tmp/usb-live/syslinux/menu.cfg
    sed --in-place 's#isolinux/splash#syslinux/splash#' /tmp/usb-live/boot/grub/grub.cfg
    
    # Clean up!
    umount /tmp/usb-efi /tmp/usb-live /tmp/usb-persistence /tmp/live-iso
    rmdir /tmp/usb-efi /tmp/usb-live /tmp/usb-persistence /tmp/live-iso
}

# finish this you doo doo head
verify_live_iso(){
    echo "something clever"
}

#Makes an interface with iproute1
create_iface_ipr1(){
	sudo -S modprobe dummy
	sudo -S ip link set name $SANDBOX_IFACE_NAME dev dummy0
	sudo -S ifconfig $SANDBOX_IFACE_NAME hw ether $SANDBOX_MAC_ADDRESS
}
#Makes an interface with iproute2
create_iface_ipr2(){
	ip link add $SANDBOX_IFACE_NAME type veth
}
del_iface1(){
	sudo -S ip addr del $SANDBOX_IP_ADDRESS/24 brd + dev $SANDBOX_IFACE_NAME
	sudo -S ip link delete $SANDBOX_IFACE_NAME type dummy
	sudo -S rmmod dummy
}
#Delets the SANDBOX Interface
del_iface2(){
	ip link del $SANDBOX_IFACE_NAME
}
#run this from the HOST
setup_host_networking(){
	#Allow forwarding on HOST IFACE
	sysctl -w net.ipv4.conf.$HOST_IF_NAME.forwarding=1
	#Allow from sandbox to outside
	iptables -A FORWARD -i $SANDBOX_IFACE_NAME -o $HOST_IFACE_NAME -j ACCEPT
	#Allow from outside to sandbox
	iptables -A FORWARD -i $HOST_IFACE_NAME -o $SANDBOX_IFACE_NAME -j ACCEPT
}
#this is a seperate "computer", The following is in case you want to setup another
#virtual computer inside this one and allow to the outside
#sandbox_forwarding(){
	#Allow forwarding on Sandbox IFACE
	#sysctl -w net.ipv4.conf.$SANDBOX_IFACE_NAME.forwarding=1
	#Allow forwarding on Host IFACE
	#Allow from sandbox to outside
	#iptables -A FORWARD -i $SANDBOX_IFACE_NAME -o $HOST_IFACE_NAME -j ACCEPT
	#Allow from outside to sandbox
	#iptables -A FORWARD -i $HOST_IFACE_NAME -o $SANDBOX_IFACE_NAME -j ACCEPT
#}
#run this from the Host
establish_network(){
	# 1. Delete all existing rules
	iptables -F
	# 2. Set default chain policies
	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT DROP
	# 4. Allow ALL incoming SSH
	iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
	iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
	# Allow incoming HTTPS
	iptables -A INPUT -i eth0 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT;
	iptables -A OUTPUT -o eth0 -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT;
	# 19. Allow MySQL connection only from a specific network
	#iptables -A INPUT -i eth0 -p tcp -s 192.168.200.0/24 --dport 3306 -m state --state NEW,ESTABLISHED -j ACCEPT
	#iptables -A OUTPUT -o eth0 -p tcp --sport 3306 -m state --state ESTABLISHED -j ACCEPT
	# 23. Prevent DoS attack;
	iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
}
############################
##--	Menu System		--##
############################

PS3="Choose your doom"
select option in sandbox_connect setup_network create_disk quit
do
	case $option in
    	sandbox_connect) 
			connect_sandbox
        setup_network) 
            establish_network
        create_disk)
            setup_disk
        quit)
        	break;;
    esac
done

exit
