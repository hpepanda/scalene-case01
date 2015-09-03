#!/bin/bash

sudo apt-get install nodejs
sudo apt-get install npm
sudo npm install

sudo nodejs ./node_modules/forever/bin/forever start repositoryServer.js
sudo nodejs ./node_modules/forever/bin/forever start hostsConfigServer.js