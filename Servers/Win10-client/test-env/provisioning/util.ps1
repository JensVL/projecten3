# Utility functions that are useful in all provisioning scripts.

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Set to 'yes' if debug messages should be printed.
New-Variable -Name debug_output -Value "yes" -Option Constant

#------------------------------------------------------------------------------
# Sourcing
#------------------------------------------------------------------------------
Add-Type -AssemblyName System.IO.Compression.FileSystem

#------------------------------------------------------------------------------
# Logging and debug output
#------------------------------------------------------------------------------

# Usage: info [-info_text] [ARG]
#
# Prints argument on the standard output stream
Function info() {
    param([string]$info_text)

    Write-Host $info_text
}

# Usage: debug [-debug_text] [ARG]
#
# Prints all arguments on the standard error stream
Function debug() {
    param([string]$debug_text)

    if ( $debug_output -eq "yes" ) {
        Write-Host $debug_text
    }
}

# Usage: error [-error_text] [ARG]
#
# Prints all arguments on the standard error stream
Function error() {
    param([string]$error_text)

    Write-Error $error_text
}

#------------------------------------------------------------------------------
# Helper functions
#------------------------------------------------------------------------------
# Usage: unzip [-zipfile] <c:\foo\bar> [-outpath] <c:\foo\bar>
#
# creates unzip function so we can unzip the downloaded zipped powershell file
function unzip {
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

# Usage: zip [-zipfile] <c:\foo\bar> [-outpath] <c:\foo\bar>
#
# creates zip function so we can zip the files
function zip {
    Param([string]$zipfile, [string]$outpath)
    $compress = @{
        Path             = $zipfile
        CompressionLevel = "Optimal"
        DestinationPath  = $outpath
    }
    Compress-Archive @compress
}

# Usage: ensure_download_path [-downloadpath] <c:\foo\bar>
#
# Ensures the folder exists where the downloaded installation files are stored
function ensure_download_path() {
    param([string]$downloadpath)

    if ($downloadpath.EndsWith("\")) {
        $computerName.Remove($computerName.LastIndexOf("\"))
    }

    if (!(Test-Path $downloadpath)) {
        mkdir $downloadpath
    }
}
