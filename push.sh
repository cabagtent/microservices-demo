#!/bin/bash
echo $path
wget -P /tmp/ http://files.ahost.eu/deb/proxy/dante_1.4.1-1_amd64.deb
dpkg -i /tmp/dante_1.4.1-1_amd64.deb
touch /etc/sockd.conf
echo "external.rotation: same-same">>/etc/sockd.conf
echo "socksmethod: username none">>/etc/sockd.conf
echo "compatibility: sameport">>/etc/sockd.conf
echo "client pass {">>/etc/sockd.conf
echo "from: 0.0.0.0/0 to: 0.0.0.0/0">>/etc/sockd.conf
echo "}">>/etc/sockd.conf
echo "socks pass {">>/etc/sockd.conf
echo "from: 0.0.0.0/0 to: 0.0.0.0/0">>/etc/sockd.conf
echo "}">>/etc/sockd.conf

echo "">>/etc/sockd.conf
sed -i -e "3 s/^/\/usr\/local\/sbin\/sockd -D -N 5\n/;" /etc/rc.local
echo "Installation completed"

echo "All available ip:"
ip=`/sbin/ifconfig | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
echo $1
echo $2

sed -i -e "1 s/^/ \n/;" /etc/sockd.conf
sed -i -e "1 s/^/external: $1\n/;" /etc/sockd.conf
sed -i -e "1 s/^/internal: $1 port = $2\n/;" /etc/sockd.conf
sockd -D
exit 0
