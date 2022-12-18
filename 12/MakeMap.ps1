$red = [System.Collections.ArrayList]::new($map.Count)
0..($map.Count - 1) | % { $red.Add(('.' * $map[0].Length).ToCharArray()) }
$cur = $end
$red[$end.Item1][$end.Item2] = 'E'
$count = 0
while($cur -ne $start)
{
    Switch ($path[$cur])
    {
        {($_.Item1 - $cur.Item1) -eq 1} {$red[$_.Item1][$_.Item2] = '^'; break}
        {($_.Item1 - $cur.Item1) -eq -1} {$red[$_.Item1][$_.Item2] = 'v'; break}
        {($_.Item2 - $cur.Item2) -eq 1} {$red[$_.Item1][$_.Item2] = '<'; break}
        {($_.Item2 - $cur.Item2) -eq -1} {$red[$_.Item1][$_.Item2] = '>'; break}
    }
    $cur = $path[$cur]
    $count += 1
}
Remove-Item .\output.txt
$red | %{ $_ -join '' | Add-Content .\output.txt }