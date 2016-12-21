# Robust Manifest Toolset
# Developed by Brandon Frostbourne @ 2017

# exit codes:
# [0] - success
# [1] - incorrect switch usage


param (
    # First we define the format type.  Format type must be either HTML or XML
    [Parameter(Mandatory=$true)]
    [ValidateSet("HTML","html","XML","xml")]
    [string]
    $format,
    
    # Next we define the location where we are probing
    [Parameter(Mandatory=$true)]
    [string]
    $srcDir,

    # Now we define the location to place the manifest.  Default is $srcDir
    [Parameter(Mandatory=$false)]
    [string]
    $dstDir = $srcDir,

    # Define the hash type if enabled
    [Parameter(Mandatory=$false)]
    [ValidateSet("md5","MD5","sha256","SHA256","sha512","SHA512")]
    [string]
    $hash,

    # Location of the log file if defined
    [Parameter(Mandatory=$false)]
    [string]
    $log,

    # Help switch
    [switch]
    $h = $false
)

# If the help switch is flipped, explain usage and exit with 0
if ($h) {
    Write-Output "`nUsage: blah blah blah`n"
    exit 0
}

# Load any external functions to the script
. .\Write-Log.ps1

# Begin the creation of the manifest
New-Item 