
#!/bin/bash

psswd=$1

function installBasePackage(){
	packages='vim git cmake build-essential python-dev python3-dev mono-xbuild exuberant-ctags openjdk-8-jdk lib32z1 lib32ncurses5 libgcc1:i386 rpm'
	for package in $packages
	do
		sudo apt-get install -y $package
	done
}

function updatePPAforSoftware(){
	# google-chrome
	sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -

	# openjdk-7
	sudo add-apt-repository -ysu ppa:openjdk-r/ppa
	if [ $? -ne 0 ];then
		sudo add-apt-repository --remove ppa:openjdk-r/ppa
	fi

	# typora
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
	sudo add-apt-repository -y 'deb http://typora.io linux/'
	sudo apt-get update
}

function installChrome(){
	# sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/
	# wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -
	# sudo apt-get update
	sudo apt-get install -y google-chrome-stable
}

function installJava7(){
	# sudo add-apt-repository -y ppa:openjdk-r/ppa  
	# sudo apt-get update
	sudo apt-get install -y openjdk-7-jdk
}

function installAndroidStudio(){
	cd /opt 
	sudo wget https://dl.google.com/dl/android/studio/ide-zips/3.0.0.18/android-studio-ide-171.4408382-linux.zip
	sudo unzip android-studio-ide-171.4408382-linux.zip
	sudo ln -s /opt/android-studio/bin/studio.sh /usr/local/bin/studio
	sudo echo "[Desktop Entry]"> /usr/share/applications/studio.desktop
	sudo echo "Name=android studio">> /usr/share/applications/studio.desktop
	sudo echo "Exec=/opt/android-studio/bin/studio.sh">> /usr/share/applications/studio.desktop
	sudo echo "TryExec=/opt/android-studio/bin/studio.sh">> /usr/share/applications/studio.desktop
	sudo echo "Comment=Android studio">> /usr/share/applications/studio.desktop
	sudo echo "Icon=/opt/android-studio/bin/studio.png">> /usr/share/applications/studio.desktop
	sudo echo "Type=Application" >> /usr/share/applications/studio.desktop
	cd ~
}

function installTypora(){
	# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
	# sudo add-apt-repository -y 'deb http://typora.io linux/'
	sudo apt-get install -y typora
}

function initVim(){
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	git clone https://github.com/tourfield/vimrc.git ~/installvim
	mv ~/installvim/vimrc ~/.vimrc
	rm -rvf ~/installvim
	vim ~/.vimrc
	cd ~/.vim/bundle/YouCompleteMe
	python install.py --all
	cd ~
}
function testRootPermission(){
	touch /etc/mmmmmmmtestRootPermission  2>/dev/null
	if [ $? -ne 0 ];then
		read -p "Please input passwd: " psswd
	else
		return 0
	fi
	echo $psswd | sudo -S touch /etc/mmmmmmmtestRootPermission 2>/dev/null
	if [ ! -f /etc/mmmmmmmtestRootPermission ];then
		echo "please checkout you have permission."
		return 1
	fi
	sudo rm -rvf /etc/mmmmmmmtestRootPermission 2>&1 1>/dev/null
	return 0
}

function deletePPAforSoftware(){
	sudo add-apt-repository --remove ppa:someppa/ppa
}

function installMain(){
	testRootPermission
	if [ $? -ne 0 ];then
		echo "exit 0"
		exit 0
	fi
	echo "continue"
	#installBasePackage
	#updatePPAforSoftware
	#installChrome
	#installJava7
	#installAndroidStudio
	#installTypora
	#initVim
}

installMain $*
