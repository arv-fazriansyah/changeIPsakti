#!/data/data/com.termux/files/usr/bin/sh

# Fungsi untuk menghidupkan dan mematikan mode pesawat
toggle_airplane_mode() {
    cmd connectivity airplane-mode $1 >/dev/null 2>&1
}

# Loop untuk memantau perubahan IP pada rmnet0
while true; do
    # Memeriksa alamat IP
    ip_address=$(ip route | awk '/src/ {print $9}')
    
    # Jika alamat IP tidak kosong
    if [ -n "$ip_address" ]; then
        # Memeriksa bagian kedua dari IP
        ip_part_b=$(echo "$ip_address" | cut -d '.' -f 2)
        
        # Jika bagian kedua dari IP lebih besar atau sama dengan 100
        if [ "$ip_part_b" -ge 100 ]; then
            echo "IP Address: $ip_address sesuai." >/dev/null 2>&1
        else
            echo "IP Address: $ip_address tidak sesuai." >/dev/null 2>&1
            toggle_airplane_mode enable
            sleep 5
            toggle_airplane_mode disable
        fi
    fi

    sleep 1
done
