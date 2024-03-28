#!/bin/bash

# Mendapatkan IP dari output ip route
ip_address=$(ip route | awk '/src/ {print $9}')
echo "IP Address: $ip_address"

# Memisahkan bagian "A" dari alamat IP
ip_part_a=$(echo $ip_address | awk -F'.' '{print $1}')

# Cek apakah bagian "A" dari IP tidak sama dengan 100 atau lebih
while [ $ip_part_a -lt 100 ]; do
    echo "IP Address tidak memenuhi kondisi. Menjalankan mode pesawat..."
    # Mengaktifkan mode pesawat
    settings put global airplane_mode_on 1
    am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true
    sleep 10  # Tunggu 10 detik sebelum memeriksa IP lagi
    # Mendapatkan IP lagi
    ip_address=$(ip route | awk '/src/ {print $9}')
    echo "IP Address: $ip_address"
    ip_part_a=$(echo $ip_address | awk -F'.' '{print $1}')
done

echo "IP Address memenuhi kondisi."
