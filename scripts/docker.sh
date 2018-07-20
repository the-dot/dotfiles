#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : docker.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
verbose=false
install=false
docker_app=false

usage() {
	echo "usage: docker [-i] [-v] [-a]"
	echo "  -i   install and initiate docker"
	echo "  -v   verbose"
        echo "  -a   install docker app"
}

docker-repositories() {
	message "docker" "Installing tools for apt repository management"
	sudo apt-get -y update
	sudo apt-get -y install apt-transport-https ca-certificates

	message "docker" "Add new GPG key"
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	message "docker" "Add docker apt repository"
	sudo add-apt-repository -y \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"
}

docker-install() {
	message "docker" "Installing docker"
	sudo apt-get -y update
	sudo apt-get -y install docker-ce

	message "docker" "The Docker daemon starts automatically."

	message "docker" "Manage Docker as a non-root user"
	sudo groupadd docker
	sudo usermod -aG docker $USER
}

docker-configuration() {
	message "docker" "Configuring docker"
        (cat | sudo tee /etc/docker/daemon.json) << EOF
{
  "registry-mirrors": [
  ],
  "dns": ["8.8.8.8", "8.8.4.4"]
}
EOF

        message "docker" "Restarting docker service"
	sudo systemctl restart docker
}

docker-update() {
        message "docker" "Updating docker"
	sudo apt-get -y update
	sudo apt-get -y install docker-ce
}

docker-compose-upstall() {
        message "docker" "Upstall docker-compose"
	compose_vr=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
	compose_vl=$(docker-compose version --short)

	if [ "${compose_vl}" != "${compose_vr}" ]; then
		message "docker" "Installing docker-compose"
		curl -L "https://github.com/docker/compose/releases/download/${compose_vr}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		chmod +x /usr/local/bin/docker-compose
	fi
}

docker-app-install() {
	message "docker" "Installing docker-app"
        curl -L -# https://github.com/docker/app/releases/download/v0.2.0/docker-app-linux.tar.gz -o docker-app-linux.tar.gz
        tar xf docker-app-linux.tar.gz
        rm docker-app-linux.tar.gz
        mv docker-app-linux /usr/local/bin/docker-app
}


main() {
        # Reset optind between calls to getopts
        OPTIND=1
        while getopts "iva" argv; do
	        case $argv in
		        i)
			        install=true
			        ;;
		        v)
			        verbose=true
			        ;;
                        a)
                                docker_app=true
                                ;;
	        esac
        done

        if [ $docker_app = true ]; then
                message "docker" "Docker/App is in pre-release"
                docker-app-install
                exit
        fi


        if [ $have_proxy = true ]; then
	        proxy_start
        fi

        if [ $install = true ]; then
	        docker-repositories
	        docker-install
                docker-configuration
        else
	        docker-update
        fi

        docker-compose-upstall

        if [ $have_proxy = true ]; then
	        proxy_stop
        fi
}
