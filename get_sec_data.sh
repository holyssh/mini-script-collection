#!/bin/sh

for var in whereis scat sfind shostname sifconfig suname sw sls scrontab slsmod sps snetstat ssysctl slsof szcat sdpkg srpm siptables spvdisplay svgdisplay slvdisplay a b
do
	unset $var
done

whereis="/usr/bin/whereis -b"
scat=`$whereis cat | awk '{split($0,a," "); print a[2]}'`
sfind=`$whereis find | awk '{split($0,a," "); print a[2]}'`
shostname=`$whereis hostname | awk '{split($0,a," "); print a[2]}'`
sifconfig=`$whereis ifconfig | awk '{split($0,a," "); print a[2]}'`
suname=`$whereis uname | awk '{split($0,a," "); print a[2]}'`
sw=`$whereis w | awk '{split($0,a," "); print a[2]}'`
sls=`$whereis ls | awk '{split($0,a," "); print a[2]}'`
scrontab=`$whereis crontab | awk '{split($0,a," "); print a[2]}'`
slsmod=`$whereis lsmod | awk '{split($0,a," "); print a[2]}'`
sps=`$whereis ps | awk '{split($0,a," "); print a[2]}'`
snetstat=`$whereis netstat | awk '{split($0,a," "); print a[2]}'`
ssysctl=`$whereis sysctl | awk '{split($0,a," "); print a[2]}'`
slsof=`$whereis lsof | awk '{split($0,a," "); print a[2]}'`
szcat=`$whereis zcat | awk '{split($0,a," "); print a[2]}'`
sdpkg=`$whereis dpkg | awk '{split($0,a," "); print a[2]}'`
srpm=`$whereis rpm | awk '{split($0,a," "); print a[3]}'`
siptables=`$whereis iptables | awk '{split($0,a," "); print a[2]}'`
spvdisplay=`$whereis pvdisplay | awk '{split($0,a," "); print a[2]}'`
svgdisplay=`$whereis vgdisplay | awk '{split($0,a," "); print a[2]}'`
slvdisplay=`$whereis lvdisplay | awk '{split($0,a," "); print a[2]}'`



sfile=/root/sec_data_dump
$scat /dev/null > $sfile
ssection="**************************************************************************************************************************"

####################################################################################################################################
## used commands ## 
####################################################################################################################################

a[1]="FQDN Hostname:"
a[2]="${shostname} -f"

a[3]="Interfaces und IP-Adressen:"
if [[ -n $sifconfig ]];
then
	a[4]="${sifconfig} -a"
fi

a[5]="Linux Distribution und Version:"
a[6]="${scat} /etc/issue"

a[7]="Linux Kernel Version:"
a[8]="${suname} -a"

a[9]="Aktuell angemeldete User und deren Sessions:"
a[10]="$sw" 

a[11]="Netzwerkdienste/Prozesse (netstat -luntp)"
a[12]="${snetstat} -luntp"

a[13]="Kernel Optionen "
a[14]="${ssysctl} -a"

a[15]="Hostname:"
a[16]="${shostname}"

a[19]="Cron Job Verzeichnisse:"
a[20]="${sls} -la /etc/cron* "

a[21]="Linux Module:"
a[22]="${slsmod}"

a[23]="Crontab Job Liste des Users:"
a[24]="${scrontab} -l"

a[25]="Linux Prozessliste (1):"
a[26]="${sps} -ef"

a[27]="Linux Prozessliste (2):"
a[28]="${sps} -aux"

a[29]="geöffnete Dateien mit Netzwerkzugriff:"
a[30]="${slsof} -i -n"

a[31]="Alle Dateien und Unterordner von /etc:"
a[32]="${sls} -laR /etc/"

a[33]="Alle Dateien und Unterordner von /var/log/:"
a[34]="${sls} -laR /var/log/"

a[35]="alle mittels Red Hat Paket Manager installierten Softwarepakete:"
if [[ -n $srpm ]];
then
	a[36]="${srpm} -qa"
fi

