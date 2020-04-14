#!/bin/bash

echo "Getting necessary dependencies for accountable2you"
mkdir ~/.temp_accountable_install

echo "Getting dependencies needed for Python3.7"
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev wget

echo "Downloading Python3.7"
cd ~/.temp_accountable_install

wget -O ~/.temp_accountable_install https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz

tar -xf ~/.temp_accountable_install/Python-3.7.4.tgz --directory ~/.temp_accountable_install

cd ~/.temp_accountable_install/Python-3.7.4

./configure --enable-optimizations 

make

sudo make altinstall

echo "Python 3.7 installed, installing dependencies for Accountable2You"

sudo apt install libcairo2-dev libgirepository1.0-dev

sudo python3.7 -m pip install PyGObject

sudo python3.7 -m pip install suds-py3

cd ~/.temp_accountable_install

wget https://secure.accountable2you.com/linux/deb/accountable2you-1.84p37.zip

tar -xvf accountable2you-1.84p37.zip

sudo dpkg -i accountable2you-1.84p37.deb

sudo rm /usr/bin/accountable2you

sudo cat << 'EOF' >> /usr/bin/accountable2you 
#!/bin/sh
cd /usr/share/accountable2you/
exec python3.7 accountable2you.pyc --$USER "$@" > /tmp/$USER-accountable2you.lo>
EOF

echo "Install complete, you should now be able to run accountable2you"

