# Project Factory - Attendance Tracker Setup

## What this script does
This script automatically sets up a complete workspace for the Student 
Attendance Tracker application. It creates the required folder structure, 
generates all necessary files including the attendance checker, student 
data, configuration, and log files. It welcomes the user by name, checks 
if Python3 is installed, and allows the user to update the warning and 
failure attendance thresholds. If something goes wrong mid-setup, it 
handles the interruption gracefully by archiving and cleaning up.

## How to run the script
1. Clone the repo: git clone https://github.com/swendo-ace/deploy_agent_swendo-ace.git
2. Navigate into it: cd deploy_agent_swendo-ace
3. Make it executable: chmod u+x setup_project.sh
4. Run it: ./setup_project.sh
5. Follow the prompts to name your folder and choose whether to update thresholds

## How to trigger the archive feature
While the script is running, press Ctrl+C on your keyboard after entering 
your folder name. The script will automatically bundle the incomplete 
project directory into a compressed archive file and delete the incomplete 
folder to keep your workspace clean.

Link to video explanation: https://drive.google.com/file/d/1q9l2K8UO_vTNrE0Y6roDFtAH-Z5QoNi4/view?usp=sharing
