#!/bin/bash

change_channel() {
    local interface=${1-wlp2s0mon}
    local interval=${2-5}

    echo "Starting the change of channels on interface ${interface} each ${interval} seconds"

    local channel=0

    while true
    do

    local channel=$(expr $channel % 13)
    local channel=$(expr $channel + 1)
    iw dev $interface set channel $channel
    sleep $interval

    done
}

monitor() {
    local interface=${1-wlp2s0mon}
    local interval=${2-360} # capture each 6 minutes in a new file by default
    local folder=${3-test}

    local capture_path="/home/capture/${folder}/"

    echo "Starting monitoring and capture on interface ${interface} in folder ${capture_path} with interval"

    mkdir $capture_path

    tshark -i $interface -f "not ether broadcast" -b duration:$interval -w $capture_path
}

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

wireless_card="wlp2s0"
chanel_switch_interval=5
capture_new_file_interval=360
capture_folder="03_MAR_2023-12_00-360i"

# switch interface in monitor mode
airmon-ng start $wireless_card

monitor_card="${wireless_card}mon"

change_channel $monitor_card $chanel_switch_interval &

monitor $monitor_card $capture_new_file_interval $capture_folder

airmon-ng stop $monitor_card
