#!/bin/bash

case $1 in
  start)
    echo "starting the server"
    ./node_modules/coffee-script/bin/coffee app.coffee > run.log 2>&1 &
    echo "done."
    ;;
  stop)
    echo "stop the server"
    kill -9 `ps aux | grep -i node | grep -i app.coffee | awk '{ print $2}'`
    echo "done."
    ;;
  ?|help|'')
    echo "useage: "
    echo "  $0 start"
    echo "  $0 stop"
    ;;

esac
