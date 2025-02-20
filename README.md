# Web Security Firewall with Flask and Bash Script

This project provides a basic framework for implementing a web security firewall using Flask and a Bash script. It demonstrates how to monitor application logs and take actions to mitigate potential security threats.

## Project Structure:

- ```app.py```: Flask application code defining routes and functionalities.
- ```web-pages/```: Directory containing HTML templates for the user interface.
- ```main.sh```: Bash script for monitoring logs and implementing security measures **(IMPORTANT: Requires modification before use).**

## How it Works:
 
1. The Flask application runs and logs user activity and application events.
2. The main.sh script periodically checks the log file (logs.txt) for suspicious activity.
3. The script can currently detect:
- Frequent 404 errors from the same IP address (indicating potential brute-force attacks).
- Failed login attempts (Note: Requires further customization to identify specific patterns).
4. Upon detecting a threat, the script can block the offending IP address using iptables (Requires root privileges).

## Important Notes:

*   This is a basic example and should be customized for your specific application and security needs.
*   The provided script requires modification before deployment:
    *   Adjust `THRESHOLD`, `BLOCK_DURATION`, and other parameters as needed in `main.sh`.
    *   **Crucially:** Ensure the IP address extraction logic in `main.sh` correctly parses your `logs.txt` file (especially for IPv6 addresses).  The script now handles more complex log lines and extracts both IPv4 and IPv6 addresses.
    *   The `iptables` and `ip6tables` rules are initially commented out.  **Uncomment them only after rigorous testing in a non-production environment.**  Be extremely careful with `iptables` and `ip6tables` rules.  Test them on a non-critical system first.
    *   The script now includes error handling for the log file (checks for existence and readability).
*   Blocking IP addresses can disrupt legitimate traffic. Use this functionality with extreme caution.
*   Security is an ongoing process. Regularly review and update your script to address new threats.  Consider using a more robust solution like `fail2ban` for production environments.

## Getting Started:

1. Clone this repository:

```Bash
git clone https://github.com/kissssu/web-security-firewall.git
```

2. Install dependencies:
```Bash
pip install Flask
```

3. Configure main.sh:
- Replace placeholder IP addresses and thresholds with your desired values.
- Follow the instructions in the script for any additional configuration.

4. Run the Flask application:
```Bash
python app.py
```

5. Run the security script in a separate terminal window (Requires root privileges):
```Bash
sudo ./main.sh
```

## Upcoming Updates (Roadmap)

*   **Integration with `fail2ban`:**  Exploring integration with `fail2ban` for more robust and feature-rich intrusion detection.
*   **More Sophisticated Threat Detection:**  Investigating methods for detecting more complex attack patterns, such as unusual request patterns or suspicious user agents.
*   **Configuration File Support:**  Moving key parameters (thresholds, block duration, etc.) to a configuration file for easier management.
*   **Email/Slack Notifications:**  Adding support for sending notifications when suspicious activity is detected.
*   **Improved Logging:**  Implementing log rotation and more detailed logging of blocked IPs and events.

## Disclaimer:

This project is for educational purposes only. The authors are not responsible for any misuse or security vulnerabilities that may arise from using this script. Users are responsible for understanding the implications and customizing the script for their specific needs.
