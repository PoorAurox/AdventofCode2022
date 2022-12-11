$giantFolderList = @{
    '/' = 0
}
Function Get-FolderSize
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $Folder,
        $giantFolderList
    )
    Process {
        if(-not $folder)
        {
            return 0
        }
    
        $filesSize = $folder.Files | Sort-Object name -Unique | measure size -Sum
        $folderSize = $folder.Folders.Values | Get-FolderSize -giantFolderList $giantFolderList | measure -sum
        $giantFolderList[$folder.name] = $filesSize.Sum + $folderSize.Sum
        return $filesSize.Sum + $folderSize.Sum
    }
}

$head = [pscustomobject]@{
    Name = '/'
    Files = @()
    Folders = @{}
    Parent = $null
}
$current = $head
$input = Get-Content 'Input.txt'
$lastcommand = ''
foreach($line in ($input | Select -Skip 1))
{
    if($line[0] -eq '$')
    {
        if($line -match 'cd')
        {
            if($line -like '$ cd ..*')
            {
                $current = $current.Parent
            }
            elseif((-split $line)[2] -in $current.Folders.Keys)
            {
                $current = $current.Folders[($line -split ' ')[2]]
            }
            else {

                $temp = [pscustomobject]@{
                    Name = ($line -split ' ')[2]
                    Files = @()
                    Folders = @{}
                    Parent = $current
                }
                $current.Folders[($line -split ' ')[2]] = $temp
                $current = $temp
            }
        }
        $lastcommand = $line
    }
    elseif($line -like 'dir*') {
        if(($line -split ' ')[1] -in $current.Folders.Keys)
        {
            $current = $current.Folders[($line -split ' ')[1]]
        }
        else {

            $temp = [pscustomobject]@{
                Name = ($line -split ' ')[1]
                Files = @()
                Folders = @{}
                Parent = $current
            }
            $current.Folders[($line -split ' ')[1]] = $temp
        }
    }
    else {
        $current.Files += [pscustomobject]@{
            Size = ($line -split ' ')[0]
            Name = ($line -split ' ')[1]
        }
    }
}
$head | Get-FolderSize -giantFolderList $giantFolderList
$giantFolderList.Values | Where {$_ -le 100000} | Measure-Object -Sum