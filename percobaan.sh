#!/data/data/com.termux/files/usr/bin/sh

# Cek apakah perangkat sudah di-root
[ "$(id -u)" -ne 0 ] && { echo "Script harus dijalankan sebagai root."; exit 1; }

# Fungsi untuk menghidupkan dan mematikan mode pesawat
toggle_airplane_mode() {
    settings put global airplane_mode_on 1 >/dev/null 2>&1
    am broadcast -a android.intent.action.AIRPLANE_MODE >/dev/null 2>&1
    settings put global airplane_mode_on 0 >/dev/null 2>&1
    am broadcast -a android.intent.action.AIRPLANE_MODE >/dev/null 2>&1
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
            toggle_airplane_mode
        fi
    fi

    sleep 1
done
