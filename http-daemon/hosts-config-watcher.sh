while true; do
  change=$(inotifywait -e close_write ./hosts-config/)
  change=${change#./hosts-config/ * }
  if [ "$change" = "hosts-config.ini" ]; then source ../case-1-deploy.sh; fi
done
