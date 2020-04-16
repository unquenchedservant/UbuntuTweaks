#!/bin/bash
# Created by Jonathan Thorne
#
# It makes Accountable2You work on Ubuntu 20.04 for the time being
# Tested on a fresh install of Ubuntu 20.04 Beta

# -----------------------------------------------------------------
# INSTALLATION INSTRUCTIONS
# $ wget https://github.com/chillhumanoid/UbuntuTweaks/blob/master/Accountable2YouFocal.sh
# $ chmod +x Accountable2YouFocal.sh
# $ sudo ./Accountable2YouFocal.sh
# -----------------------------------------------------------------

# -----------------------------------------------------------------
# Initilazation
# * update ubuntu files
# * create temp directory
# * install all apt dependencies needed
# -----------------------------------------------------------------
sudo add-apt-repository universe #this should already be added, but just in case
sudo apt update
sudo apt upgrade


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


PYTHON="$(python3.7 -V)"
if [[ "$PYTHON" == "Python 3.7.4" ]]; then
    echo "Python 3.7 already installed"
else
    # get the cores for 100%, 75%, 50% and 25%
    CORES=$(nproc)
    FIFT=$((CORES/2))
    FIFT=${FIFT%.*}
    TWFI=$((CORES/4))
    TWFI=${TWFI%.*}
    SEFI=$((FIFT+TWFI))
    FINL=0
    while :
    do
        echo -e "\nCPU Utilization:"
        read -n1 -s -p "(a)100% (b)75% (c)50% (d)25% (e)custom [c] ? " INPT
        INPT=${INPT:-c}
        case $INPT in
        [Aa]* )
            FINL=$CORES
            break
            ;;
        [Bb]* )
            FINL=$SEFI
            break
            ;;
        [Cc]* )
            FINL=$FIFT
            break
            ;;
        [Dd]* )
            FINL=$TWFI
            break
            ;;
        [Ee]* )
            while :
            do
                echo -e "\nTotal cores - $CORES"
                read -p "Amount to use: " CUST
                if [ $CUST -gt $CORES ]; then
                    echo -e "\nCan't be higher than total cores"
                elif [ $CUST -lt 0 ]; then
                     echo -e "\nCan't be lower than 0"
                else
                    FINL=$CUST
                    break
                fi
            done
            echo -e "\nUsing $FINL cores"
            break
            ;;
          * ) echo -e "\nPlease Select an option" ;;
        esac
    done

    wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
    tar -xf Python-3.7.4.tgz
    cd Python-3.7.4

    ./configure --enable-optimizations
    make -j $FINL
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

