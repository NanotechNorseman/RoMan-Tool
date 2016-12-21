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
    $format = $( Read-Host "Please input desired format (HTML or XML): " ),
    
    # Next we define the location where we are probing
    [Parameter(Mandatory=$true)]
    [string]
    $srcDir = $( Read-Host "Please input the directory (and sub-directories) for the manifest: " ),

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
    $h = $false,

	# Force overwrite (default will re-name old)
	[switch]
	$f = $false
)

# If the help switch is flipped, explain usage and exit with 0
if ($h) {
    Write-Output "`nUsage: blah blah blah`n"
    exit 0
}

# Load any external functions to the script
. .\Write-Log.ps1

# Trim the trailing slashes from any directory entry
$srcDir.TrimEnd('/\')
$dstDir.TrimEnd('/\')

# Variable Declaration
$dtStamp = (Get-Date -Format MM-dd-yyyy_HHmmss)

# Initialization for Manifest

# Check if a previous manifest exists and check for $force flag
If (Get-ChildItem -Path $srcDir -Recurse | Where-Object { !$PsIsContainer -and [System.IO.Path]::GetFileNameWithoutExtension($_.Name) -eq "Roman-Manifest" } = $true) {
	if ($f = $true) {
		Write-Log -level WARN -message "Roman-Manifest already exists!  Renaming old manifest with current timestamp and proceeding." (&{If ($log -ne "" -or $false) {-log $log}})
		$exitName = "Roman-Manifest-$dtStamp"
		Get-ChildItem -Filter "Roman-Manifest.*" -Recurse | Rename-Item -NewName {$_.Name -replace 'Roman-Manifest',$exitName }
		}
}

# Create Manifest file with currect code
New-Item $srcDir\Roman-Manifest.$format -ItemType File

# Cycle through lines and write output to the manifest