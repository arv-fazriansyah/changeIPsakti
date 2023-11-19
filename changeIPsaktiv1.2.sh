#!/system/bin/sh

# Cek apakah perangkat sudah di-root
[ "$(id -u)" -ne 0 ] && { echo "Script harus dijalankan sebagai root."; exit 1; }

# Fungsi untuk mengecek apakah bagian kedua dari IP lebih dari atau sama dengan 100
check_ip() {
    ip addr show rmnet0 | awk '/inet/ { split($2, a, "."); if (a[2] >= 100) exit 0; else exit 1 }'
}

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
    rmnet0_ip=$(ip addr show rmnet0 | awk '/inet/ {print $2}' | cut -d'/' -f1)

    if [ -n "$rmnet0_ip" ] && [ "$rmnet0_ip" != "$current_ip" ]; then
        current_ip="$rmnet0_ip"

        if check_ip; then
            echo "IP rmnet0: $rmnet0_ip sesuai."
        else
            echo "IP rmnet0: $rmnet0_ip tidak sesuai."
            toggle_airplane_mode
        fi
    fi

    sleep 1
done
