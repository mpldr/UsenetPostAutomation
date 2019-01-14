#!/bin/bash

installmode="none";

command -v pacman > /dev/null;
if [ $? -eq 0 ]; then
    echo "Pacman found. Will be used for installation.";
    installmode="pacman";
else
    command -v apt-get > /dev/null;
    if [ $? -eq 0 ]; then
	    echo "apt-get found. Will be used for installation.";
	    installmode="apt";
	else
	    echo "neither pacman nor apt were found.";
	    echo "It seems as if you need to install the helper manually. See INSTALL.md for instructions.";
	    exit 1;
	fi
fi

if [[ $installmode == "pacman" ]]; then
	sudo echo "in case sudo is required in one of the following steps..." > /dev/null;
	echo "Checking requirements:"
	echo -n "git..........."
	pacman -Q | grep ^git > /dev/null
	if [[ $? -eq 0 ]]; then
		echo "found";
	else
		sudo pacman -S git --noconfirm >> ./install.log;
		if [[ $? -eq 0 ]]; then
			echo "installed";
		else
			echo "failed";
			echo "Unable to install git. Please see ./install.log for output";
			exit 2;
		fi
	fi

	installrar="false";
	echo -n "rar..........."
	pacman -Q | grep ^rar > /dev/null
	if [[ $? -eq 0 ]]; then
		echo "found";
	else
		echo "not found";
		installrar="true"
	fi

	echo -n "wget..........";
	pacman -Ql | grep ^wget > /dev/null
	if [[ $? -eq 0 ]]; then
		echo "found";
	else
		sudo pacman -S wget --noconfirm >> ./install.log;
		if [[ $? -eq 0 ]]; then
			echo "installed";
		else
			echo "failed";
			echo "Unable to install wget. Please see ./install.log for output";
			exit 2;
		fi
	fi

	echo -n "par2cmdline..."
	pacman -Ql | grep ^par2cmdline > /dev/null
	if [[ $? -eq 0 ]]; then
		echo "found";
	else
		sudo pacman -S par2cmdline --noconfirm >> ./install.log;
		if [[ $? -eq 0 ]]; then
			echo "installed";
		else
			echo "failed";
			echo "Unable to install par2cmdline. Please see ./install.log for output";
			exit 3;
		fi
	fi
	
	echo -n "php..........."
	pacman -Ql | grep ^php > /dev/null
	if [[ $? -eq 0 ]]; then
		echo "found";
	else
		sudo pacman -S php --noconfirm >> ./install.log;
		if [[ $? -eq 0 ]]; then
			echo "installed";
		else
			echo "failed";
			echo "Unable to install git. Please see ./install.log for output";
			exit 4;
		fi
	fi
	
	echo -n "pwgen........."
	pacman -Ql | grep ^pwgen > /dev/null
	if [[ $? -eq 0 ]]; then
		echo "found";
	else
		sudo pacman -S pwgen --noconfirm >> ./install.log;
		if [[ $? -eq 0 ]]; then
			echo "installed";
		else
			echo "failed";
			echo "Unable to install pwgen. Please see ./install.log for output";
			exit 5;
		fi
	fi
	
	installnyuu="false";
	echo -n "nyuu..........";
	command -v nyuu > /dev/null;
	if [[ $? == 0 ]]; then
		echo "found";
	else
		echo "missing";
		installnyuu="true";
	fi

	if [[ $installnyuu == "true" ]]; then
		echo -n "nodejs........"
		pacman -Ql | grep ^nodejs > /dev/null
		if [[ $? -eq 0 ]]; then
			echo "found";
		else
			sudo pacman -S nodejs --noconfirm >> ./install.log;
			if [[ $? -eq 0 ]]; then
				echo "installed";
			else
				echo "failed";
				echo "Unable to install nodejs. Please see ./install.log for output";
				exit 9;
			fi
		fi

	fi

	if [[ $installrar == "true" ]]; then
		echo "Installation of rar requires an AUR-Client";

		aurclient="none";

		command -v yay > /dev/null
		if [[ $? == 0 ]]; then
			echo "yay found. Will be used for installation.";
			aurclient="yay";
		fi

		command -v yaourt > /dev/null
		if [[ $? == 0 ]]; then
			echo "yaourt found. Will be used for installation.";
			echo "yaourt is no longer maintained. Consider switching to yay using \"yaourt -S yay && sudo pacman -R yaourt\"";
			aurclient="yaourt";
		fi

		if [[ $aurclient == "none" ]]; then
			echo "No supported AUR-Client found.";
			echo -n "Installing yay..."
			git clone https://aur.archlinux.org/yay.git >> ./install.log 2>> ./install.log;
			cd yay;
			makepkg -si --noconfirm >> ./install.log 2>> ./install.log;
			cd ..;
			rm -rf yay >> ./install.log;

			command -v yay > /dev/null;
			if [[ $? == 0 ]]; then
				echo "success";
			else
				echo "failed";
				echo "Error installing yay. See ./install.log for more information.";
				exit 6;
			fi

		fi

		pacman -Q | grep ^unrar > /dev/null;
		if [[ $? == 0 ]]; then
			echo "unrar found.";
			echo -n "removing..."
			
			sudo pacman -Rdd unrar --noconfirm >> ./install.log
			if [[ $? == 0 ]]; then
				echo "success";
			else
				echo "failed";
				echo "unable to remove unrar";
				exit 7;
			fi
		fi

		echo -n "Installing rar...";
		yay -S rar --noconfirm >> ./install.log 2>> ./install.log;
		if [[ $? == 0 ]]; then
			echo "success";
		else
			echo "failed";
			echo "Installation of rar failed"
			exit 8;
		fi
	fi

	echo "";
	echo "Everything will be installed to: ~/.bin/upa";
	mkdir -p ~/.bin/upa >> ./install.log
	if [[ $? != 0 ]]; then
		echo "Unable to create Path ~/.bin/upa";
		exit 10;
	fi

	originalfolder=$(pwd);
	cd ~/.bin/upa/

	if [[ $installnyuu == "true" ]]; then
		sudo rm -rf Nyuu;
		echo -n "Cloning nyuu..............";
		git clone https://github.com/animetosho/Nyuu.git >> $originalfolder/install.log 1>> $originalfolder/install.log 2>> $originalfolder/install.log
		if [[ $? -eq 0 ]]; then
			echo "successful";
			cd Nyuu;

			echo -n "Checking for npm..........";
			pacman -Q | grep ^git > /dev/null
			if [[ $? -eq 0 ]]; then
				echo "found";
			else
				sudo pacman -S git --noconfirm >> ./install.log;
				if [[ $? -eq 0 ]]; then
					echo "installed";
				else
					echo "failed";
					echo "Unable to install npm. Please see ./install.log for output";
					exit 12;
				fi
			fi

			echo -n "installing dependencies..."
			npm install >> $originalfolder/install.log 1>> $originalfolder/install.log 2>> $originalfolder/install.log;
			if [[ $? == 0 ]]; then
				echo "success"

				sudo ln -s ~/.bin/upa/Nyuu/bin/nyuu.js /usr/bin/nyuu
				sudo chmod a+x bin/nyuu.js

				command -v nyuu > /dev/null
				if [[ $? == 0 ]]; then
					echo "nyuu installation was successful"
				else
					echo "nyuu installation failed. Please ensure that nyuu is available before running this installer again.";
					exit 14
				fi
			else
				echo "failed";
				echo "Unable to install nyuu dependencies. Please try installing it manually."
				exit 14;
			fi
		else
			echo "failed";
			echo "Unable to clone nyuu. Please see ./install.log for information";
			exit 11;
		fi

	fi


fi