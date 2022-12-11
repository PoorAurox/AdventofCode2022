$source = get-content .\input.txt -Raw

$monkeys = foreach($description in ($source -split "`r`n`r`n"))
{
    $description = $description -split "`r`n"
    [PSCustomObject]@{
        Items = [System.Collections.ArrayList]::new(($description[1] -split ": ")[1] -split ", " -as [long[]])
        Operation = ($description[2] -split "= ")[1]
        testDiv = [regex]::Match($description[3], "\d*$").Value
        ifTrue = [regex]::Match($description[4], "\d*$").Value
        ifFalse = [regex]::Match($description[5], "\d*$").Value
        Inspections = 0
    }
}
#defactoredPrime - I don't remember the name for this but since all divisors are prime multiply them together to get a product to mod by that all monkey's test evenly divide into.
$productToMod = $monkeys.testDiv | . {Begin {$product = 1} Process {$product = $product * $_} End{$product}}
foreach($i in 1..10000)
{
    foreach($simian in $monkeys)
    {
        while($simian.Items.Count -ne 0)
        {
            $curItem = $simian.items[0]
            $worry = Invoke-Expression ($simian.Operation -replace "old", "[long]$curItem")
            $worry = $worry % $productToMod
            if($worry % $simian.testDiv)
            {
                $monkeys[$simian.ifFalse].Items.Add($worry) | Out-Null
            }
            else {
                $monkeys[$simian.ifTrue].Items.Add($worry) | Out-Null
            }
            $simian.Items.RemoveAt(0)
            $simian.Inspections += 1
        }
    }
}