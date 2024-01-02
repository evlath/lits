## LUIS (Labs Unified Install Script)
## CURRENT VERSION: 0.1.2
#
#   CHANGE LOG
#
# Version 0.1 (2023-12-22)
# - Script is able to install MSI, exe and from a copied existing script
# - Will throw an error for paths that don't exist but nothing more
#
# Version 0.1.1 (2023-12-22)
# - Added Log Output!
#
# Version 0.1.2 (2024-01-02)
# - Change Script to have pasted silent install script instead

$shortname = "Test Name";
$verison = "0.1";

# Vars for tests
$installed_dir = "C:\Fail";
$exe_that_should_exist = "C:\Fail\fail.exe";

$log = "\\labs-mdt\log$"


## INSTALL SCRIPT

# PASTE AN INSTALL SCRIPT HERE!

## END INSTALL SCRIPT



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
