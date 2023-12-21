$shortname = ""                                 # NAME OF PROGRAM (e.g. 7zip, Solidworks 2023, etc)
$verison = ""               
$installer_path = ""                            # RELATIVE PATH TO INSTALLER (e.g. .\setup.exe, .\windows\setup.msi, \\nasshare2.engr.colostate.edu\software\solidworks\2023\setupad.exe)
$installer_parameters = ""                      # PARAMETERS FOR INSTALLER
$is_msi_install = $false

# Vars for tests
$installed_dir = ""
$exe_that_should_exist = ""

# INSTALL PROGRAM

## MSI INSTALL
if ($is_msi_install) {
    msiexec /i $installer_path /qn
}

## NON MSI INSTALL
else {
    $installer_path
}



# TESTS
## DIRECTORY EXISTANCE TEST

if (Test-Path -Path $installed_dir) {
    # TODO add log
    "Path exists!"
} else {
    # TODO add log
    "Path doesn't exist."
    throw "$($shortname) failed on DIRECTORY TEST. $($installed_dir) does not exist"
}

## FILE EXISTANCE TEST

if (Test-Path -Path $exe_that_should_exist) {
    # TODO add log
    "Path exists!"
} else {
    # TODO add log
    "Path doesn't exist."
    throw "$($shortname) failed on EXE TEST. $($exe_that_should_exist) does not exist"
}