a[37]="alle mittels Debian Paket Manager installierten Softwarepakete:"
if [[ -n $sdpkg ]];
then
	a[38]="${sdpkg} -l"
fi

a[39]="Firewall Regeln"
a[40]="$siptables -L"

a[41]="LVM - Physikalische Devices:"
a[42]="$spvdisplay"

a[43]="LVM - Volume Groups:"
a[44]="$vgdisplay:"

a[45]="LVM - Logical Volumes:"
a[44]="$lvdisplay:"

#a[]="Search for files which have suid and sgid bit set:"
#a[]="find /bin /boot /dev /etc /home /lib /lib64 /proc /root /sbin /tmp /sys /usr /var \( -perm -4000 -o -perm -2000 \) -type f -exec ls -la {} \; 2> /dev/null"
 
#a[]="Search for files which have suid and sgid bit set with the ELF file format:"
#a[]="find /bin /boot /dev /etc /home /lib /lib64 /root /sbin /tmp /sys /usr /var \( -perm -4000 -o -perm -2000 \) -type f -exec file {} \; | grep -v ELF"

#a[]="Search for files which have world- and group-writeable directories:"
#a[]="find /bin /boot /dev /etc /home /lib /lib64 /root /sbin /tmp /sys /usr /var -type d \( -perm -g+w -o -perm -o+w \) -exec ls -lad {} \; 2> /dev/null"


#################################################################################################################################
# Schleife zum absetzen der Standardkommandos #
#################################################################################################################################

for (( i=1 ; i<=39; i=i+2 ))
do
	if [[ -n ${a[$i]} ]] && [[ -n ${a[$i+1]} ]]; 
	then
		echo -e "\n\n\n\n$ssection" >> $sfile
		echo -e "$ssection" >> $sfile
		echo ${a[$i]} >> $sfile
		echo "Verwendeter Shellbefehl: ${a[$i+1]}" >> $sfile
		echo -e "$ssection" >> $sfile
		${a[$i+1]} >> $sfile
		echo -e "$ssection" >> $sfile
		echo -e "$ssection" >> $sfile
	fi
done
##################################################################################################################################
## Interessante Dateien ##
##################################################################################################################################

#spasswd_desc="passwd-File (Users):"
#spasswd="${scat} /etc/passwd >> $sfile" 
b[1]="/etc/passwd"
b[2]="${scat} /etc/passwd" 

b[3]="/etc/group"
b[4]="${scat} /etc/group" 

b[5]="/etc/fstab"
b[6]="${scat} /etc/fstab" 

b[7]="/etc/inetd.conf"
b[8]="${scat} /etc/inetd.conf"

b[9]="/etc/xinetd.conf "
b[10]="${scat} /etc/xinetd.conf"

b[11]="/var/log/auth.log"
b[12]="${scat} /var/log/auth.log"

b[13]="/etc/hosts"
b[14]="${scat} /etc/hosts"

b[15]="/etc/sysctl.conf"
b[16]="${scat} /etc/sysctl.conf"

b[17]="/etc/ssh/sshd.conf"
b[18]="${scat} /etc/ssh/sshd.conf"

b[19]="/proc/config.gz"
b[20]="${szcat} /proc/config.gz"

#########################################################################################################################
# loop for filedump ##################
#########################################################################################################################


for (( i=1 ; i<=19; i=i+2 ))
do
	if [[ -f ${b[$i]} ]] && [[ -n ${a[$i+1]} ]];
	then
	echo -e "\n\n\n\n$ssection" >> $sfile
	echo -e "$ssection" >> $sfile
		echo "Datei: ${b[$i]}:" >> $sfile
		echo "Verwendeter Shellbefehl: ${b[$i+1]}" >> $sfile
		echo -e "$ssection" >> $sfile
		${b[$i+1]} >> $sfile
	else
		echo "Datei ${b[$i]} existiert nicht" >> $sfile
	fi
	echo -e "$ssection" >> $sfile
	echo -e "$ssection" >> $sfile
done


