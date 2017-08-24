#!/bin/bash
# setting color
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'
# Read Password
echo -n Sudo Password: 
read -s password
echo
update_repository(){
    echo $password | sudo -S apt-get update
}
# Run Command
install(){
    echo -e "${BLUE}Now installing $1...${NC}"
    # echo  "${NC}"
    typeset ret_code

    echo $password | sudo -S apt-get install $1 -y
    ret_code=$?
    if [ $ret_code != 0 ]; then
        echo -e "${RED}Error : [%d] when executing command: $1${NC}" $ret_code
        return 1
    fi
    echo -e "${GREEN}$1 Installation Success${NC}"    
    return 0

}
install_npm_package(){
    echo -e "${BLUE}Installing $1...${NC}"      
    npm install $1 $2
    echo -e "${GREEN}$1 installation success${NC}" 
}
setup_git_config(){
    echo -e "${BLUE}Setting git configuration...${NC}"
    git config --global user.name "Md. Atiqul Islam"
    git config --global user.email "atiqul.islam1589@gmail.com"
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
}

install_git(){
    typeset ret_code
    install git 
    ret_code=$?
    echo $ret_code
    if [ $ret_code -eq 0 ]; then
        setup_git_config
    fi
}

install_ruby(){
    install ruby
}

install_xclip(){
    install xclip
}

install_nvm(){
    typeset ret_code
    echo -e "${BLUE}Now installing NVM...${NC}"    
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
    $ret_code=$?
    if [ $ret_code -ne 0 ]; then
        echo -e "${RED}Error : [%d] when executing command: nvm{NC}" $ret_code
        return 1
    fi
    echo -e "${GREEN}NVM Installation Success${NC}"    
    source ~/.bashrc
    return 0
}

update_npm(){
    install_npm_package npm@latest -g
}
install_node(){
    typeset ret_code
    echo -e "${BLUE}Installing Node...${NC}"        
    nvm install node --lts
    ret_code=$?
    if [ $ret_code != 0 ]; then
        echo -e "${RED}Error : [%d] when executing command: node${NC}" $ret_code
        return 1
    fi
    echo -e "${GREEN}Node Installation Success${NC}" 
    return 0
}
install_node_package(){
    typeset ret_code
    install_nvm
    ret_code=$?
    if [ $ret_code -eq 0 ]; then
        install_node
        return 0
    fi
    ret_code=$?
    if [ $ret_code -eq 0 ]; then
        update_npm
        return 0
    fi
    return 1 
}

install_bower(){
    install_npm_package bower -g
}

install_coffee_scripts(){
    install_npm_package coffee-script -g
}

install_coffee_nonemon(){
    install_npm_package nodemon -g
}

install_pip(){
    install python-pip
}
install_virtualenv(){
    echo $password | sudo -S pip install virtualenv
}
setup_db(){
    sudo -i -u postgres  psql -c "ALTER USER postgres PASSWORD '1234';"
}
install_pg_admin(){
    rm pgadmin4-*.whl    
    rm -rf ~/.pgadmin
    rm -rf ~/pgadmin_env
    virtualenv ~/pgadmin_env
    source ~/pgadmin_env/bin/activate
    wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v1.6/pip/pgadmin4-1.6-py2.py3-none-any.whl
    pip install ./pgadmin4-1.6-py2.py3-none-any.whl
    rm pgadmin4-*.whl
    # python ~/pgadmin_env/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py
    echo "pgadmin(){\n\tsource ~/pgadmin_env/bin/activate\n\tpython ~/pgadmin_env/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py\n\tdeactivate\n}" >> ~/.zshrc
    source ~/.zshrc
    deactivate

}
install_postgresql(){
    install postgresql
    install postgresql-contrib
    setup_db 

}
install_oh_my_zsh(){
  echo $password |  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

install_zsh(){
    typeset ret_code
    install zsh
    ret_code=$?
    if [ $ret_code -eq 0 ]; then
        install_oh_my_zsh
        return 0
    fi
}
install_support_library(){
    install libffi-dev
    install libssl-dev
    install python-dev
}

install_visula_studio_code(){
    echo -e "${BLUE}Now installing Code...${NC}"    
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install code 
    echo -e "${GREEN}Code Installation Success${NC}" 

}

install_chrome(){
    install libxss1 
    install libappindicator1 
    install libindicator7
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    echo $password | sudo -S dpkg -i google-chrome*.deb
    sudo -S apt-get install -f
    rm -rf google-chrome*.deb
}

install_skype(){
    wget https://go.skype.com/skypeforlinux-64.deb
    echo $password | sudo -S dpkg -i skype*.deb
    sudo -S apt-get install -f
    rm -rf skype*.deb
}

install_java_8(){
    echo $password | sudo -S apt-add-repository ppa:webupd8team/java
    update_repository
    install oracle-java8-installer
}

#Execute commands
update_repository
install_git
install_java_8
install_ruby
install_xclip
install_node_package
install_bower
install_coffee_scripts
install_coffee_nonemon
install_pip
install_virtualenv
install_postgresql
install_pg_admin
install_support_library
install_visula_studio_code
install_chrome
install_skype
install_zsh
