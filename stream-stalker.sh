#!/bin/bash

OUT=stream-stalker.csv 
ZZZ=60
TRACK_INFO="https://www.wuvt.vt.edu/playlists/latest_track"
LISTENER_INFO="http://stream.wuvt.vt.edu/status-json.xsl"

# Check if csv file already exists, and if not, create it
if [ ! -f $OUT ]; then
    echo "${OUT} does not already exist; creating a new one..."
    echo "Timestamp,DJ,Artist,Title,Album,Listeners" >> $OUT
fi

# Start looping
while true
do
    curl -s "${TRACK_INFO}" -H "Accept: application/json" -o stream.tmp
    curl -s "${LISTENER_INFO}" -o listener.tmp
    TIMESTAMP=$(date +"%Y/%m/%d %H:%M:%S")
    DJ=$(jq -r '.dj' stream.tmp)
    ARTIST=$(jq -r '.artist' stream.tmp)
    TITLE=$(jq -r '.title' stream.tmp)
    ALBUM=$(jq -r '.album' stream.tmp)
    LISTENERS=$(jq '.icestats.source | .[] | .listeners' listener.tmp | awk '{s+=$1} END {print s}')
    LINE=$TIMESTAMP,\"$DJ\",\"$ARTIST\",\"$TITLE\",\"$ALBUM\",$LISTENERS
    echo $LINE
    echo $LINE >> $OUT
    rclone copy stream-stalker.csv wuvt_team_drive:2018-2019/GM/
    sleep $ZZZ
done
