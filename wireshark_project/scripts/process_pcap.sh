#!/bin/bash

# path="/home/capture/test3"
path="/home/capture/03_MAR_2023-12_00-360i"

cd $path
mkdir "$path/processed"

for file in *; do
    if [ -f "$file" ]; then
        echo "Processing $file"
        tshark -r $file -T fields -e wlan.sa -e wlan.sa_resolved -e wlan.da -e wlan.da_resolved > ./processed/$file
    fi
done
