# Version: 0.2
# FOR TESTING INSTALLS ONLY!
# THIS SCRIPT IS NOT READY FOR USE AS AN INSTALL SCRIPT

param(
     [string]$csvFile = ".\software.csv",
     [switch]$exitOnFail = $false,
     [string]$logPath = "\\labs-mdt\log$"
 )

function TestAppInstall {

    param (
        $ShortName,
        $Version,
        $Directory,
        $File
    )

    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";

    # TEST SCRIPT
    $failed = $false;
    ## DIRECTORY EXISTANCE TEST

    if (Test-Path -Path $Directory) {
        "";
    } else {
        "[$date] $ShortName $Version FAILED on DIRECTORY TEST. $Directory does not exist" | Out-File -FilePath "$logPath\$env:computername\litslog.log" -Encoding "Default" -Append;
        if ($exitOnFail) {
            throw "";
        } 
        $failed = $true;
    }

    ## FILE EXISTANCE TEST

    if (Test-Path -Path $File) {
        "";
    } else {
        "[$date] $ShortName $Version FAILED on FILE EXISTANCE TEST. $File does not exist" | Out-File -FilePath "$logPath\$env:computername\litslog.log" -Encoding "Default" -Append;
        if ($exitOnFail) {
            throw "";
        }
        $failed = $true;
    }


        
    ## WRITE SUCCESS TO LOG
    if (!$failed) {
        "[$date] $ShortName $Version PASSED" | Out-File -FilePath "$logPath\$env:computername\litslog.log" -Encoding "Default" -Append;
    }
}



Import-Csv -Path $csvFile | foreach {
    TestAppInstall $_.ShortName $_.Version $_.Directory $_.File;
}