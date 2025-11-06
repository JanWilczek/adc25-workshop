sudo apt -y update

# Install fonts
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt-get -y install ttf-mscorefonts-installer
sudo fc-cache -f

# JUCE setup
sudo apt -y install libasound2-dev libjack-jackd2-dev \
    ladspa-sdk \
    libcurl4-openssl-dev  \
    libfreetype-dev libfontconfig1-dev \
    libx11-dev libxcomposite-dev libxcursor-dev libxext-dev libxinerama-dev libxrandr-dev libxrender-dev \
    libwebkit2gtk-4.1-dev \
    libglu1-mesa-dev mesa-common-dev

# Python setup
sudo apt -y install python3.12-venv

python3 -m venv venv
source venv/bin/activate
pip install .

