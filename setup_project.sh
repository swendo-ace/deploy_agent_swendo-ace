#!/bin/bash
echo "Welcome to the attendance_tracker!"
read -p "What would you like to name your folder? " foldername
echo "Hello, $foldername!"
mkdir -p "attendance_tracker_$foldername" "attendance_tracker_$foldername/Helpers" "attendance_tracker_$foldername/reports"
