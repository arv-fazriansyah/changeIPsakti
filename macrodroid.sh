#!/bin/bash

while true; do
    ip_address=$(ip route | awk '/src/ && !/127.0.0.1/ && !/192.168/ && !/172\.[1-3][0-9]\./ {split($9, parts, "."); print parts[2]}')

    if [ -n "$ip_address" ]; then
        if [ "$ip_address" -ge 100 ]; then
            echo "1"
            break
        else
            echo "0"
            cmd connectivity airplane-mode enable
            sleep 5
            cmd connectivity airplane-mode disable
        fi
    fi

    sleep 5
done
