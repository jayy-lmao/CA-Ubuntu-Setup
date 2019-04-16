#!/usr/bin/env bash

if echo "$(hostname)" = "CAVD"
then
    USER='vagrant'
fi

#######################################################################
printf 'Setting up base dependencies\n - zsh\n - git\n - build-essential\n - libssl-dev'
#########################################################################
{
printf 'Installing base dependencies'

sudo apt-get -y install zsh git build-essential libssl-dev
} &> .vagrant-log

if echo "$USER" = vagrant
then
    #############################
    echo "Installing Oh My Zsh"
    #############################
    {
    echo "Installing Oh My Zsh"

    ZSH=/home/$USER/.oh-my-zsh
    env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH"
    cp "$ZSH"/templates/zshrc.zsh-template /home/$USER/.zshrc
    sed "/^export ZSH=/ c\\
    export ZSH=\"$ZSH\"
    " /home/$USER/.zshrc > /home/$USER/.zshrc-omztemp
    mv -f /home/$USER/.zshrc-omztemp /home/$USER/.zshrc
    sudo chown -R $USER $ZSH
    usermod --shell /bin/zsh $USER
    sed -i 's/robbyrussell/dpoggi/' /home/$USER/.zshrc
    } &> .vagrant-log
fi

###################################
echo "Installing Create React App"
###################################
{
echo "Installing Create React App"

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install create-react-app -g
chown -R $USER /usr/lib/node_modules
} &> .vagrant-log


###########################
echo "Installing Postgresql"
###########################
{
echo "Installing Postgresql"

sudo apt-get -y install postgresql postgresql-contrib libpq-dev
sudo -u postgres psql -c "CREATE ROLE $USER WITH LOGIN PASSWORD '$USER' SUPERUSER;"
} &> .vagrant-log

###############################
echo "Installing Ruby on Rails"
###############################
{
echo "Installing Ruby on Rails Development environment"

sudo apt-get install ruby ruby-dev -y
gem install rails
gem install bundler
gem install pg
gem install json

sudo chown -R $USER /usr/local/rvm/gems
sudo chown -R $USER /var/lib/gems/
} &> .vagrant-log


#########################
echo "Installing MongoDB"
#########################
{
echo "Installing MongoDB"

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
} &> .vagrant-log



echo -e "\e[32mDone"

