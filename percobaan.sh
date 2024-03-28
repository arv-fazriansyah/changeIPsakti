#!/bin/bash

# Fungsi untuk mengaktifkan mode pesawat secara manual
activate_airplane_mode_manually() {
    echo "Silakan aktifkan mode pesawat secara manual."
}

# Fungsi untuk memeriksa IP sampai mencapai 100
check_ip_until_100() {
    echo "Menunggu hingga IP mencapai 100..."
    while :
    do
        ip_address=$(ip route | awk '/src/ {print $9}')
        ip_part_a=$(echo $ip_address | awk -F'.' '{print $1}')

        if [ $ip_part_a -ge 100 ]; then
            echo "IP mencapai 100. Keluar dari loop."
            break
        fi
        sleep 1
    done
}

# Periksa apakah pengguna adalah root atau tidak
if [ $(id -u) -eq 0 ]; then
    echo "User adalah root. Mode pesawat akan diaktifkan secara otomatis dan dimatikan setelah menemukan IP 100."
    
    # Aktifkan mode pesawat secara otomatis
    echo "Aktifkan mode pesawat..."
    adb shell settings put global airplane_mode_on 1
    adb shell am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true

    # Memeriksa IP sampai mencapai 100
    check_ip_until_100

    # Matikan mode pesawat ketika IP mencapai 100
    echo "Matikan mode pesawat..."
    adb shell settings put global airplane_mode_on 0
    adb shell am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false

else
    echo "User bukan root. Mode pesawat akan diaktifkan secara manual."
    activate_airplane_mode_manually
    
    # Memeriksa IP sampai mencapai 100
    check_ip_until_100
fi
