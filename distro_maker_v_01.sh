#!/bin/bash
# TODO: add option to choose from LIVE_DISK.ISO or debootstrap
## $PROG such_a_creative_name_for_something_v1 
##    This program makes a complete APT based distro in a folder and moves it to a disk
##    Of your choosing OR it can make a network accessible sandbox for you to do whatever in.
##    
##    DO NOT WALK AWAY FROM THIS PROGRAM! A menu pops up and you have to 
##    Decide what you want to do!
##
##    DO NOT FEED BAD DATA TO THE OPTIONS! This script isn't going to save you from your stupidity.
##
## CURRENTLY ONLY 64-BIT BOOTLOADER IS WORKING
##
## Usage: $PROG [OPTION...] [COMMAND]...
## Options:
##   -u, --new_user USER      The username to be created                        (Default: moop)
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
##   -t, --iso_path PATH      Path to the iso if you are supplying one          (Default: ./live.iso)
##   -b, --mount_path PATH    Path to MOUNT Live ISO                            (Default: /tmp/live_iso/)
##   -g, --live_path PATH     Path To Create For Building an ISO                (Default: /tmp/live_build_iso/)                
##   -j, --undecided          UNDECIDED                                         (Default: WATIZDIS?)
##    
##       Boolean Options : "y" for YES, "n" for NO
##   -s, --sandbox_only       Only makes the SANDBOX                            (Default: n)
##   -f, --filesystem_only    Only makes the disk and filesystem structure      (Default: n)
##   -x, --use_an_iso         Use an ISO for Live Disk                          (Default: n)
##   -y, --create_iso         Create an ISO from the sandbox                    (Default: n)
## 
## Commands:
##   -h, --help             Displays this help and exists <-- no existential crisis here!
##   -v, --version          Displays output version and exits
## Examples:
##   Make everything and install it to a disk
##   $PROG --user moop --password password --extra micro syslinux terminator fluxbox --device /dev/sdd
##
##   Make just a sandbox in ~/sandbox and generate an ISO for transport
##   $PROG --user moop --password password --extra micro syslinux terminator fluxbox --sandbox_only --create_iso --iso_path NEW_SANDBOX.iso
##
##   Make just a sandbox from an ISO
##   $PROG --user moop --password password --extra micro syslinux terminator fluxbox --use_an_iso --iso_path LIVE_DISK.iso --sandbox_only
##
##   $PROG --user moop --password password --extra micro syslinux terminator fluxbox --create_iso --iso_path NEW_SANDBOX.iso --sandbox_only
##   $PROG --user moop --password password --extra micro syslinux terminator fluxbox 
## 
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
new_user()
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
# its mispelled for a reason, that grep at the bottom for the option parser needs work, please help
# the more code you show me the more I can learn.
respositorie()
{
	REPOSITORY='http://archive.ubuntu.com/ubuntu/'
}
device()
{
    WANNABE_LIVE_DISK=""
}
iso_path(){
    ISO_LOCATION="live.iso"
}
mount_path(){
    TEMP_LIVE_ISO_PATH="/tmp/live_iso/"
}
live_path(){
    TEMP_LIVE_ISO_BUILD_PATH="/tmp/live_build_iso/"
}
undecided(){
    WAT="WATIZDIS"
}
sandbox_only()
{
    ONLY_SANDBOX='y'
}
filesystem_only()
{
	FILESYSTEM='n'
}
create_iso() {
    MAKE_ISO_opt='n'
}
use_an_iso(){
    USE_ISO='n'
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
# if the number of arguments fed to the program is 0, show the help
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
# turns all options to the variable $CMD and sequentially checks then executes
# if the $CMD doesnt exist, echo command not supported and exit
# this is why repositorie is mispelled and i am a wierdo so i choose for the options that the user reads 
# to be the mispelling
  CMD=$(grep -m 1 -Po "^## *$1, --\K[^= ]*|^##.* --\K${1#--}(?:[= ])" "${0}" | tr - _)
  if [ -z "$CMD" ]; then echo "ERROR: Command '$1' not supported"; exit 1; fi
  shift; eval "$CMD" "$@" || shift $? 2> /dev/null
done
#################################################################################
#
#       VARIABLES YOU NEED TO CHANGE!!!
#
# HOST network interface configuration that connects to SANDBOX
# In my test this is a Wireless-N Range extender with OpenWRT connected through a Ethernet to USB connector
HOST_IFACE_NAME='enx000ec6527123'
#INT_IP='192.168.1.161'
# HOST network interface configuration that connects to Command and Control 
# This is the desktop workstation you aren't using this script on because its stupid to do that.
#IF_CNC='eth0'
#IF_IP_CNC='192.168.0.44'
# Internet access for the LAN, This is your internet router.
#GATEWAY='192.168.0.1'
SANDBOX_HOSTNAME="IDontReadBeforeExecuting"
# make it a little less than 16 Gb so we can use shitty USB sticks en masse
reqSpace=16000000 
declare -a HOST_REQUIRED_PACKAGES=("syslinux" "squashfs-tools" "genisoimage")
declare -a SANDBOX_REQUIRED_PACKAGES=("ubuntu-standard" "lupin-casper" "linux-generic" "laptop-detect" "os-prober")
# Necessary Folders for CREATING Live ISO
declare -a LIVE_ISO_FOLDERS=("casper" "isolinux" "install")

#############################################################################
#     Lets do some preliminary checks and get some info
#############################################################################


#########################################################3
##
##                   FUNCTIONS
##                    GO HERE
##
###########################################################
#=========================================================
#            Colorization stuff
#=========================================================
black='\E[30;47m'
red='\E[31;47m'
green='\E[32;47m'
yellow='\E[33;47m'
blue='\E[34;47m'
magenta='\E[35;47m'
cyan='\E[36;47m'
white='\E[37;47m'
info_blue ='\033[1;36m'
warn_yell ='\033[1;33m'
fatal_red ='\033[1;31m'
alias Reset="tput sgr0"      #  Reset text attributes to normal
                             #+ without clearing screen.
cecho (){
	# Argument $1 = message
	# Argument $2 = color
	local default_msg="No message passed."
    # Doesn't really need to be a local variable.
	# Message is first argument OR default
	message=${1:-$default_msg}
	# olor is second argument OR white
	color=${2:$white}
	# extra message field in case you want uncolored stuff after the colored stuff
	last_word=${3:''}
	if [ $color='lolz' ]
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
info() { cecho "[INFO]" info_blue " $*"; }
warn() { cecho "[WARNING]" warn_yello "$*"; }
fatal() { cecho "[FATAL] " fatal_red " $*" ; exit 1 ; }
error_exit(){
	cecho "$1" red "" 1>&2 >> $LOGFILE
	exit 1
}
get_permission () {
  warn 'This script might do terrible things.'
  read -rp  "Are you sure you wish to continue (Y/n)? " 
  if [ "$(echo "${REPLY}" | tr "[:upper:]" "[:lower:]")" = "n" ] ; then
    fatal 'Exiting Program'
  fi
}
check_os () {
  info "Detecting OS..."
  OS=$(uname)
  readonly OS
  info "Operating System: $OS"
  if [ "${OS}" = "Linux" ] ; then
    info "You appear to be on the correct OS"
  else [ "${OS}" = "FreeBSD" || "OpenBSD" || "Darwin" ]
    fatal "Cannot work on :" "$OS"
  fi
  return 1
}
#takes an argument
check_for_space(){
    availSpace=$(df "${1}" | awk 'NR==2 { print $4 }')
    if (( availSpace < reqSpace )); then
        echo "not enough Space" >&2
        exit 1
    fi
}
# you better follow directions better or you are going to fuck your shit up
yn(){
    if ${1} | tr [:upper:] [:lower:] == "n" ; then
        echo 'n'
    elif ${1} | tr [:upper:] [:lower:] == "y" ; then
        echo "y"
    else
        error_exit "Something Strange happened with a yes no option! Check the Logfile!!"
    fi
}
# make sure they put "y" or "n"
analyze_yes_no_opts(){
###### ISO USE #####################################################        
    #Mounts the ISO file if an ISO is used
    if $(yn) $USE_ISO == 'n' ; then
        info "Not Using An ISO"
    elif $(yn) $USE_ISO == 'y' ; then
        cecho " Mounting ISO file in /tmp" green ""
        mount_iso_on_temp;
    else 
        error_exit " That wasn't a 'y' or 'n' in those boolean options for Using an ISO"
    fi
###### ISO CREATION ################################################
    if $(yn) $MAKE_ISO_opt == "n" ; then
        MAKE_ISO=0
        echo "not working yet"
    elif $(yn) $MAKE_ISO_opt == "y" ; then
        MAKE_ISO=1
        echo "not working yet"
    else
        error_exit " That wasn't a 'y' or 'n' in those boolean options for Creating an ISO"
    fi
 ###### SANDBOX ONLY ###################################################   
    if $(yn) $ONLY_SANDBOX == "n" ; then
        O_SANDBOX=0    
    elif $(yn) $ONLY_SANDBOX == "y" ; then
        O_SANDBOX=1
    else 
        error_exit " That wasn't a 'y' or 'n' in those boolean options for Sandbox"
    fi
###### FILESYSTEM ONLY ################################################
    if $(yn) $FILESYSTEM == "n" ]; then
        ONLY_FILESYSTEM=0
    elif $(yn) $FILESYSTEM == "n" ]; then
        ONLY_FILESYSTEM=1
    else 
        error_exit " That wasn't a 'y' or 'n' in those boolean options for Filesystem"
    fi
}
check_host_install_requirements(){
    ## loop through the array of package names
    for i in "${HOST_REQUIRED_PACKAGES[@]}"
    do
    # You can access them using echo "${arr[0]}", "${arr[1]}" also
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $i | grep "install ok installed")
        if [ "" == "$PKG_OK" ]; then
            warn "Package : $i Is NOT Installed, But Required. \n Install? (y/n) (You kinda need it for this whole process)"
            DECISION = read
            if $(yn) $DECISION == 'y'; then
                sudo apt install $i       
            else 
                fatal "You obviously don't want to run this script any further!"
            fi
        fi
    done
}
check_sandbox_install_requirements(){
    ## loop through the array of package names
    for i in "${SANDBOX_REQUIRED_PACKAGES[@]}"
    do
    # You can access them using echo "${arr[0]}", "${arr[1]}" also
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $i | grep "install ok installed")
        if [ "" == "$PKG_OK" ]; then
            warn "Package : $i Is NOT Installed, But Required. \n Install? (y/n) (You kinda need it for this whole process)"
            DECISION = read
            if $(yn) $DECISION == 'y'; then
                sudo apt install $i       
            else 
                fatal "You obviously don't want to run this script any further!"
            fi
        fi
    done
}
# TODO: ADD CLEANUP SCRIPT!
mount_iso_on_temp() {    
    info "Mounting Live ISO on $TEMP_LIVE_ISO_PATH"
    if [ -d $TEMP_LIVE_ISO_PATH ]; then
        mkdir $TEMP_LIVE_ISO_PATH
        if mount -oro $ISO_LOCATION $TEMP_LIVE_ISO_PATH; then
            cecho "[+] ISO Successfully Mounted On $TEMP_LIVE_ISO_PATH!" green ""
        else
            error_exit "[-] Could Not Mount ISO! Check the logfile!"
        fi
    fi
}
# This function will exit and allow the user to fix things manually
make_iso_folders(){
    info "Attempting to Create Necessary Folder Structure For Live ISO"
# Check if folders already exist, The user may have run this script and
# Encountered an Error and had to fix it.
    for folder in "${LIVE_ISO_FOLDERS[@]}"
# Folder was already created
        if [ -d "$TEMP_LIVE_ISO_BUILD_PATH/$folder" ]; then
            cecho "[+] $TEMP_LIVE_ISO_BUILD_PATH/$folder ALREADY EXISTS!" green ""
# Folder was not created and must be manifested from the ether
        else
            if mkdir $TEMP_LIVE_ISO_BUILD_PATH/$folder; then
                cecho "[+] Created $TEMP_LIVE_ISO_BUILD_PATH/$folder!" green ""
# Something strange happened and we cannot continue with ISO creation
# without those necessary folders so we EXIT and let the user deal with
# the problem
            else
                warn "Could NOT Create Folder $folder! Please Check the Logfile and Fix the problem. \n Then run this script again"
                break    
            fi
        fi
    done
}

