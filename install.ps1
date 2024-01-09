# LUIS
# Version: 0.2
# FOR TESTING INSTALLS ONLY!
# THIS SCRIPT IS NOT READY FOR USE AS AN INSTALL SCRIPT

$shortname = "";
$version = "";

# Vars for tests
$installedDir = "C:\Program Files\7-Zip";
$exeThatShouldExist = "C:\Program Files\7-Zip\7z.exe";
$exitAfterFailedTest = $false;  #Default is $true


# Vars for logs
$logPath = "\\labs-mdt\log$";
$computerName = $env:computername;

$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";



##########


# PASTE AN INSTALL SCRIPT HERE!


##########

# TEST SCRIPT
$failed = $false;
## DIRECTORY EXISTANCE TEST

if (Test-Path -Path $installedDir) {
    "DIRECTORY EXISTANCE TEST";
} else {
    "[$date] $shortname $version FAILED on DIRECTORY TEST. $installedDir does not exist" | Out-File -FilePath "$logPath\$computerName\luislog.log" -Encoding "Default" -Append;
    if ($exitAfterFailedTest) {
        throw "";
    } 
    $failed = $true;
}

## FILE EXISTANCE TEST

if (Test-Path -Path $exeThatShouldExist) {
    "FILE EXISTANCE TEST";
} else {
    "[$date] $shortname $version FAILED on FILE EXISTANCE TEST. $exeThatShouldExist does not exist" | Out-File -FilePath "$logPath\$computerName\luislog.log" -Encoding "Default" -Append;
    if ($exitAfterFailedTest) {
        throw "";
    }
    $failed = $true;
}
if ($failed) {
    throw "";
}
    
## WRITE SUCCESS TO LOG
"[$date] $shortname $version PASSED" | Out-File -FilePath "$logPath\$computerName\luislog.log" -Encoding "Default" -Append;