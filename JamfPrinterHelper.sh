#!/bin/bash

# Printer Install
# Author  : hrhnick at me dot com
# Version : 1.0

# Present a GUI prompt to help a user install a printer via Jamf Self Service.

# Get User Input to select printer
printerSelection=$(osascript -e 'set printerSelection to (choose from list {"Boston", "Shrewsbury", "Hadley"} with prompt "Choose the printer you would like to add:" )')

# Set variables for printer installation
case $printerSelection in
	    Boston)
	        queueName="Boston Toshiba MFP"
	        queueAddress="smb://printserver.example.com/Boston"
	        printerLocation="Boston 31st Floor"
	        printerDriver="/Library/Printers/PPDs/Contents/Resources/TOSHIBA_ColorMFP.gz"
		;;
		Shrewsbury)
	        queueName="Shrewsbury Toshiba MFP"
	        queueAddress="smb://printserver.example.com/Shrewsbury"
	        printerLocation="Shrewsbury Computer Lab"
	        printerDriver="/Library/Printers/PPDs/Contents/Resources/TOSHIBA_ColorMFP.gz"
		;;
		Hadley)
	        queueName="Hadley Toshiba MFP"
	        queueAddress="smb://printserver.example.com/Hadley"
	        printerLocation="Hadley 2nd Floor"
	        printerDriver="/Library/Printers/PPDs/Contents/Resources/TOSHIBA_ColorMFP.gz"
	    ;;
		esac


# Call policy to install driver if not found
if [ -e "$printerDriver" ]
then 
  echo "Driver detected, continuing printer install."
else
  echo "Driver not detected, installing driver prior to printer install."
  jamf policy -trigger printerDrivers
  echo "Driver installed and detected, continuing printer install."
fi

# Install printer
lpadmin -p "$queueName" -D "$queueName" -E -v "$queueAddress" -L "$printerLocation" -m "$printerDriver" -o printer-is-shared=false


exit 0
