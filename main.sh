#!/bin/bash

LOG_FILE="logs.txt"
THRESHOLD=5
BLOCK_DURATION=300
LAST_CHECK_POSITION=0

# Function to check for 404 errors and potential threats
check_log() {
  # Read the log file from the last checked position
  local new_lines=$(tail -n +"$LAST_CHECK_POSITION" "$LOG_FILE")

  # Extract 404 errors and their corresponding IPs
  local errors=$(grep -E '404 ' <<< "$new_lines")
  local ips=()
  while IFS=' ' read -r ip _; do
    ips+=("$ip")
  done <<< "$errors"

  # Check for frequent 404 errors from the same IP
  for ip in "${ips[@]}"; do
    local count=$(grep -c "$ip" <<< "$errors")
    if [ "$count" -gt "$THRESHOLD" ]; then
      echo "WARNING: Frequent 404 errors from $ip. Blocking for $BLOCK_DURATION seconds."
    #   sudo iptables -A INPUT -s "$ip" -j DROP
    #   (sleep "$BLOCK_DURATION"; sudo iptables -D INPUT -s "$ip" -j DROP) &
    fi
  done

  # Process IPv6 addresses
  for ipv6 in $ipv6s; do
    # ... (IPv6 logic, using ip6tables)
    echo "Checking IPv6: $ipv6" # Debugging
    count=$(grep -c "$ipv6" <<< "$errors")
    if [ "$count" -gt "$THRESHOLD" ]; then
         echo "WARNING: Frequent 404 errors from IPv6: $ipv6. Blocking for $BLOCK_DURATION seconds."
        #   sudo ip6tables -A INPUT -s "$ipv6" -j DROP
        #   (sleep "$BLOCK_DURATION"; sudo ip6tables -D INPUT -s "$ipv6" -j DROP) &
    fi
  done

  # Check for potential brute-force attacks
  local failed_logins=$(grep -E 'POST /login HTTP/1.1 401' <<< "$new_lines")
  while IFS=' ' read -r ip _; do
    if [ ! -z "$ip" ]; then
      echo "WARNING: Potential brute-force attempt from $ip. Blocking for $BLOCK_DURATION seconds."
    #   sudo iptables -A INPUT -s "$ip" -j DROP
    #   (sleep "$BLOCK_DURATION"; sudo iptables -D INPUT -s "$ip" -j DROP) &
    fi
  done <<< "$failed_logins"

  # Update the last checked position
  LAST_CHECK_POSITION=$(wc -l < "$LOG_FILE") 
}

# Run the check every 5 seconds
while true; do
  check_log
  sleep 1
done