makeiso_from_debootstrap() {
    info "Beginning ISO Creation..."
# Check packages
    if check_host_install_requirements; then
        cecho "[+] All Required Packages for the Host Have Been Instlled!" green ""
    else
        error_exit "Something Strange Happened with Package Install, Check The LogFile!!"
    fi
    if make_iso_folders; then 
        cecho "[+] All Necessary Folders Have Been Created!"
    else   
        error_exit "[-] Could Not Create Necessary Folder Structure, Check The LogFile!!"
    fi                            
    # You will need a kernel and an initrd that was built with the Casper scripts. 
    # Grab them from your chroot. Use the current version. Note that before 9.10, 
    # the initrd was in gz NOT lz format...
    # COPY from SANDBOX to TEMP ISO FOLDERS
    if rsync --info=progress2 $SANDBOX/boot/vmlinuz-2.6.**-**-generic $TEMP_LIVE_ISO_BUILD_PATH/casper/vmlinuz; then
        cecho "[+] Success!" green ""    
    else
        warn "Could Not Copy the KERNEL, This Is A Problem"
    fi
    if rsync --info=progress2 $SANDBOX/boot/initrd.img-2.6.**-**-generic $TEMP_LIVE_ISO_BUILD_PATH/casper/initrd.lz; then
        cecho "[+] Success!" green ""    
    else
        warn "Could Not Copy the INITRD, This Is A Problem"
    fi
    if rsync --info=progress2 /usr/lib/ISOLINUX/isolinux.bin image/isolinux/; then
        cecho "[+] Success!" green ""    
    else
        warn "Could Not Copy the BootLoader, This Is A Problem"
    fi
    if rsync --info=progress2 /usr/lib/syslinux/modules/bios/ldlinux.c32 image/isolinux/ ; then
    # for syslinux 5.00 and newer
        cecho "[+] Success!" green ""
    else
        warn "Could Not Copy ldlinux.c32, This Is A Problem"
    fi
    if rsync --info=progress2 /boot/memtest86+.bin image/install/memtest
        cecho "[+] Success!" green ""
    else
        warn "Could Not Copy Memtest86+, This Is Maybe A Problem"
    fi

make_boot_splash(){
#To give some boot-time instructions to the user create an isolinux.txt file 
# in image/isolinux, for example:
#  splash.rle
#************************************************************************
# This is an /*Ubuntu*/ WHATEVER THE FUCK YOU WANT Remix Live CD.
#
# For the default live system, enter "live".  To run memtest86+, enter "memtest"
# Hot damn thank you kostya!
# https://www.linuxquestions.org/questions/linux-software-2/how-to-get-grub-to-launch-isolinux-syslinux-boot-menu-796787/#post4251314
#************************************************************************

# Splash Screen
# A graphic can be displayed at boot time
# The example text above requires a special character along with the file name 
# of the splash image (splash.rle) 
    printf "\x18" >emptyfile
# and then edit the file Add the file name just next to the first 
# character and add the text you want to display at boot time beneath it and save the 
# file as "isolinux.txt" To create the splash.rle file, create an image 480 pixels wide. 
# Convert it to 15 colours, indexed (perhaps using GIMP) and "Save As" to change the ending 
# to .bmp which converts the image to a bitmap format. Then install the "netpbm" package and run
    bmptoppm splash.bmp > splash.ppm
    ppmtolss16 '#ffffff=7' < splash.ppm > splash.rle
#Boot-loader Configuration
#Create an isolinux.cfg file in image/isolinux/ to provide configuration 
# settings for the boot-loader. Please read syslinux.doc which should be on the host 
# machine in /usr/share/doc/syslinux to find out about the configuration options available 
# on the current set-up. Here is an example of what could be in the file:

echo "DEFAULT live" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "LABEL live" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "  menu label ^Start or install Ubuntu Remix" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "  kernel /casper/vmlinuz" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "  append  file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd.lz quiet splash --" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "LABEL check" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "  menu label ^Check CD for defects" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "  kernel /casper/vmlinuz" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "  append  boot=casper integrity-check initrd=/casper/initrd.lz quiet splash --" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "LABEL memtest" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "  menu label ^Memory test" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "  kernel /install/memtest" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "  append -" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg 
echo "LABEL hd" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg 
echo "  menu label ^Boot from first hard disk" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg 
echo "  localboot 0x80" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg 
echo "  append -" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "DISPLAY isolinux.txt" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "TIMEOUT 300" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg
echo "PROMPT 1" >> $TEMP_LIVE_ISO_BUILD_PATH/isolinux/isolinux.cfg

#prompt flag_val
#
# If flag_val is 0, display the "boot:" prompt
# only if the Shift or Alt key is pressed,
# or Caps Lock or Scroll lock is set (this is the default).
# If  flag_val is 1, always display the "boot:" prompt.
#  http://linux.die.net/man/1/syslinux   syslinux manpage
# Don't forget to pick the correct extension for your initrd (initrd.gz or initrd.lz).
# Now the CD should be able to boot, at least it will be after the image is burned Wink ;)
# Create manifest:

    sudo chroot chroot dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee image/casper/filesystem.manifest
    sudo cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
    REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
    for i in $REMOVE
    do
        sudo sed -i "/${i}/d" image/casper/filesystem.manifest-desktop
    done

# Compress the chroot
# If this Customised Remix is to potentially be installed on some systems then the /boot 
# folder will be needed. To allow the Customised Cd to be an installer Cd, compress the entire 
# chroot folder with this command:
    sudo mksquashfs chroot image/casper/filesystem.squashfs
# Then write the filesystem.size file, which is needed by the installer:
    printf $(sudo du -sx --block-size=1 chroot | cut -f1) > image/casper/filesystem.size
# However, if it is not going to be installed and is 'only' meant as a LiveCD then the /boot 
# folder can be excluded to save space on your iso image. The live system boots from outside the 
# chroot and so the /boot folder is not used.
    sudo mksquashfs chroot image/casper/filesystem.squashfs -e boot
    nano image/README.diskdefines
# Disk Defines example:

#define DISKNAME  Ubuntu Remix
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  i386
#define ARCHi386  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1
}
extract_iso_to_disk() {
    error_exit "operation not supported yet"

}
make_disk_bootable() {
    error_exit "operation not supported yet"
}

deboot_first_stage(){
##### Sequential commands with error checking ##########################################################################
	cecho "[+] Beginning Debootstrap" yellow
	if sudo debootstrap --components $COMPONENTS --arch $ARCH bionic $SANDBOX $REPOSITORY; then
	    cecho "[+] Debootstrap Finished Successfully!" green
	else
		error_exit "[-]Debootstrap Failed! Check the logfile!" 
	fi
##### resolv.conf copy #################################################################################################
	echo "[+] Copying Resolv.conf" yellow
	if sudo cp /etc/resolv.conf $SANDBOX/etc/resolv.conf; then
	    cecho "[+] Resolv.conf copied!" green 
	else
		error_exit "[-]Copy Failed! Check the logfile!" 
	fi
##### sources.list copy ################################################################################################
    cecho "[+] Copying Sources.list" yellow
	if sudo cp /etc/apt/sources.list $SANDBOX/etc/apt/; then
	    cecho "[+] Sources.list copied!" green 
	else
		error_exit "[-]Copy Failed! Check the logfile!"
	fi
##### Mount and bind the proper volumes ##################################################################################
############### /dev ###############
	cecho "[+] Mounting /dev"  yellow
	if sudo mount -o bind /dev $SANDBOX/dev; then
	    cecho "[+] Mounted!" green 
	else
		error_exit "[-]Mount Failed! Check the logfile!"
	fi
############### /proc ###############
    cecho "[+] Mounting /proc" yellow
	if sudo mount -o bind -t proc /proc $SANDBOX/proc; then
	    cecho "[+] Mounted!" green 
	else
		error_exit "[-]Mount Failed! Check the logfile!"
	fi
############# /sys ###############
    cecho "[+] Mounting /dev" yellow
	if sudo mount -o bind -t sys /sys $SANDBOX/sys; then
	    cecho "[+] Mounted!" green 
	else
		error_exit "[-]Mount Failed! Check the logfile!"
	fi
}
############################### Finish setting up the basic system #########################################################
deboot_second_stage(){
	sudo -S chroot $SANDBOX
    mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C
apt-get install -y systemd-sysv
    cecho "Please set the ROOT PASSWORD" blue ""
    wait 3
    passwd root
    info "[+] Adding USER $USER"
    wait 2
	if useradd $USER ; then
        cecho "[+] User $USER Added!"
    else 
        error_exit "[-] Could Not Add User $USER! Check The Logfile!"
    fi
    info "Setting Password for User $USER"
    wait 2
    if echo $PASSWORD | passwd --stdin $USER; then
        cecho "[+] Password Set!"
    else 
        error_exit "[-] Could Not Set Password! Check the Logfile!"
    fi
    cecho "Please add the new user to /etc/sudoers" blue ""
	wait 3
    sudo -S nano /etc/sudoers
    info "Logging In As $USER"
    wait 2
    login $USER
    cecho "[+] Beginning Package Installation" yellow ""
    wait 3 
	sudo -S apt update -y
	sudo -S apt --no-install-recommends install -y wget debconf nano curl grub2 grub-efi-amd64
	sudo -S apt update -y  #clean the gpg error message
	#sudo -S apt-get install locales dialog  #If you don't talk en_US
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
    sudo -S echo $SANDBOX_HOSTNAME > /etc/hostname
}
####################################################################################################################
# TOFOMOFO: check for disk space and throw a warning if needed                                                     #
partition_disk() {                                                                                                 #
# This creates the basic disk structure of an EFI disk with a single OS.                                           #
cecho "You CAN boot .ISO Files from the persistance partition if you mount in GRUB2" green ""
#                                                                                                                  #
##### EFI ##########################################################################################################
    info "Creating EFI partition"
    if parted /dev/$WANNABE_LIVE_DISK --script mkpart EFI fat16 1MiB 100MiB; then
        cecho "[+] EFI Partition Created!" green
    else
		error_exit "[-]Partitioning EFI Failed! Check the logfile!"
	fi
##### LIVE disk partition ##########################################################################################
    info " Creating Live Disk partition"
    if parted /dev/$WANNABE_LIVE_DISK --script mkpart live fat16 100MiB 3GiB; then
        cecho "[+] Live Disk Partition Created!" green
    else
		error_exit "[-]Partitioning Live Disk Failed! Check the logfile!"
	fi
##### Persistance Partition ########################################################################################
    info " Creating Persistance partition"
    if parted /dev/$WANNABE_LIVE_DISK --script mkpart persistence ext4 3GiB 100% ; then
        cecho "[+] Persistance Partition Created!" green
    else
		error_exit "[-]Partitioning Persistance Failed! Check the logfile!"
	fi
##### Sets filesystem flag #########################################################################################
    info " Setting MSFTata Flag On EFI partition"
    if parted /dev/$WANNABE_LIVE_DISK --script set 1 msftdata on; then
        cecho "[+] MSFTdata Flag Set on EFI Partition!" green
    else
		error_exit "[-] MSFTdata Flag Setting On EFI Failed! Check the logfile!"
	fi
##### Sets boot flag for legacy (NON-EFI) BIOS ######################################################################
    info " Setting Legacy Boot Flag On Live Disk"
    if parted /dev/$WANNABE_LIVE_DISK --script set 2 legacy_boot on; then
        cecho "[+] Legacy Boot Flag Set on Live Disk Partition!" green
    else
		error_exit "[-]NON-EFI Boot Sector Flag Setting On Live Disk Failed! Check the logfile!"
	fi
 ##### Sets msftdata flag ############################################################################################
    info " Setting MSFTata Flag On Live Disk"
    if parted /dev/$WANNABE_LIVE_DISK --script set 2 msftdata on; then
        cecho "[+] MSFTdata Flag Set on Live Disk Partition!" green
    else
		error_exit "[-]MSFTdata Flag Setting On Live Disk Failed! Check the logfile!"
	fi
}
# This functions pretty much makes a whole damn live usb but I dont know what to name it
format_disk(){
# Here we make the filesystems for the OS to live on
#########################################################################################################################################    
    ## EFI
    info " Creating Fat32 Filesystem For EFI on /dev/{$WANNABE_LIVE_DISK}1"
    if test -f /dev/${WANNABE_LIVE_DISK}1; then
        if mkfs.vfat -n EFI /dev/${WANNABE_LIVE_DISK}1; then
            cecho "[+] Created Fat32 Filesystem on EFI Partion " green
        else 
            error_exit "[-] Failed! Check the logfile!"
        fi
    fi
#########################################################################################################################################    
    ## LIVE disk partition
    info " Creating Fat32 Filesystem on Live Disk Partition"
    if test -f /dev/${WANNABE_LIVE_DISK}; then
        if mkfs.vfat -n LIVE /dev/${WANNABE_LIVE_DISK}2; then
            cecho "[+] Created Fat32 Filesystem on Live Disk Partion " green
        else 
            error_exit "[-] Creation of Fat32 Filesystem on Live Disk Partition Failed! Check the logfile!"
        fi
    fi
#########################################################################################################################################    
    ## Persistance Partition
    if test -f /dev/${WANNABE_LIVE_DISK}; then
        info "Creating Filesystem On Persistance Partition"
        if sudo -S mkfs.ext4 -F -L persistence /dev/${WANNABE_LIVE_DISK}3; then
            cecho "[+] Created Ext4 Filesystem on Persistance Partion " green
        else 
            error_exit "[-] Creation of Ext4 Filesystem on Persistance Partition Failed! Check the logfile!"
        fi
    fi
#########################################################################################################################################    
    # Creating Temporary work directories
    info "[+] Creating Temporary Work Directories"
    if sudo -S mkdir /tmp/usb-efi /tmp/usb-live /tmp/usb-persistence /tmp/live-iso; then
        cecho "[+] Created Folders In /tmp" green
    else
        error_exit "[-] Could Not Create Folders in /tmp ! Check the logfile!"
    fi
#########################################################################################################################################    
    # Mounting those directories on the newly created filesystem
    info "Mounting /tmp/usb-efi/ On dev/${WANNABE_LIVE_DISK}1"
    if sudo -S mount /dev/${WANNABE_LIVE_DISK}1 /tmp/usb-efi; then
        cecho "[+] Mounted Sucessfully!" green
    else
        error_exit "[-] Could Not Mount Folder On Partition! Check the logfile!"   
    fi
#########################################################################################################################################    
    #mount Live Partition
    info "Mounting /tmp/usb-live/ On dev/${WANNABE_LIVE_DISK}2"
    if sudo -S mount /dev/${WANNABE_LIVE_DISK}2 /tmp/usb-live; then
        cecho "[+] Mounted Sucessfully!" green
    else
        error_exit "[-] Could Not Mount Folder On Partition! Check the logfile!"
    fi
#########################################################################################################################################    
    info "Mounting /tmp/usb-persistence/ On dev/${WANNABE_LIVE_DISK}3"
    if sudo -S mount /dev/${WANNABE_LIVE_DISK}3 /tmp/usb-persistence; then
        cecho "[+] Mounted Sucessfully!" green
    else
        error_exit "[-] Could Not Mount Folder On Partition! Check the logfile!"
    # Mount the ISO on a temp folder to get the files moved
    fi
#########################################################################################################################################    
    ## rsync --verbose --recursive --specials --executability ---perms --relative --safe-links --xattrs --owner --group --preallocate --dry-run --progress --human-readable
    if sudo -S rsync --verbose \
    --recursive \
    --specials \
    --executability \
    ---perms \
    --relative \
    --safe-links \
    --xattrs \
    --owner \
    --group \
    --preallocate \
    --dry-run \
    --progress \
    --human-readable \
    $1/* /tmp/usb-live; then
    ## Takes either from 
        cecho "[+] OS Files Copied!"
    else
        error_exit "[-] Could Not Copy Files! Check the logfile!"
    fi
#########################################################################################################################################    
    # IMPORTANT! This establishes persistance! UNION is a special mounting option 
    # https://unix.stackexchange.com/questions/282393/union-mount-on-linux
    info "Establishing Persistence!"
    if sudo -S echo "/ union" > /tmp/usb-persistence/persistence.conf; then
        cecho "[+] Union Mount Of Persistence Partition On Root Filesystem Should Work Now!"
    else
        error_exit "[-] Could Not Establish Persistence! Check the logfile!"
    fi
#########################################################################################################################################    
    # Install GRUB2
    # https://en.wikipedia.org/wiki/GNU_GRUB
    ## Script supported targets: arm64-efi, x86_64-efi, , i386-efi
    # TODO : Install 32bit brub2 then 64bit brub2 then `update-grub`
    #        So's we can install 32 bit OS to live disk.
    #########################
    ##      64-BIT OS       #
    #########################
    if [ $BIT_SIZE = "64" ]; then
        if [ $ARCH == "ARM" ] ; then
            cecho "[+] Installing GRUB2 for ${ARCH} to /dev/${WANNABE_LIVE_DISK}" yellow
            if sudo -S grub-install --removable --target=arm-efi --boot-directory=/tmp/usb-live/boot/ --efi-directory=/tmp/usb-efi /dev/$WANNABE_LIVE_DISK ; then
                cecho "[+] GRUB2 Install Finished Successfully!" green
	        else
		        error_exit "[-]GRUB2 Install Failed! Check the logfile!"
	        fi   
        elif [ $ARCH == "X86" ] ; then
            cecho "[+] Installing GRUB2 for ${ARCH} to /dev/${WANNABE_LIVE_DISK}" yellow
            if sudo -S grub-install --removable --target=i386-efi --boot-directory=/tmp/usb-live/boot/ --efi-directory=/tmp/usb-efi /dev/$WANNABE_LIVE_DISK; then
                cecho "[+] GRUB2 Install Finished Successfully!" green
	        else
		        error_exit "[-]GRUB2 Install Failed! Check the logfile!"
	        fi
        elif [ $ARCH == "X64" ] ; then
            cecho "[+] Installing GRUB2 for ${ARCH} to /dev/${WANNABE_LIVE_DISK}" yellow
            if sudo -S grub-install --removable --target=X86_64-efi --boot-directory=/tmp/usb-live/boot/ --efi-directory=/tmp/usb-efi /dev/$WANNABE_LIVE_DISK ; then
	            cecho "[+] GRUB2 Install Finished Successfully!" green
	        else
		        error_exit "[-]GRUB2 Install Failed! Check the logfile!"
	        fi
        else
            cecho "Something WIERD happened, Throw a banana and try again!" yellow "";
        fi
    fi
#########################################################################################################################################    
    info "Copying MBR for syslinux booting of LIVE disk"
    dd bs=440 count=1 conv=notrunc if=/usr/lib/syslinux/mbr/gptmbr.bin of=/dev/${WANNABE_LIVE_DISK}
#########################################################################################################################################    
    # Install Syslinux
    # https://wiki.syslinux.org/wiki/index.php?title=HowTos
    info "Installing SysLinux on Live Disk"
    if sudo -S syslinux --install /dev/${WANNABE_LIVE_DISK}2; then
        cecho "[+] Syslinux installed on ${WANNABE_LIVE_DISK} !" green ""
        if sudo -S mv /tmp/usb-live/isolinux /tmp/usb-live/syslinux; then
            cecho "[+] Isolinux Changed to Syslinux!" green ""
        else 
            error_exit "[-] ERROR WHILE INSTALLING SYSLINUX: Check the logfile!"
        fi
        if sudo -S mv /tmp/usb-live/syslinux/isolinux.bin /tmp/usb-live/syslinux/syslinux.bin; then
            cecho "[+] Isolinux.bin Changed to syslinux.bin!" green ""
        else 
            error_exit "[-] ERROR WHILE INSTALLING SYSLINUX: Check the logfile!"
        fi
        if sudo -S mv /tmp/usb-live/syslinux/isolinux.cfg /tmp/usb-live/syslinux/syslinux.cfg; then
            cecho "[+] Isolinux configuration Changed to Syslinux!" green ""
        else 
            error_exit "[-] ERROR WHILE INSTALLING SYSLINUX: Check the logfile!"
        fi
    else 
        error_exit "[-] ERROR WHILE INSTALLING SYSLINUX: Check the logfile!"
    fi
#########################################################################################################################################    
    info "Finishing Syslinux Install"
    # Magic, sets up syslinux configuration and layouts 
    if sudo -S sed --in-place 's#isolinux/splash#syslinux/splash#' /tmp/usb-live/boot/grub/grub.cfg; then
        cecho "[+] Grub.cgf modified!" green ""
    else
        error_exit "[-] Could not edit Grub.cgf! Check the logfile!"
    fi
#########################################################################################################################################    
    if sudo -S sed --in-place '0,/boot=live/{s/\(boot=live .*\)$/\1 persistence/}' /tmp/usb-live/boot/grub/grub.cfg /tmp/usb-live/syslinux/menu.cfg; then
        cecho "[+] File modified!" green ""
    else
        error_exit "[-] Could Not Edit File For Persistance! Check the logfile!"
    fi
#########################################################################################################################################    
    if sudo -S sed --in-place '0,/boot=live/{s/\(boot=live .*\)$/\1 keyboard-layouts=en locales=en_US/}' /tmp/usb-live/boot/grub/grub.cfg /tmp/usb-live/syslinux/menu.cfg; then
        cecho "[+] Locales Have Been Set!" green ""
    else
        error_exit "[-] Could Not Set Locales! Check the logfile!"
    fi
#########################################################################################################################################
    if sudo -S sed --in-place 's#isolinux/splash#syslinux/splash#' /tmp/usb-live/boot/grub/grub.cfg; then
        cecho "[+] !" green ""
    else
        error_exit "[-] Could not edit file! Check the logfile!"
    fi
#########################################################################################################################################    
    info "... Cleaning up"
    # Clean up!
    if sudo -S umount /tmp/usb-efi /tmp/usb-live /tmp/usb-persistence /tmp/live-iso; then
        cecho "[+] Temporary Folders Unmounted!"
    else
        warn "Could Not Unmount Temporary Folders!!"
    fi
    if sudo -S rmdir /tmp/usb-efi /tmp/usb-live /tmp/usb-persistence /tmp/live-iso; then
        cecho "[+] Temporary Folders Deleted!" green ""
    else
        warn "Could Not Delete Temporary Folders!!"
    fi
}
#########################################################################################################################################    
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
echo "======================================================================="
echo "=================" cecho "--Debootstrap Chroot Generator--" blue ""; echo "======================"
echo "======================================================================="
############################
##--	Menu System		--##
############################
#check if the user is stupid
analyze_yes_no_opts
#check again if the user is really serious about all this
get_permission;
#holy crap they are going to do it!
if ! which syslinux > /dev/null; then
   echo -e "Install? (y/n) (You kinda need it for this whole process)"
   DECISION = read
   if $(yn) $DECISION == 'y'; then
        echo $(sudo apt-get install syslinux)
   else 
        fatal "You obviously don't want to run this script any further!"
   fi
fi
##### PARSE BOOLEAN OPTIONS #######
#user done goofed
if [ $O_SANDBOX -eq 1 ] && [ $ONLY_FILESYSTEM -eq 1 ]; then
    error_exit "Cannot do --sandbox_only AND --filesystem_only "
#### Only make filesystem
#user done didnt goofed
elif [ $O_SANDBOX -eq 0  ] && [ $ONLY_FILESYSTEM -eq 1 ]; then
    partition_disk

#### only make sandbox
elif [ $O_SANDBOX -eq 1 ] && [ $ONLY_FILESYSTEM -eq 0 ]; then
    cecho " Thank you for riding the OS_Express, please stay in your seat and follow the prompts"
    # correct OS
    if check_os; then
    # enough space
        if check_for_space $WANNABE_LIVE_DISK; then
    # Check if they want to make or use an ISO
    # they want to use an iso        
            if [ $USE_ISO -eq 1 ] && [ $MAKE_ISO -eq 0 ];then
                mount_iso_on_temp
                extract_iso_to_disk
                format_disk $LIVE_DISK
                make_disk_bootable
    # they want to make an iso
            elif [ $USE_ISO -eq 0 ] && [ $MAKE_ISO -eq 1 ]; then
                deboot_first_stage
                deboot_second_stage
                deboot_third_stage
                makeiso_from_debootstrap
    # they want just a sandbox without using or making an ISO
    # This is the expected to be the most used option for my 
    # purposes So expect the most focus on this
    #
    # NETWORKED SANDBOX, MAIN PURPOSE FOR THIS SCRIPT
    # EVERYTHING ELSE IS TO SUPPORT THIS ONE FUNCTION
            elif [ $USE_ISO -eq 0 ] && [ $MAKE_ISO -eq 0 ]; then
                deboot_first_stage
                deboot_second_stage
                deboot_third_stage
                create_iface_ipr2
                setup_host_networking
                setup_network                
    # They want to use an iso, modify it and repack it into an iso
    # OTHER OTHER MAIN FUNCTION FOR THIS SCRIPT
            elif [ $USE_ISO -eq 1 ] && [ $MAKE_ISO -eq 1 ]; then
                error_exit "Currently Using and Generating an ISO together is not supported, wait for version 2... fuck that its going in version 1"
                mount_iso_on_temp
                extract_iso
                deboot_first_stage
                deboot_second_stage
                deboot_third_stage
                makeiso_from_debootstrap
            else 
                error_exit "Something REALLY strange happened! Check the Logfile!"                
            fi
        else 
            error_exit "Something REALLY strange happened! Check the Logfile!"                
        fi
    else 
        error_exit "Something REALLY strange happened! Check the Logfile!"                
    fi
#### They want BOTH! YEAH!
# OTHER MAIN FUNCTION FOR THIS SCRIPT
elif [ ONLY_SANDBOX -eq 0 ] && [ ONLY_FILESYSTEM -eq 0 ]; then
    cecho " Thank you for riding the OS_Express, please stay in your seat and follow the prompts"
    # correct OS
    if check_os; then
    # enough space
        if check_for_space $WANNABE_LIVE_DISK; then
    # Check if they want to make or use an ISO
    # they want to use an iso        
            if [ $USE_ISO -eq 1 ] && [ $MAKE_ISO -eq 0 ];then
                deboot_first_stage
                deboot_second_stage
                deboot_third_stage
                format_disk $SANDBOX
                partition_disk
    # They want to MAKE an ISO
            elif [ $USE_ISO -eq 0 ] && [ $MAKE_ISO -eq 1 ]; then
                deboot_first_stage
                deboot_second_stage
                deboot_third_stage
                format_disk $SANDBOX
                makeiso_from_debootstrap
                partition_disk
    # They Just Want the Sandbox And Filesystem ON A USB
            elif [ $USE_ISO -eq 0 ] && [ $MAKE_ISO -eq 0 ]; then
                deboot_first_stage
                deboot_second_stage
                deboot_third_stage
                format_disk $SANDBOX
                partition_disk
    # They want to MAKE AN ISO FROM DEBOOTSTRAP and USE That ISO
            elif [ $USE_ISO -eq 1 ] && [ $MAKE_ISO -eq 1 ]; then


            else

            fi
        fi
    fi

else 
        cecho "oops" blue ""
fi
del_iface1
del_iface2
create_disk
create_iface_ipr1
create_iface_ipr2
format_disk
mount_iso_on_temp
partition_disk
setup_host_networking
setup_network
deboot_first_stage
deboot_second_stage
deboot_third_stage 
connect_sandbox
establish_network

exit
warn "What exactly are you trying to do MISTER!?"
linux-image-generic (4.15.0.76.78 [amd64, i386], 4.15.0.20.23 [arm64, armhf, ppc64el, s390x]) [security]
    Generic Linux kernel image
linux-generic (4.15.0.76.78 [amd64, i386], 4.15.0.20.23 [arm64, armhf, ppc64el, s390x]) [security]
    Complete Generic Linux kernel and headers
