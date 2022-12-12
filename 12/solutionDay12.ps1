$map = "aabqponm
abcryxxl
accszExk
acctuvwj
abdefghi" -split "`r`n"

function Traverse-Map {
    [CmdletBinding()]
    param (
        [Parameter()]
        $X,
        $Y,
        [System.Collections.ArrayList]$beenTo
    )
    $beenTo.Add([Tuple]::Create($x,$y)) | Out-Null
    if($map[$x][$y].ToString() -eq 'E')
    {
        return $beenTo
    }
    #up
    if($y - 1 -ge 0 -and ([byte]$map[$x][$y-1] -le [byte]$map[$x][$y] + 1 -or ($map[$x][$y-1].ToString() -eq 'E' -and $map[$x][$y].ToString() -eq 'z')) -and -not $beenTo.Contains([Tuple]::Create($x,$y-1)))
    {
        $up = Traverse-Map -X $X -Y ($y -1) -beenTo $beenTo
    }
    #down
    if($y + 1 -lt $map[$x].Count -and ([byte]$map[$x][$y+1] -le [byte]$map[$x][$y] + 1 -or ($map[$x][$y+1].ToString() -eq 'E' -and $map[$x][$y].ToString() -eq 'z')) -and -not $beenTo.Contains([Tuple]::Create($x,$y+1)))
    {
        $down = Traverse-Map -X $X -Y ($y + 1) -beenTo $beenTo
    }
    #left
    if($x - 1 -ge 0 -and ([byte]$map[$x-1][$y] -le [byte]$map[$x][$y] + 1 -or ($map[$x-1][$y].ToString() -eq 'E' -and $map[$x][$y].ToString() -eq 'z')) -and -not $beenTo.Contains([Tuple]::Create($x-1,$y)))
    {
        $left = Traverse-Map -X ($x - 1) -Y $y -beenTo $beenTo
    }
    # right
    if($x + 1 -lt $map.Length -and ([byte]$map[$x+1][$y] -le [byte]$map[$x][$y] + 1 -or ($map[$x+1][$y].ToString() -eq 'E' -and $map[$x][$y].ToString() -eq 'z')) -and -not $beenTo.Contains([Tuple]::Create($x+1,$y)))
    {
        $right = Traverse-Map -X ($x + 1) -Y $y -beenTo $beenTo
    }
    if($null -eq $up -and $null -eq $down -and $null -eq $left -and $null -eq $right)
    {
        return $null
    }
    $up, $down, $left, $right | Sort Count | Select -first 1
}

$result = Traverse-Map -X 0 -Y 0 -beenTo ([System.Collections.ArrayList]::new())