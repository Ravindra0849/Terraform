
#! /bin/bash
	sudo apt-get update -Y
	sudo apt install -y httpd
	sudo systemctl start httpd
	sudo systemctl enable https

