$instructions = get-content .\input.txt -raw

$initialSetup,$steps = $instructions -split "`r`n`r`n"
$initialSetup = $initialSetup -split "`r`n"
$steps = $steps -split "`r`n"

$stacksInformation = [regex]::matches($initialSetup[-1], "\d+")
$stacks = [System.Collections.ArrayList]::new()
1..($stacksInformation.Count) | % {$stacks.Add([System.Collections.Generic.List[string]]::new())}


foreach($capture in $stacksInformation)
{
    foreach($box in $initialSetup[-2..(-$initialSetup.Length)].Substring($capture.Index,1))
    {
        if($box -ne ' ')
        {
            $stacks[$capture.Value - 1].Add($box)
        }
    }
}
foreach($instruction in $steps)
{
    $values = [regex]::matches($instruction, "\d+")
    $sourceStack = $stacks[$values[1].Value - 1]
    $stacks[$values[2].Value - 1].AddRange([string[]]$sourceStack[($sourceStack.Count -$values[0].Value)..($sourceStack.Count -1)])
    $sourceStack.RemoveRange($sourceStack.Count -$values[0].Value,$values[0].Value)
}