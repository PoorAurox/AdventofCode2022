$input = Get-Content .\input.txt
foreach($i in (13..($input.length - 1))){
    if( ($input[($i-13)..$i] | Select -Unique).Count -eq 14){
        Write-host ($i + 1)
        break
    }
}