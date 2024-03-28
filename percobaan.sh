#!/data/data/com.termux/files/usr/bin/sh

# Cek apakah perangkat sudah di-root
[ "$(id -u)" -ne 0 ] && { echo "Script harus dijalankan sebagai root."; exit 1; }

# Fungsi untuk menghidupkan dan mematikan mode pesawat
toggle_airplane_mode() {
    if [ "$1" = "enable" ]; then
        cmd connectivity airplane-mode enable >/dev/null 2>&1
    elif [ "$1" = "disable" ]; then
        cmd connectivity airplane-mode disable >/dev/null 2>&1
    else
        echo "Argumen tidak valid."
    fi
}

current_ip=""

# Loop untuk memantau perubahan IP pada rmnet0
while true; do
    ip_address=$(ip route | awk '/src/ {print $9}')
    
    if [ -n "$ip_address" ] && [ "$ip_address" != "$current_ip" ]; then
        current_ip="$ip_address"

        # Memeriksa bagian kedua dari IP
        ip_part_b=$(echo $current_ip | awk -F'.' '{print $2}')
        if [ "$ip_part_b" -ge 100 ]; then
            echo "IP Address: $current_ip sesuai."
        else
            echo "IP Address: $current_ip tidak sesuai."
            toggle_airplane_mode enable
            sleep 5
            toggle_airplane_mode disable
        fi
    fi

    sleep 1
done
