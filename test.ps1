# This script iterates through potential drive letters to find and execute a specific file.

# Define the name of the executable you want to run.
# Make sure this file (e.g., payload.exe) is stored on the Pico's USB drive.
$executableName = "test.exe"

# Initialize a variable to store the found drive path.
$foundDrivePath = $null

# Iterate through common drive letters starting from D: up to Z:
# You might adjust this range depending on typical drive configurations you expect.
foreach ($driveLetter in "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z") {
    # Construct the potential drive path (e.g., "D:\")
    $currentDrivePath = $driveLetter + ":\"

    # Construct the full potential file path (e.g., "D:\payload.exe")
    $potentialFilePath = Join-Path $currentDrivePath $executableName

    # Check if the file exists at this path
    if (Test-Path $potentialFilePath) {
        # If the file is found, store the full path and break out of the loop
        $foundDrivePath = $potentialFilePath
        break
    }
}

# Check if the executable was found on any drive
if ($foundDrivePath) {
    # If found, execute the file using Start-Process
    # -FilePath specifies the path to the executable
    # -WindowStyle Hidden can be added if you don't want a console window to appear
    Start-Process -FilePath $foundDrivePath #-WindowStyle Hidden
} else {
    # Optional: Handle the case where the executable was not found
    # You could write to a log file, display a message box, etc.
    # For a rubber ducky, often no feedback is desired.
    Write-Host "Error: Executable '$executableName' not found on any removable drive."
}

# To keep the PowerShell window open after execution (useful for debugging), remove 'exit'
# If you want the window to close automatically, add 'exit' at the end of the command typed by the Pico.
