function Move-Knot {
    param (
        $head,
        $follower
    )
    if([math]::abs($head.Item1 - $follower.Item1) -gt 1 -or [math]::abs($head.Item2 - $follower.Item2) -gt 1)
    {
        $follower = [System.Tuple]::Create($follower.Item1 + ([math]::Round(($head.Item1 - $follower.Item1)/2,[System.MidpointRounding]::AwayFromZero)),$follower.Item2 + ([math]::Round(($head.Item2 - $follower.Item2)/2,[System.MidpointRounding]::AwayFromZero)))
    }
    $follower
}
$knotCount = 10
$instructions = Get-Content .\input.txt
$followers = 1..$knotCount | %{ [System.Tuple]::Create(0,0) }
$steps = foreach($move in $instructions.Trim()){
    $direction = [regex]::Match($move,"\w").Value
    $numMoves = [regex]::Match($move,"\d*$").Value
    foreach($i in 1..([int]$numMoves))
    {
        $head = $followers[0]
        $followers[0] = switch ($direction)
        {
            'U' {[System.Tuple]::Create($head.Item1, $head.Item2 + 1)}
            'D' {[System.Tuple]::Create($head.Item1, $head.Item2 - 1)}
            'R' {[System.Tuple]::Create($head.Item1 + 1, $head.Item2)}
            'L' {[System.Tuple]::Create($head.Item1 - 1, $head.Item2)}
        }
        foreach($i in 1..($followers.Count - 1))
        {
            $followers[$i] = Move-Knot -head $followers[$i -1] -follower $followers[$i]
        }
        $followers[-1]
    }
}
$steps | Sort-Object -Unique | measure