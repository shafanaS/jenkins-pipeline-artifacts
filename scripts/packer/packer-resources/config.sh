# ------------------------------------------------------------------------
# Copyright 2019 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

#!/bin/bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export DEBIAN_FRONTEND=noninteractive
product=$1

################################################ WSO2 Product ####################################################
sudo apt-get update
echo "Removing locks"
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock
echo "Successfully removed locks"
echo "Installing mysql-client"
sudo apt-get install -q -y mysql-client
echo "Installing pip"
sudo apt install -q -y python-pip
echo "Installing maven"
sudo apt install -q -y maven
#copy both staging and prod products
echo "Copying $product ..."
cp /tmp/$product.zip /home/ubuntu/
cp /tmp/jdk-8u144-linux-x64.tar.gz /opt
cp /tmp/jdk-8u192-ea-bin-b02-linux-x64-19_jul_2018.tar.gz /opt
mkdir /home/ubuntu/endpointCars
cp /tmp/*_staging*.car /home/ubuntu/endpointCars
cp /tmp/*_production*.car /home/ubuntu/endpointCars
mkdir /usr/local/bin/bashScripts
cp /tmp/util/bashScripts/* /usr/local/bin/bashScripts
mkdir /home/ubuntu/$product
mkdir /home/ubuntu/$product/dbScripts
cp /tmp/util/dbScripts/* /home/ubuntu/$product/dbScripts/
chmod -R +x /home/ubuntu/$product/dbScripts
chmod -R +x /usr/local/bin/bashScripts


#echo "Copying sources.list ..."
#sudo cp -f /tmp/conf/sources.list /etc/apt/sources.list.old -v
#echo "deb http://security.ubuntu.com/ubuntu bionic-security main restricted
#deb http://security.ubuntu.com/ubuntu bionic-security universe
#deb http://security.ubuntu.com/ubuntu bionic-security multiverse" > /etc/apt/sources.list
echo "Copying sysctl.conf ..."
sudo cp /tmp/conf/sysctl.conf /etc/sysctl.conf -v
echo "Copying limits.conf ..."
sudo cp /tmp/conf/limits.conf /etc/security/limits.conf  -v
echo 'export HISTTIMEFORMAT="%F %T "' >> /etc/profile.d/history.sh
cat /dev/null > ~/.bash_history && history -c
