#!/bin/bash


lat1=$(awk -F',' 'NR==1{print $3}' titik-penting.txt)
lon1=$(awk -F',' 'NR==1{print $4}' titik-penting.txt)
lat3=$(awk -F',' 'NR==3{print $3}' titik-penting.txt)
lon3=$(awk -F',' 'NR==3{print $4}' titik-penting.txt)


lat_tengah=$(echo "scale=6; ($lat1 + $lat3) / 2" | bc)
lon_tengah=$(echo "scale=6; ($lon1 + $lon3) / 2" | bc)

echo "Koordinat pusat: $lat_tengah, $lon_tengah"
echo "$lat_tengah,$lon_tengah" > posisipusaka.txt
