#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node.sh
#
# [] Creation Date : 11-06-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [ "$OSTYPE" == "darwin"* ]; then
	brew install node
else
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	sudo apt install -y nodejs
	sudo ln -s /usr/bin/nodejs /usr/bin/node
fi
