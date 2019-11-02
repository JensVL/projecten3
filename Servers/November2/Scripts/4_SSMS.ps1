param(
    [string]$filepath = "C:\Users\Administrator\Desktop\SSMS-Setup-ENU.exe",
    [string]$params   = ""
)

# Set file and folder path for SSMS installer .exe
# NOTE: The variables below are declared as parameters at the top of the script
# $folderpath="C:\Users\Administrator\Desktop"
# $filepath="$folderpath\SSMS-Setup-ENU.exe"
 
# If SSMS not present, download
if (!(Test-Path $filepath)) {
    write-host "SSMS-Setup file not found."
}
else {
    write-host "Located the SQL SSMS Installer binaries, moving on to install..."
}
 
# start the SSMS installer
write-host "Beginning SSMS install..." -nonewline
Start-Process -Filepath $filepath -ArgumentList -silent -Wait
Write-Host "SSMS installation complete" -ForegroundColor Green
