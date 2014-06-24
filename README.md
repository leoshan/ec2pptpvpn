ec2pptpvpn
==========
Use AWS EC2 to build a PPTP VPN server and a squid proxy server. This is a deploy script of shell. 
First apply an aws account and create an ec2 instance(choose region in Tykyo,for speed).  
# 1. Use putty connect to ec2 instance. 
To do as "Connecting to Linux/Unix Instances from Windows Using PuTTY"
http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html
# 2. Update the ec2 AMI instance
yum update
# 3. Set root password
sudo passwd root
# 4.Use root user download the script pptpd.sh and execute it.
wget https://raw.githubusercontent.com/leoshan/ec2pptpvpn/master/pptpd.sh
chmod 744 pptpd.sh
./pptpd.sh
# 5. Adjust the ec2 "Security Groups", open the PPTPD ports Tcp 1723 for instance.
TCP  1723 0.0.0.0/0
# 6. Use iPad or iPhone to connect the vpn.
server: Public DNS or Public IP
account & password: use the name and password in /etc/ppp/chap-secrets
secret rank: None (No use OpenSSL) or Auto (Use OpenSSL command create password)
Sent all flows: Yes

Install squid proxy server
=====================================================
# 7. For visit twitter, deploy squid proxy server. 
1) yum install squid
2) vim /etc/squid/squid.conf
   Modify http_access deny all TO http_access allow all
3) Check parse is ok
   squid -k parse
4) initial cache
   squid -z
5) chkconfig squid on
6) service squid start
7) verify squid service, see 3128 port is licening
   netstat -ntpl
# 8. Set IP proxy on twitter App.
IP: 192.168.240.1 (The localip of pptp vpn config, also is the gateway)
Port: 3128 (Don't use set the port in secret group)



