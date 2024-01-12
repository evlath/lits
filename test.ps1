Import-Module ActiveDirectory

$ouPath = 'ou=Anderson,ou=Workstations,ou=Labs,dc=engr,dc=colostate,dc=edu'
$csvfile = "./software.csv"

$computers = Get-ADComputer -Filter * -SearchBase $ouPath
$filedate = Get-Date -Format "yyyy-MM-dd-HHmmss";

$logdir = ".\Logs"
$globallogpath = "$logdir\$filedate-globallits.log"
$computerlogname = "lits-$filedate"

foreach ($computer in $computers) {

    $cn = $computer.Name;

    $total = 0;
    $fail = 0;

    Write-Host "Starting Test on: $($cn)"
    $logpath = "$logdir\$($cn)-$computerlogname.log"
    
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";
    "[$date] $($cn) STARTED" | Out-File -FilePath $logpath -Encoding "Default" -Append;

    Import-Csv -Path $csvFile | ForEach-Object {
        #$_.ShortName $_.Version $_.Directory $_.File
        $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";
        $cshare_Directory = "\\$($cn)\$($_.Directory.replace(':','$'))"
        $cshare_File = "\\$($cn)\$($_.File.replace(':','$'))"
        $failed = $false;

        if (!(Test-Path -Path $cshare_Directory)) {
            "[$date] FAILED $($_.ShortName) $($_.Version)  on DIRECTORY TEST. $($_.Directory) does not exist ON $($cn)" | Out-File -FilePath $logpath -Encoding "Default" -Append;
            $failed = $true;
        }
        if (!(Test-Path -Path $cshare_File)) {
            "[$date] FAILED $($_.ShortName) $($_.Version)  on FILE TEST. $($_.File) does not exist ON $($cn)" | Out-File -FilePath $logpath -Encoding "Default" -Append;
            $failed = $true;
        }
        if ($failed) {
            $fail++;
        } else {
            "[$date] PASSED $($_.ShortName) $($_.Version)" | Out-File -FilePath $logpath -Encoding "Default" -Append;
        }
        $total++;
    }
    
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";
    $success = $total - $fail;

    "[$date] $($cn) had $fail failures" | Out-File -FilePath $logpath -Encoding "Default" -Append;
    "[$date] $($cn) had $success successes" | Out-File -FilePath $logpath -Encoding "Default" -Append;
    "[$date] $($cn) had $total total tested apps" | Out-File -FilePath $logpath -Encoding "Default" -Append;
    "[$date] $($cn) ENDED" | Out-File -FilePath $logpath -Encoding "Default" -Append;

    if ($fail -gt 0) {
        "[$date] $($cn) FAILED with $fail failures" | Out-File -FilePath $globallogpath -Encoding "Default" -Append;
    } else {
        "[$date] $($cn) PASSED with $success successes" | Out-File -FilePath $globallogpath -Encoding "Default" -Append;
    }

}