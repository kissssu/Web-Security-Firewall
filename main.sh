#!/bin/bash

LOG_FILE="logs.txt"
THRESHOLD=5
BLOCK_DURATION=300
LAST_CHECK_POSITION=0

# Function to check for 404 errors and potential threats
check_log() {
    # Check if the log file exists and is readable
    if [ ! -f "$LOG_FILE" ]; then
        echo "ERROR: Log file '$LOG_FILE' not found." >&2  # Redirect error to stderr
        exit 1
    elif [ ! -r "$LOG_FILE" ]; then
        echo "ERROR: Log file '$LOG_FILE' is not readable." >&2
        exit 1
    fi

    # Read the log file from the last checked position
    local new_lines=$(tail -n +"$LAST_CHECK_POSITION" "$LOG_FILE")

    # Extract all IPs (both IPv4 and IPv6) for 404 errors
    local ips=()
    while IFS=' ' read -r line; do
        if [[ "$line" =~ "404" ]]; then  # Check if the line contains "404"
             for word in $line; do
                if [[ "$word" =~ ^[0-9a-fA-F:]+:[0-9a-fA-F:]+ ]]; then # IPv6 regex
                    ips+=("$word")
                elif [[ "$word" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then #IPv4 regex
                    ips+=("$word")
                fi
            done
        fi
    done <<< "$new_lines"


    # Check for frequent 404 errors from the same IP
    local ip_counts=() # Array to store counts for each IP
    for ip in "${ips[@]}"; do
        if [[ -z "${ip_counts[$ip]+_}" ]]; then # Check if the IP exists in the array
            ip_counts[$ip]=1
        else
            ((ip_counts[$ip]++))
        fi
        if [[ "${ip_counts[$ip]}" -gt "$THRESHOLD" ]]; then
            echo "WARNING: Frequent 404 errors from $ip. Blocking for $BLOCK_DURATION seconds."
            #if [[ "$ip" =~ ":" ]]; then
            #    sudo ip6tables -A INPUT -s "$ip" -j DROP
            #    (sleep "$BLOCK_DURATION"; sudo ip6tables -D INPUT -s "$ip" -j DROP) &
            #else
            #    sudo iptables -A INPUT -s "$ip" -j DROP
            #    (sleep "$BLOCK_DURATION"; sudo iptables -D INPUT -s "$ip" -j DROP) &
            #fi
        fi
    done

    # Check for potential brute-force attacks
    local failed_logins=$(grep -E 'POST /login HTTP/1.1 401' <<< "$new_lines")
    local brute_force_ips=()
    while IFS=' ' read -r ip _; do
        brute_force_ips+=("$ip")
    done <<< "$failed_logins"

    for ip in "${brute_force_ips[@]}"; do
        echo "WARNING: Potential brute-force attempt from $ip. Blocking for $BLOCK_DURATION seconds."
        #if [[ "$ip" =~ ":" ]]; then
        #    sudo ip6tables -A INPUT -s "$ip" -j DROP
        #    (sleep "$BLOCK_DURATION"; sudo ip6tables -D INPUT -s "$ip" -j DROP) &
        #else
        #    sudo iptables -A INPUT -s "$ip" -j DROP
        #    (sleep "$BLOCK_DURATION"; sudo iptables -D INPUT -s "$ip" -j DROP) &
        #fi
    done


    # Update the last checked position
    LAST_CHECK_POSITION=$(wc -l < "$LOG_FILE")
}

# Run the check every 5 seconds
while true; do
    check_log
    sleep 1
done
