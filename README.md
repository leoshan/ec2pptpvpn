ec2pptpvpn
==========
Use AWS EC2 to build a PPTP VPN server. This is a deploy script of shell. 
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
# 5. Adjust the ec2 "Security Groups", open the ports for instance.
eg. ALL  traffic  0  65535 0.0.0.0/0
# 6. Use iPad or iPhone to connect the vpn.
server: Public DNS or Public IP
account & password: use the name and password in /etc/ppp/chap-secrets
secret rank: None (No use OpenSSL command) or Auto (use OpenSSL command create password)
Sent all flows: Yes



