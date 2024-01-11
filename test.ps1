Import-Module ActiveDirectory

$ouPath = 'ou=Anderson,ou=Workstations,ou=Labs,dc=engr,dc=colostate,dc=edu'
$csvfile = "./software.csv"

$computers = Get-ADComputer -Filter * -SearchBase $ouPath
$filedate = Get-Date -Format "yyyy-MM-dd-HHmmss";

$logdir = "."
$globallogpath = "$logdir\globallits.log"
$computerlogname = "lits"

foreach ($computer in $computers) {

    $total = 0;
    $fail = 0;

    Write-Host "Starting Test on: $($computer.Name)"
    $logpath = "$logdir\$($computer.Name)-$computerlogname.log"
    
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";
    "[$date] $($computer.Name) STARTED" | Out-File -FilePath $logpath -Encoding "Default" -Append;

    Import-Csv -Path $csvFile | ForEach-Object {
        #$_.ShortName $_.Version $_.Directory $_.File
        $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss";
        $cshare_Directory = "\\$($computer.Name)\$($_.Directory.replace(':','$'))"
        $cshare_File = "\\$($computer.Name)\$($_.File.replace(':','$'))"
        $failed = $false;

        if (!(Test-Path -Path $cshare_Directory)) {
            "[$date] FAILED $($_.ShortName) $($_.Version)  on DIRECTORY TEST. $($_.Directory) does not exist ON $($computer.Name)" | Out-File -FilePath $logpath -Encoding "Default" -Append;
            $failed = $true;
        }
        if (!(Test-Path -Path $cshare_File)) {
            "[$date] FAILED $($_.ShortName) $($_.Version)  on FILE TEST. $($_.File) does not exist ON $($computer.Name)" | Out-File -FilePath $logpath -Encoding "Default" -Append;
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

    "[$date] $($computer.Name) had $fail failures" | Out-File -FilePath $logpath -Encoding "Default" -Append;
    "[$date] $($computer.Name) had $success successes" | Out-File -FilePath $logpath -Encoding "Default" -Append;
    "[$date] $($computer.Name) had $total total tested apps" | Out-File -FilePath $logpath -Encoding "Default" -Append;
    "[$date] $($computer.Name) ENDED" | Out-File -FilePath $logpath -Encoding "Default" -Append;

    if ($fail -gt 0) {
        "[$date] $($computer.Name) FAILED with $fail failures" | Out-File -FilePath $globallogpath -Encoding "Default" -Append;
    } else {
        "[$date] $($computer.Name) PASSED with $success successes" | Out-File -FilePath $globallogpath -Encoding "Default" -Append;
    }

}