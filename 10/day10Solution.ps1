$cycle = 0
$x = 1
$instructions = Get-Content .\day10Input.txt
#$instructions = Get-Content .\testInstruction.txt
$screen = 0..239 | % {'.'}
#$VerbosePreference = 'Continue'


$returns = foreach($operation in $instructions)
{
    $cycle += 1
    if($cycle -eq 34 -or $cycle -eq 35)
    {
        $VerbosePreference = 'Continue'
    }
    if($cycle -gt 55)
    {
        $VerbosePreference = 'SilentlyContinue'
    }
    Write-Verbose "Start cycle $($cycle): begin executing $operation"
    if($cycle % 40 -in [int[]]@($x,($x+1),($x+2)))
    {
        $screen[$cycle-1] = '#'
        Write-Verbose "During cycle $($cycle): CRT draws pixel in position $($cycle - 1)"
    }
    if($operation -ne 'noop')
    {
        
        $cycle += 1
       
        if($cycle % 40 -in [int[]]@($x,($x+1),($x+2)))
        {
            Write-Verbose "During cycle $($cycle): CRT draws pixel in position $($cycle - 1)"
            $screen[$cycle-1] = '#'
        }
        
        $x += ($operation -split ' ')[1]
        Write-Verbose "During cycle $($cycle): finish executing $operation (Register X is now $x)"
    }
    #Write-Host
}
foreach($pixel in 0..239)
{
    if($pixel % 40 -eq 0)
    {
        Write-host
    }
    Write-host $screen[$pixel] -NoNewline
}