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

1. This is a basic example and should be customized for your specific application and security needs.
2. The provided script requires modification before deployment:
- Replace placeholder IP addresses and thresholds with your desired values.
- Consider implementing additional security checks based on your application's log format.
3. Thoroughly test the script in a non-production environment before deploying it on a live server.
4. Blocking IP addresses can disrupt legitimate traffic. Use this functionality with caution.
5. Security is an ongoing process. Regularly review and update your script to address new threats.

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

## Disclaimer:

This project is for educational purposes only. The authors are not responsible for any misuse or security vulnerabilities that may arise from using this script. Users are responsible for understanding the implications and customizing the script for their specific needs.
