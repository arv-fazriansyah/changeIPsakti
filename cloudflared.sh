#!/data/data/com.termux/files/usr/bin/bash
# termux-boot
# sh /data/data/com.termux/files/usr/bin/cloudflareds start > /dev/null 2>&1 &
name=$(basename $(readlink -f $0))
token_id="YOUR_NEW_TOKEN_HERE"
tmp_dir="/data/data/com.termux/files/usr/tmp"
cmd="/data/data/com.termux/files/usr/bin/cloudflared --pidfile $HOME/$name.pid --autoupdate-freq 24h0m0s tunnel run --token $token_id"
pid_file="$tmp_dir/$name.pid"
stdout_log="$tmp_dir/$name.log"
stderr_log="$tmp_dir/$name.err"

get_pid() {
    cat "$pid_file"
}

is_running() {
    [ -f "$pid_file" ] && ps $(get_pid) > /dev/null 2>&1
}

case "$1" in
    start)
        if is_running; then
            echo "Already started"
        else
            echo "Starting $name"
            $cmd >> "$stdout_log" 2>> "$stderr_log" &
            echo $! > "$pid_file"
        fi
    ;;
    stop)
        if is_running; then
            echo -n "Stopping $name.."
            kill $(get_pid)
            for i in {1..10}
            do
                if ! is_running; then
                    break
                fi
                echo -n "."
                sleep 1
            done
            echo
            if is_running; then
                echo "Not stopped; may still be shutting down or shutdown may have failed"
                exit 1
            else
                echo "Stopped"
                if [ -f "$pid_file" ]; then
                    rm "$pid_file"
                fi
            fi
        else
            echo "Not running"
        fi
    ;;
    restart)
        $0 stop
        if is_running; then
            echo "Unable to stop, will not attempt to start"
            exit 1
        fi
        $0 start
    ;;
    status)
        if is_running; then
            echo "Running"
        else
            echo "Stopped"
            exit 1
        fi
    ;;
    *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac
exit 0
