while true; do
  change=$(inotifywait -e close_write ./http-daemon/hosts-config/)
  change=${change#./http-daemon/hosts-config/ * }
  if [ "$change" = "hosts-config.ini" ]; then ./case-1-deploy.sh; fi
done