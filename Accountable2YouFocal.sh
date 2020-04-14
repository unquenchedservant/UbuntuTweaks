#!/bin/bash
# Created by Jonathan Thorne
#
# It makes Accountable2You work on Ubuntu 20.04 for the time being
# Tested on a fresh install of Ubuntu 20.04 Beta

# -----------------------------------------------------------------
# Initilazation
# * update ubuntu files
# * create temp directory
# * install all apt dependencies needed
# -----------------------------------------------------------------
sudo apt update
mkdir ~/.temp_accountable_install
cd ~/.temp_accountable_install
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev wget gcc


# ------------------------------------------------------------------
# Install Python
# * get the number of CPU cores, and divide by half
#   * this is so that compiling the source for python3.7.4 is quicker
#     without utilizing 100% of the CPU
# * if python 3.7.4 is not installed already, download the source 
# * then configure the source, with optimizations
# * make the install utilizing half of the CPU
# * install with altinstall so that python3 still utilizes python 3.8
# ------------------------------------------------------------------
CORES=$(nproc)
if [[ $CORES == 1 ]]; then
    HALF=1
else
    HALF=$(echo "$CORES / 2" | bc)
fi

PYTHON="$(python3.7 -V)"
if [[ "$PYTHON" == "Python 3.7.4" ]]; then
    echo "Python 3.7 already installed"
else
    wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
    tar -xf Python-3.7.4.tgz
    cd Python-3.7.4

    ./configure --enable-optimizations
    make -j $HALF
    sudo make altinstall

    # Go back to temp folder root, just in case 
    cd ~/.temp_accountable_install
    echo "Python 3.7 successfully installed"
fi

# -------------------------------------------------------------------
# Final Installations
# * install final libs needed for python3.7 and Accountable2You
# * install the python packages needed for Accountable2You
# -------------------------------------------------------------------
sudo apt install -y libcairo2-dev libgirepository1.0-dev wmctrl gir1.2-appindicator3-0.1 python3-suds python3-psutil

sudo python3.7 -m pip install PyGObject
sudo python3.7 -m pip install suds-py3
sudo python3.7 -m pip install psutil

cd ~/.temp_accountable_install

# -----------------------------------------------------------------------
# Install Accountable2You
# -----------------------------------------------------------------------
FILE=accountable2you-1.84p37.deb
if test -f "$FILE"; then
    echo ".deb already exists"
else
    echo "Installing Accountable2You .deb"
    wget https://secure.accountable2you.com/linux/deb/accountable2you-1.84p37.zip
    unzip accountable2you-1.84p37.zip
fi

sudo dpkg -i accountable2you-1.84p37.deb


# -------------------------------------------------------------------------
# Finishing Touches
# * remove the old bin file and recreate it using python3.7 instead of python3.8
# * remove the temporary install directory
# -------------------------------------------------------------------------
sudo rm /usr/bin/accountable2you
cat << 'EOF' >> /usr/bin/accountable2you
#!/bin/sh
cd /usr/share/accountable2you/
exec python3.7 accountable2you.pyc --$USER "$@" > /tmp/$USER-accountable2you.log 2>&1
EOF
chmod +x /usr/bin/accountable2you

echo "Install complete, removing files"

cd
rm -R .temp_accountable_install/
echo "You can now use Accountable2You"

