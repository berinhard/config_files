CURRENT_DIR=$PWD

echo -e '>>>>>>>>>> Ensuring permissions on ssh files'
echo -e 'IMPORTANT: make sure id_rsa exist and is valid for your Github account'
sudo chmod 700 ~/.ssh
sudo chmod 644 ~/.ssh/config
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 644 ~/.ssh/id_rsa.pub

echo -e '\n>>>>>>>>>> Upgrading packages\n'
sudo apt update -y
sudo apt upgrade -y

echo -e '\n>>>>>>>>>> Installing base packages\n'
sudo apt install terminator zsh vim vim-gtk3 git gitk gitg synaptic python3-dev python3-pip gnome-tweaks ack npm postgresql postgresql-client libpq-dev vlc rhythmbox make build-essential libsqlite3-dev curl xclip libcanberra-gtk-module keepassx htop libssl-dev zlib1g-dev libbz2-dev git-gui cmake wget default-jre default-jre-headless libffi-dev liblzma-dev python3-tk direnv ffmpeg tk-dev libavcodec-extra pavucontrol libxcb-xtest0 -y
sudo pip3 install virtualenv virtualenvwrapper

# Install pyenv
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts

echo -e '\n>>>>>>>>>> Your envs and pyenv \n'
mkdir -p "/home/bernardo/src"
mkdir -p "/home/bernardo/workspace"
mkdir -p "/home/bernardo/envs"

echo -e '\n>>>>>>>>>> Installing Processing and processing.py \n'
cd "/home/bernardo/src/"
wget "http://py.processing.org/processing.py-linux64.tgz"
tar -xzvf processing.py-linux64.tgz

wget "https://download.processing.org/processing-3.5.4-linux64.tgz"
tar -xzvf processing-3.5.4-linux64.tgz
bash "processing-3.5.4/install.sh"
sudo ldconfig

cd $CURRENT_DIR

git clone git@github.com:berinhard/berin.git ~/sketchbook/libraries/site-packages/berin
ln -sf ~/sketchbook/libraries/site-packages/berin/ ~/src/processing-3.5.4/modes/java/libraries/berin
mv ~/src/processing.py-3056-linux64/libraries ~/src/processing.py-3056-linux64/libraries.bkp
ln -sf  ~/src/processing-3.5.4/modes/java/libraries/ ~/src/processing.py-3056-linux64/libraries

echo -e '\n>>>>>>>>>> Adding KxStudio and installing Cadence \n'
sudo apt install apt-transport-https gpgv -y
sudo dpkg --purge kxstudio-repos-gcc5
wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb
sudo dpkg -i kxstudio-repos_10.0.3_all.deb
sudo apt update
sudo apt install cadence -y
rm kxstudio-repos_10.0.3_all.deb
sudo adduser $USER audio
sudo apt install linux-image-5.4.0-56-lowlatency linux-headers-5.4.0-56-lowlatency -y

echo -e '\n>>>>>>>>>> Compiling SuperCollider and SC3 plugins \n'

cd "/home/bernardo/src/"
sudo apt-get install build-essential libsndfile1-dev libasound2-dev libavahi-client-dev libicu-dev libreadline6-dev libncurses5-dev libfftw3-dev libxt-dev libudev-dev pkg-config git cmake qt5-default qt5-qmake qttools5-dev qttools5-dev-tools qtdeclarative5-dev qtpositioning5-dev libqt5sensors5-dev libqt5opengl5-dev qtwebengine5-dev libqt5svg5-dev libqt5websockets5-dev libjack-jackd2-dev -y

#### SUPER COLLIDER BUILD
git clone --recursive https://github.com/supercollider/supercollider.git
cd "supercollider"
git submodule update --init
mkdir build && cd build
cmake -DSC_EL=OFF ..  # withouth emacs support
make -j4
sudo make install
sudo ldconfig

#### SC3_PLUGINS BUILD
cd "/home/bernardo/src/"
git clone --recursive https://github.com/supercollider/sc3-plugins.git
cd sc3-plugins
git submodule update --init
mkdir build && cd build
cmake ..  # withouth emacs support
make -j4
sudo make install
sudo ldconfig

echo -e '\n>>>>>>>>>> Check SC3 install with: {VOSIM.ar(Impulse.ar(100), 500, 3, 0.99)}.play \n'

echo -e '\n>>>>>>>>>> FoxDot + TidalCycles + flok + Pietro Bapthysthe things \n'

sudo pip3 install FoxDot
sudo apt-get install cabal-install -y
sudo cabal update
sudo cabal install tidal --lib
sudo npm install -g flok-repl flok-web
git clone git@github.com:berinhard/foxdot-berin.git ~/envs/foxdot-berin
git clone git@github.com:diegodukao/bapthysm_ideas.git ~/envs//bapthysm_ideas

cd $CURRENT_DIR

echo -e '\n>>>>>>>>>> Cloning your config_files \n'
mkdir -p ~/.config
git clone git@github.com:berinhard/config_files.git
cp config_files/.bashrc ~/.bashrc
cp config_files/.vimrc ~/.vimrc
cp config_files/.coderc ~/.coderc
cp config_files/.gitconfig ~/.gitconfig
cp config_files/.gitk ~/.gitk
cp -r config_files/.vim ~/.vim
mkdir ~/.fonts/
cp config_files/fonts/* ~/.fonts/
mkdir -p ~/.local/SuperCollider
cp ~/config_files/supercollider/* ~/.local/SuperCollider

echo -e '\n>>>>>>>>>> Configuring Vundle and install vim plugins \n'
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
sudo apt install golang-go -y
python3 ~/.vim/bundle/YouCompleteMe/install.py --all

echo -e '\n>>>>>>>>>> Configuring VSCode \n'
sudo snap install code --classic
cat ~/config_files/vscode/extesions.list | xargs -L1 code --install-extension
cp ~/config_files/vscode/settings.json ~/.config/Code/User/settings.json


echo -e '\n>>>>>>>>>> Installing and condiguring Docker \n'
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo groupadd docker
sudo usermod -aG docker $USER

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

sudo service docker restart

echo -e '\n>>>>>>>>>> Done! Enjoy :] \n'

echo 'This you might want to do do:'
echo '- Get your password.kxdx'
echo '- Install the graphics card driver, if needed'
echo '- Install foxdot quark'
echo '- Install tydal cycles quark'
echo '- Recover your custom samples from your backup'
echo '- Config VS Code'
