#!/bin/bash

#Install dependencies
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa 
sudo apt install -y python3.7 
sudo apt install -y python3.7-venv
sudo apt install -y build-essential
sudo apt install -y libmysqlclient-dev
sudo apt install -y python3.7-dev

#Create a virtual environment and run code to deploy application
python3.7 -m venv test
source test/bin/activate
git clone https://github.com/nalDaniels/TerraformDeployment6.git
cd TerraformDeployment6
pip install pip --upgrade
pip install -r requirements.txt
pip install gunicorn
pip install mysqlclient
python database.py
python load_data.py 
python -m gunicorn app:app -b 0.0.0.0 -D
