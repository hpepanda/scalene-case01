sudo nodejs ./node_modules/forever/bin/forever stop repositoryServer.js
sudo nodejs ./node_modules/forever/bin/forever stop hostsConfigServer.js

rm -rf hosts-config
