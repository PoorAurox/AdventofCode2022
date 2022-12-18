class PriorityQueue {
    [System.Collections.Generic.Dictionary[System.ValueTuple`2[int,int],int]]$vertices = [System.Collections.Generic.Dictionary[System.ValueTuple`2[int,int],int]]::new()
    [System.ValueTuple`2[int,int]] Dequeue()
    {
        $lowest = $this.vertices.GetEnumerator() | Sort-Object Value | Select-Object -First 1
        try{
            if($lowest.Key.Item1 -eq 0 -and $lowest.Key.Item2 -eq 3)
            {
                Write-Host
            }
        $this.vertices.Remove($lowest.Key)

        return $lowest.Key
        }
        Catch{
            Write-Host $_
            return $lowest.Key
        }
        #endregion
    }
    [void] Enqueue([System.ValueTuple`2[int,int]]$key, [int]$priority)
    {
        $this.vertices.Add($key,$priority)
    }
    [void] UpdatePriority([System.ValueTuple`2[int,int]]$key, [int]$priority)
    {
        $this.vertices[$key] = $priority
    }
    [int] Count()
    {
        return $this.vertices.Count
    }
}

function Get-Neighbors
{
    param(
        $Graph,
        $source
    )
    try{
    if($graph[$source.Item1][$source.Item2] -ceq 'E')
    {
        return
    }
    $options = switch ($source)
    {
        {($_.Item1 - 1) -ge 0} { [System.ValueTuple]::Create($_.Item1 - 1, $_.Item2) }
        {($_.Item1 + 1) -lt $graph.Length} { [System.ValueTuple]::Create($_.Item1 +1, $_.Item2) }
        {($_.Item2 - 1) -ge 0} { [System.ValueTuple]::Create($_.Item1, $_.Item2 - 1) }
        {($_.Item2 + 1) -lt $graph[0].Length} { [System.ValueTuple]::Create($_.Item1, $_.Item2 + 1) }
    }
    if($graph[$source.Item1][$source.Item2] -ceq 'S')
    {
        return $options | Where-Object {$graph[$_.Item1][$_.Item2] -eq 'a'}
    }
    if($graph[$source.Item1][$source.Item2] -ceq 'z')
    {
        return $options | Where-Object {$graph[$_.Item1][$_.Item2] -ceq 'E' -or [byte]($graph[$_.Item1][$_.Item2]) -le ([byte]($graph[$source.Item1][$source.Item2]) + 1)}
    }
    return $options | Where-Object {[byte]($graph[$_.Item1][$_.Item2]) -le ([byte]($graph[$source.Item1][$source.Item2]) + 1) -and $graph[$_.Item1][$_.Item2] -cne 'E'}  
}
catch {
    Write-Host $_
}
}

function Dijkstra
{
    param(
        $Graph,
        $source
    )
    $Q = [PriorityQueue]::new()
    $dist = @{$source = 0}
    $prev = [ordered]@{}

    foreach($x in 0..($graph.Count - 1))
    {
        foreach($y in 0..($graph[$x].Length - 1))
        {
            $v = [System.ValueTuple]::Create($x,$y)
            if($v -ne $source)
            {
                $dist[$v] = [int]::MaxValue
                $prev[$v] = [int]::NaN
            }
            $q.Enqueue($v, $dist[$v])
        }
    }
    while($q.Count() -ne 0)
    {
        $u = $q.Dequeue()
        # if($u.Item1 -eq 0 -and $u.Item2 -eq 3)
        # {
        #     Write-Host
        # }
        foreach($neighbor in (Get-Neighbors -Graph $Graph -source $u))
        {
            if($dist[$u] -eq [int]::MaxValue)
            {
                $alt = 1
            }
            else 
            {
                $alt = $dist[$u] + 1
            }
            
            if($alt -lt $dist[$neighbor])
            {
                $dist[$neighbor] = $alt
                $prev[$neighbor] = $u
                $q.UpdatePriority($neighbor,$alt)
                #Write-Host "Home: $($Graph[$u.Item1][$u.Item2]) $($u.Item1), $($u.Item2): Neighbor: $($Graph[$neighbor.Item1][$neighbor.Item2]) $($neighbor.Item1), $($neighbor.Item2): Count $alt"
            }
        }

    }
    return $dist,$prev
}
function BreadthFirst {
    param (
        $Graph,
        $Root
    )
    [System.Collections.Generic.Queue[System.ValueTuple`2[int,int]]]$Q = [System.Collections.Generic.Queue[System.ValueTuple`2[int,int]]]::new()
    $prev = @{}
    $Q.Enqueue($Root)
    while($Q.Count -ne 0)
    {
        $v = $Q.Dequeue()
        if($graph[$v.Item1][$v.Item2] -ceq 'E')
        {
            return $v,$prev
        }
        foreach($neighbor in (Get-Neighbors -Graph $Graph -source $v))
        {
            if($neighbor -notin $prev.Keys)
            {
                $prev[$neighbor] = $v
                $q.Enqueue($neighbor)
            }
        }
    }
}
$map = Get-Content .\input.txt
$start = 0..($map.Count-1) | Where {$map[$_] -cmatch 'S'} | .{Process{[System.ValueTuple]::Create($_,$map[$_].IndexOf('S'))}}
$end = 0..($map.Count-1) | Where {$map[$_] -cmatch 'E'} | .{Process{[System.ValueTuple]::Create($_,$map[$_].IndexOf('E'))}}

#$route,$path = Dijkstra -Graph $map -source $start
$route,$path = BreadthFirst -Graph $map -Root $start