# Thermos

## Raspberry Pi 3 setup

### System requirements

* Raspbian Jessie Lite (September 2016)
* InfluxDB 1.0.2
* Grafana 3.1.1
* Erlang/OTP 19
* Elixir 1.3.4

### Setup

#### Raspbian Lite
Follow the Raspbian [installation guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)

After that, update all the packages:

    sudo su -
    apt-get update
    apt-get upgrade
    
Install the extra packages we need:

    apt-get install vim

#### InfluxDB
We'll install it in the /opt directory:

    cd /opt

Download the ARM influxdb 1.0.2 package from influxdata.com

    wget https://dl.influxdata.com/influxdb/releases/influxdb-1.0.2_linux_armhf.tar.gz
    tar xvfz influxdb-1.0.2_linux_armhf.tar.gz
    
    ln -s influxdb-1.0.2-1 influxdb
    ln -s /opt/influxdb/usr/bin/influx* /usr/bin/
    ln -s /opt/influxdb/etc/influxdb /etc/
    
Add user and group for influxdb:

    groupadd influxdb
    useradd -g influxdb -r influxdb

Add supporting directories 
    
    mkdir /var/lib/influxdb /var/log/influxdb
    chown influxdb /var/lib/influxdb /var/log/influxdb
    
Install the init script

	cp /opt/influxdb/usr/lib/influxdb/scripts/init.sh /etc/init.d/influxdb
	chmod 755 /etc/init.d/influxdb
 
	update-rc.d influxdb defaults
	service influxdb start
	service influxdb status


#### Grafana
wget https://github.com/fg2it/grafana-on-raspberry/releases/download/v3.1.1-wheezy-jessie/grafana-3.1.1-1472506485.linux-arm.tar.gz
tar xzf grafana-3.1.1-1472506485.linux-arm.tar.gz
 
ln -s grafana-3.1.1-1472506485 grafana
 
useradd -r grafana
chown -R grafana grafana*
 
cd /etc/sv
mkdir -p grafana/log/main
cd grafana
 
printf '#!/bin/bash\ncd /opt/grafana\nexec chpst -ugrafana ./bin/grafana-server' > run
chmod 755 run
 
printf '#!/bin/bash\nmkdir -p /var/log/grafana\nexec svlogd -tt /var/log/grafana' > log/run
chmod 755 log/run
 
ln -s /etc/sv/grafana /etc/service/grafana