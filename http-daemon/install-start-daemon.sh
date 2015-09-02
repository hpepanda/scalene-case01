#!/bin/bash

SERVER_CONFIG="{\"dir\": \"$1\",\"port\": \"$2\"}"

sudo apt-get install nodejs
sudo apt-get install npm
sudo npm install

echo $SERVER_CONFIG | sudo tee ./config.json

sudo nodejs ./node_modules/forever/bin/forever start repositoryServer.js
sudo nodejs ./node_modules/forever/bin/forever start hostsConfigServer.js