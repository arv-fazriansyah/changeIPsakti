#!/system/bin/sh

# Cek apakah perangkat sudah di-root
[ "$(id -u)" -ne 0 ] && { echo "Script harus dijalankan sebagai root."; exit 1; }

# Fungsi untuk mengecek apakah bagian kedua dari IP lebih dari atau sama dengan 100
check_ip() {
    local second_octet=$(ip addr show rmnet0 | awk '/inet/ {print $2}' | cut -d'.' -f2)
    [ -n "$second_octet" ] && [ "$second_octet" -ge 100 ]
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
    rmnet0_ip=$(ip addr show rmnet0 | awk '/inet/ {print $2}' | cut -d'/' -f1)
    
    if [ -n "$rmnet0_ip" ]; then
        if check_ip "$rmnet0_ip"; then
            echo "IP rmnet0: $rmnet0_ip sesuai." > /dev/null
            break
        else
            echo "IP rmnet0: $rmnet0_ip tidak sesuai." > /dev/null
            toggle_airplane_mode
        fi
    fi

    # Tunggu hingga IP muncul
    while [ -z "$rmnet0_ip" ]; do
        rmnet0_ip=$(ip addr show rmnet0 | awk '/inet/ {print $2}' | cut -d'/' -f1)
    done
done

echo "Selesai." > /dev/null
