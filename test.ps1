# Version: 0.3
# FOR TESTING INSTALLS ONLY!
# THIS SCRIPT IS NOT READY FOR USE AS AN INSTALL SCRIPT

param(
     [string]$csvFile = ".\software.csv",
     [switch]$exitOnFail = $false,
     [string]$logPath = "\\ch3ll\C$\Logs",
	 [string]$computername = $env:computername
 )

$computername = $env:computername
$computerLogPathDir = "$logPath\$computername"
$computerLogPath = "$computerLogPathDir\litslog.log"
$globalLogPath = "$logPath\global-litslog.log"

# Check if the folder already exists
if (-not (Test-Path -Path $computerLogPathDir)) {
    # The folder does not exist, so create it
    New-Item -Path $computerLogPathDir -ItemType Directory
}

$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";
$total = 0;
$fail = 0;
function TestAppInstall {
    param (
        $ShortName,
        $Version,
        $Directory,
        $File
    )
    $global:total++;

    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";

    # TEST SCRIPT
    $failed = $false;
    ## DIRECTORY EXISTANCE TEST

    if (Test-Path -Path $Directory) {
        "";
    } else {
        "[$date] FAILED $ShortName $Version  on DIRECTORY TEST. $Directory does not exist ON $computername" | Out-File -FilePath $computerLogPath -Encoding "Default" -Append;
        if ($exitOnFail) {
            throw "";
        } 
        $failed = $true;
    }

    ## FILE EXISTANCE TEST

    if (Test-Path -Path $File) {
        "";
    } else {
        "[$date] FAILED $ShortName $Version  on FILE EXISTANCE TEST. $File does not exist ON $computername" | Out-File -FilePath $computerLogPath -Encoding "Default" -Append;
        if ($exitOnFail) {
            throw "";
        }
        $failed = $true;
    }


        
    ## WRITE SUCCESS TO LOG
    if ($failed) {
        $global:fail++;
    } else {
        "[$date] PASSED $ShortName $Version ON $computername" | Out-File -FilePath $computerLogPath -Encoding "Default" -Append;
    }
}



"[$date] STARTED $computername install test" | Out-File -FilePath $computerLogPath -Encoding "Default" -Append;

Import-Csv -Path $csvFile | ForEach-Object {
    TestAppInstall $_.ShortName $_.Version $_.Directory $_.File;
}

$success = $total - $fail;
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";

"[$date] $computername had $fail failures" | Out-File -FilePath $computerLogPath -Encoding "Default" -Append;
"[$date] $computername had $success successes" | Out-File -FilePath $computerLogPath -Encoding "Default" -Append;
"[$date] $computername had $total total applications tested" | Out-File -FilePath $computerLogPath -Encoding "Default" -Append;
"[$date] ENDED $computername install test" | Out-File -FilePath $computerLogPath -Encoding "Default" -Append;

if ($fail -gt 0) {
    "[$date] $computername FAILED with $fail failures of $total total software" | Out-File -FilePath $globalLogPath -Encoding "Default" -Append;
} else {
    "[$date] $computername PASSED with $success successes of $total total software" | Out-File -FilePath $globalLogPath -Encoding "Default" -Append;
}