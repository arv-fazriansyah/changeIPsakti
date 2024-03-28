#!/bin/bash

# Periksa apakah pengguna adalah root atau tidak
if [ $(id -u) -eq 0 ]; then
    echo "User adalah root. Mode pesawat akan diaktifkan secara otomatis dan dimatikan setelah menemukan IP 100."
    
    # Aktifkan mode pesawat secara otomatis
    # Perintah untuk mengaktifkan mode pesawat, gantilah dengan perintah yang sesuai di perangkat Anda
    # Misal: am start -a android.settings.AIRPLANE_MODE_SETTINGS
    echo "Aktifkan mode pesawat..."
    # am start -a android.settings.AIRPLANE_MODE_SETTINGS

    # Looping untuk menunggu hingga IP mencapai 100
    while :
    do
        ip_address=$(ip route | awk '/src/ {print $9}')
        ip_part_a=$(echo $ip_address | awk -F'.' '{print $1}')

        if [ $ip_part_a -ge 100 ]; then
            # Matikan mode pesawat ketika IP mencapai 100
            # Perintah untuk mematikan mode pesawat, gantilah dengan perintah yang sesuai di perangkat Anda
            # Misal: am start -a android.settings.AIRPLANE_MODE_SETTINGS
            echo "IP mencapai 100. Matikan mode pesawat..."
            # am start -a android.settings.AIRPLANE_MODE_SETTINGS
            break
        fi
        sleep 1
    done

else
    echo "User bukan root. Mode pesawat akan diaktifkan secara manual."
    
    # Perintah untuk meminta pengguna mengaktifkan mode pesawat secara manual
    echo "Silakan aktifkan mode pesawat secara manual."
fi
