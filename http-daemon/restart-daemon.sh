sudo nodejs ./node_modules/forever/bin/forever restart repositoryServer.js
sudo nodejs ./node_modules/forever/bin/forever restart hostsConfigServer.js

rm -rf hosts-config
mkdir hosts-config
source hosts-config-watcher.sh
