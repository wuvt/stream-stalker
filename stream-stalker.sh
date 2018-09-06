#!/bin/env bash

OUT=stream-stalker.csv 
ZZZ=5
URL="https://www.wuvt.vt.edu/playlists/latest_track"

# Check if csv file already exists, and if not, create it
if [ ! -f $OUT ]; then
    echo "${OUT} does not already exist; creating a new one..."
    echo "Timestamp,DJ,Artist,Title,Album,Listeners" >> $OUT
fi

# Start looping
while true
do
    curl -s "${URL}" -o stream.tmp
    TIMESTAMP=$(date +"%Y/%m/%d %H:%M:%S")
    DJ=$(jq -r '.dj' stream.tmp)
    ARTIST=$(jq -r '.artist' stream.tmp)
    TITLE=$(jq -r '.title' stream.tmp)
    ALBUM=$(jq -r '.album' stream.tmp)
    LISTENERS=$(jq -r '.listeners' stream.tmp)
    LINE="${TIMESTAMP},${DJ},${ARTIST},${TITLE},${ALBUM},${LISTENERS}"
    echo $LINE
    echo $LINE >> $OUT
    sleep $ZZZ
done
