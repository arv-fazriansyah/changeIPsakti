#!/bin/bash

# Mendapatkan IP dari output ip route
ip_address=$(ip route | awk '/src/ {print $9}')
echo "IP Address: $ip_address"

# Memisahkan bagian "A" dari alamat IP
ip_part_a=$(echo $ip_address | awk -F'.' '{print $1}')

# Mengecek apakah bagian "A" dari IP tidak sama dengan 100 atau lebih
if [ $ip_part_a -lt 100 ]; then
    # Jika tidak memenuhi kondisi, jalankan mode pesawat
    echo "IP Address tidak memenuhi kondisi. Menjalankan mode pesawat..."
    # Perintah untuk menjalankan mode pesawat, gantilah dengan perintah yang sesuai di perangkat Anda
    # Misal: am start -a android.settings.AIRPLANE_MODE_SETTINGS
else
    echo "IP Address memenuhi kondisi."
fi
