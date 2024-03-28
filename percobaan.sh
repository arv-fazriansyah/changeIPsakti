#!/bin/bash

# Fungsi untuk menunggu hingga sinyal muncul
wait_for_signal() {
    echo "Menunggu hingga sinyal muncul..."
    while ! ping -c 1 google.com &>/dev/null; do
        sleep 1
    done
    echo "Sinyal ditemukan."
}

# Mendapatkan IP dari output ip route
get_ip_address() {
    ip route | awk '/src/ {print $9}'
}

# Memeriksa IP dan mengaktifkan mode pesawat jika IP tidak 100
check_and_toggle_airplane_mode() {
    local ip_address=$(get_ip_address)
    local ip_part_a=$(echo $ip_address | awk -F'.' '{print $1}')

    if [ $ip_part_a -lt 100 ]; then
        echo "IP Address tidak memenuhi kondisi. Menjalankan mode pesawat..."
        settings put global airplane_mode_on 1
        am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true
        sleep 5  # Tunggu 5 detik sebelum mematikan mode pesawat
        settings put global airplane_mode_on 0
        am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false
        wait_for_signal
    else
        echo "IP Address memenuhi kondisi."
    fi
}

# Alur utama
while true; do
    check_and_toggle_airplane_mode
    sleep 10  # Tunggu 10 detik sebelum memeriksa IP lagi
done
