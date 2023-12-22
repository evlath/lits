## LUIS (Labs Unified Install Script)
## CURRENT VERSION: 0.1
#
#   CHANGE LOG
#
# Version 0.1 (2023-12-22)
# - Script is able to install MSI, exe and from a copied existing script
# - Will throw an error for paths that don't exist but nothing more

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
    # TODO add log
    "Path exists!";
} else {
    # TODO add log
    "Path doesn't exist."
    throw "$($shortname) failed on DIRECTORY TEST. $($installed_dir) does not exist";
}

## FILE EXISTANCE TEST

if (Test-Path -Path $exe_that_should_exist) {
    # TODO add log
    "Path exists!";
} else {
    # TODO add log
    "Path doesn't exist."
    throw "$($shortname) failed on EXE TEST. $($exe_that_should_exist) does not exist";
}
