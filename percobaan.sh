#!/bin/bash

# Fungsi untuk menghidupkan mode pesawat
enable_airplane_mode() {
    echo "Menyalakan mode pesawat..."
    settings put global airplane_mode_on 1
    am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true
}

# Fungsi untuk mematikan mode pesawat
disable_airplane_mode() {
    echo "Mematikan mode pesawat..."
    settings put global airplane_mode_on 0
    am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false
}

# Mendapatkan IP dari output ip route
get_ip_address() {
    ip route | awk '/src/ {print $9}'
}

# Memisahkan bagian "A" dari alamat IP
get_ip_part_a() {
    echo $1 | awk -F'.' '{print $1}'
}

# Cek IP
ip_address=$(get_ip_address)
ip_part_a=$(get_ip_part_a $ip_address)

while [ $ip_part_a -lt 100 ]; do
    enable_airplane_mode
    sleep 5  # Tunggu 5 detik sebelum mematikan mode pesawat
    disable_airplane_mode
    echo "Menunggu sinyal muncul..."
    sleep 10  # Tunggu 10 detik untuk sinyal muncul
    ip_address=$(get_ip_address)
    ip_part_a=$(get_ip_part_a $ip_address)
done

echo "IP Address memenuhi kondisi."
