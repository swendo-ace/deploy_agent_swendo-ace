#!/bin/bash

trap_handler() {
    echo "Interrupt received! Archiving and cleaning up..."
    tar -czf "attendance_tracker_${foldername}_archive.tar.gz" "attendance_tracker_$foldername"
    rm -rf "attendance_tracker_$foldername"
    echo "Archive created and incomplete directory deleted. Exiting."
    exit 1
}

trap trap_handler SIGINT

echo "Welcome to the attendance_tracker!"
read -p "What would you like to name your folder? " foldername
echo "Hello, $foldername!"
mkdir -p "attendance_tracker_$foldername" "attendance_tracker_$foldername/Helpers" "attendance_tracker_$foldername/reports"
cat > "attendance_tracker_$foldername/Helpers/config.json" << 'INNEREOF'
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
INNEREOF
cat > "attendance_tracker_$foldername/Helpers/assets.csv" << 'INNEREOF'
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
INNEREOF
cat > "attendance_tracker_$foldername/reports/reports.log" << 'INNEREOF'
--- Attendance Report Run: 2026-02-06 18:10:01.468726 ---
[2026-02-06 18:10:01.469363] ALERT SENT TO bob@example.com: URGENT: Bob Smith, your attendance is 46.7%. You will fail this class.
[2026-02-06 18:10:01.469424] ALERT SENT TO charlie@example.com: URGENT: Charlie Davis, your attendance is 26.7%. You will fail this class.
INNEREOF
cat > "attendance_tracker_$foldername/attendance_checker.py" << 'INNEREOF'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])
            attendance_pct = (attended / total_sessions) * 100
            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
INNEREOF
if command -v python3 &> /dev/null
then
    echo "python3 is installed - Health Check Passed!"
else
    echo "WARNING: python3 is not installed. Please install it before running the attendance checker."
fi
read -p "Do you want to update the attendance thresholds? (yes/no): " update_choice
if [ "$update_choice" = "yes" ]
then
    read -p "Enter new Warning threshold (default 75): " warning_val
    read -p "Enter new Failure threshold (default 50): " failure_val
    sed -i "s/\"warning\": [0-9]*/\"warning\": $warning_val/" "attendance_tracker_$foldername/Helpers/config.json"
    sed -i "s/\"failure\": [0-9]*/\"failure\": $failure_val/" "attendance_tracker_$foldername/Helpers/config.json"
    echo "Thresholds updated successfully!"
fi
echo "Setup complete! Your project is ready at attendance_tracker_$foldername"
