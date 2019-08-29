#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : kubeval.sh
#
# [] Creation Date : 29-08-2019
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: kubeval"
}


kubeval-upstall() {
        message "kubectl" "Upstall kubectl from github"
	kubeval_vr=$(curl -s https://api.github.com/repos/instrumenta/kubeval/releases/latest | grep 'tag_name' | cut -d\" -f4)
        kubeval_vl=$(kubeval --version | grep Version | cut -d' ' -f2)

        if [ $kubeval_vr != $kubeval_vl ]; then
                message "kubeval" "Dowloading from github"
                sudo curl -L https://github.com/instrumenta/kubeval/releases/download/${kubeval_vr}/kubeval-$(uname -s | awk '{print tolower($0)}')-amd64.tar.gz | tar -xOf - kubeval > /usr/local/bin/kubeval
                sudo chmod +x /usr/local/bin/kubeval
        fi

        message "kubeval" "$(kubeval --version)"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        kubeval-upstall
}
