#!/bin/bash
set -o allexport
source .env
set +o allexport

cd env/dist/bin
./worldserver

# while true; do 
#   ./worldserver &
#   PID=$!
#   inotifywait -e modify -e move -e create -e delete -e attrib -r ../etc -r ./
#   kill $PID
# done