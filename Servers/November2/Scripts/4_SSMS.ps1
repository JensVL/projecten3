# Set file and folder path for SSMS installer .exe
$folderpath="C:\Users\Administrator\Desktop\SSMS"
$filepath="$folderpath\SSMS-Setup-ENU.exe"
 
#If SSMS not present, download
if (!(Test-Path $filepath)){
write-host "SSMS-Setup file not found."
}
else {
write-host "Located the SQL SSMS Installer binaries, moving on to install..."
}
 
# start the SSMS installer
write-host "Beginning SSMS install..." -nonewline
Start-Process -Filepath $filepath -ArgumentList -silent -Wait
Write-Host "SSMS installation complete" -ForegroundColor Green
