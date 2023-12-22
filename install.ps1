## LUIS (Labs Unified Install Script)
## CURRENT VERSION: 0.1.1
#
#   CHANGE LOG
#
# Version 0.1 (2023-12-22)
# - Script is able to install MSI, exe and from a copied existing script
# - Will throw an error for paths that don't exist but nothing more
#
# Version 0.1.1 (2023-12-22)
# - Added Log Output!

$shortname = "";
$verison = "";
$installer_path = "";
$installer_argumments = "";
$is_msi_install = $false;
# IF YOU COPY FROM AN EXISTING SCRIPT SET THIS TO $true AND is_msi_install to $false
$install_script = $false;

# Vars for tests
$installed_dir = "";
$exe_that_should_exist = "";

$tsenv = New-Object -ComObject Microsoft.SMS.TSEnvironment;
# Query the environment to get an existing variable
# Set a variable for the task sequence log path
$LogPath = $tsenv.Value("_SMSTSLogPath");
# Write a message to a log file
Write-Output "Hello world!" | Out-File -FilePath "$LogPath\mylog.log" -Encoding "Default" -Append;







# INSTALL PROGRAM

## MSI INSTALL
if ($is_msi_install) {
    Start-Process msiexec "/i $($installer_path) $($installer_argumments)" -Wait;
}

## NON MSI INSTALL
else {
    if ($install_script) {

        ### PASTE SCRIPT HERE IF COPYING OVER!

    } else {
        Start-Process -FilePath $installer_path -ArgumentList "$($installer_argumments)" -Wait;
    }
    
}



# TESTS
# The way the below works is when you throw an exception, powershell sets the exit code as 1, we will later have MDT catch these
## DIRECTORY EXISTANCE TEST

if (Test-Path -Path $installed_dir) {
    "Path exists!";
} else {
    "Path doesn't exist."
    Write-Output "$($shortname) failed on DIRECTORY TEST. $($installed_dir) does not exist" | Out-File -FilePath "$LogPath\luislog.log" -Encoding "Default" -Append;
    throw "$($shortname) failed on DIRECTORY TEST. $($installed_dir) does not exist";
}

## FILE EXISTANCE TEST

if (Test-Path -Path $exe_that_should_exist) {
    "Path exists!";
} else {
    "Path doesn't exist."
    Write-Output "$($shortname) failed on EXE TEST. $($exe_that_should_exist) does not exist" | Out-File -FilePath "$LogPath\luislog.log" -Encoding "Default" -Append;
    throw "$($shortname) failed on EXE TEST. $($exe_that_should_exist) does not exist";
}
