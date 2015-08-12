#!/bin/bash

SERVER_CONFIG="{\"dir\": \"$1\",\"port\": \"$2\"}"

sudo apt-get install nodejs
sudo apt-get install npm
sudo npm install forever
sudo npm install connect
sudo npm install serve-static

echo $SERVER_CONFIG | sudo tee ./config.json

sudo nodejs ./node_modules/forever/bin/forever start server.js