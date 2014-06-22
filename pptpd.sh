# Automaticlly install pptpd on Amazon EC2 Amazon Linux
# 
# Ripped from http://blog.diahosting.com/linux-tutorial/pptpd/
# pptpd source rpm packing by it's authors
#
# You need to adjust your "Security Groups" which you are using too.
# The security rules which I'm using looks like:
# =================================
# ALL  tcp  0  65535 0.0.0.0/0 
# ALL  udp  0  65535 0.0.0.0/0 
# =================================
# 
# Authors: yinhm
# Version: 0.1.0
# URL: http://yinhm.appspot.com/
#
#Update by leoshan
#Version: 0.2
#Ripped from https://gist.githubusercontent.com/yinhm/666241/raw/e8f3030a9e7066b8deb0a3d9ec761360e2d94227/pptpd.sh

# Clean the old config
yum remove -y pptpd ppp
iptables --flush POSTROUTING --table nat
iptables --flush FORWARD
rm -rf /etc/pptpd.conf
rm -rf /etc/ppp

# Install ppp  
yum -y install ppp

# Install pptd
mkdir ~/src
cd ~/src
wget http://poptop.sourceforge.net/yum/stable/packages/pptpd-1.4.0-1.el6.x86_64.rpm
rpm -Uhv pptpd-1.4.0-1.el6.x86_64.rpm

# Config /etc/pptpd.conf, /etc/sysctl.conf and /etc/ppp/options.pptpd
sed -i 's/^logwtmp/#logwtmp/g' /etc/pptpd.conf
echo "localip 192.168.240.1" >> /etc/pptpd.conf
echo "remoteip 192.168.240.2-100" >> /etc/pptpd.conf

sed -i 's/^net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
sysctl -p

echo "ms-dns 8.8.8.8" >> /etc/ppp/options.pptpd
echo "ms-dns 8.8.4.4" >> /etc/ppp/options.pptpd

# config the account and password
pass=`openssl rand 8 -base64`
if [ "$1" != "" ]
then pass=$1
fi

echo "vpn pptpd ${pass} *" >> /etc/ppp/chap-secrets

# config the iptables
iptables -t nat -A POSTROUTING -s 192.168.240.0/24 -j SNAT --to-source `ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1 { print $1}'`
iptables -A FORWARD -p tcp --syn -s 192.168.240.0/24 -j TCPMSS --set-mss 1356
service iptables save

#config 
chkconfig iptables on
chkconfig pptpd on

service iptables start
service pptpd start

echo -e "VPN service is installed, your VPN username is \033[1mvpn\033[0m, VPN password is \033[1m${pass}\033[1m"
