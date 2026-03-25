#!/bin/bash

awk '
/"id"/ { gsub(/.*"id": "|",.*/, "", $0); id=$0; gsub(/^[ \t]+|[ \t]+$/, "", id) }
/"site_name"/ { gsub(/.*"site_name": "|",.*/, "", $0); name=$0; gsub(/^[ \t]+|[ \t]+$/, "", name) }
/"latitude"/ { gsub(/.*"latitude": |,.*/, "", $0); lat=$0; gsub(/^[ \t]+|[ \t]+$/, "", lat) }
/"longitude"/ && !/coordinates/ { gsub(/.*"longitude": |,.*/, "", $0); lon=$0; gsub(/^[ \t]+|[ \t]+$/, "", lon); print id","name","lat","lon }
' gsxtrack.json > titik-penting.txt

cat titik-penting.txt
