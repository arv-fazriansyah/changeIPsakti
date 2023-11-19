#!/data/data/com.termux/files/usr/bin/bash

# Cek apakah perangkat sudah di-root
if [ "$(id -u)" -ne 0 ]; then
    echo "Script harus dijalankan sebagai root."
    exit 1
fi

# Fungsi untuk mengecek apakah bagian kedua dari IP lebih dari atau sama dengan 100
check_ip() {
    local ip="$1"
    local second_octet

    # Extract second octet using AWK
    second_octet=$(echo "$ip" | awk -F'.' '{print $2}')

    # Check if second_octet is not empty
    if [ -n "$second_octet" ] && [ "$second_octet" -ge 100 ]; then
        return 0  # IP sesuai
    else
        return 1  # IP tidak sesuai
    fi
}

# Fungsi untuk menghidupkan dan mematikan mode pesawat
toggle_airplane_mode() {
    settings put global airplane_mode_on 1 > /dev/null
    am broadcast -a android.intent.action.AIRPLANE_MODE > /dev/null
    settings put global airplane_mode_on 0 > /dev/null
    am broadcast -a android.intent.action.AIRPLANE_MODE > /dev/null
}

# Loop untuk mencari IP yang sesuai
while true; do
    rmnet0_ip=$(ip addr show rmnet0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    
    if check_ip "$rmnet0_ip"; then
        echo "IP rmnet0: $rmnet0_ip sesuai."
        break
    else
        echo "IP rmnet0: $rmnet0_ip tidak sesuai."
        toggle_airplane_mode

        # Tunggu hingga IP muncul
        until rmnet0_ip=$(ip addr show rmnet0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'); do
            sleep 1
        done
    fi
done

echo "Selesai."
