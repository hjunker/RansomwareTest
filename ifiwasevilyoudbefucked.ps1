function Get-Permissions ($folder) {
    (get-acl $folder).access | select `
          @{Label="Identity";Expression={$_.IdentityReference}}, `
          @{Label="Right";Expression={$_.FileSystemRights}}, `
          @{Label="Access";Expression={$_.AccessControlType}}, `
          @{Label="Inherited";Expression={$_.IsInherited}}, `
          @{Label="Inheritance Flags";Expression={$_.InheritanceFlags}}, `
          @{Label="Propagation Flags";Expression={$_.PropagationFlags}} | ft -auto
          }

# TODOs
# - make recursive crawling working
# - file share for testing
# - check which of all files (shares, partitions) are writeable, https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem?view=powershell-7.1

Write-Host "IfIWasEvilWouldYouBeFucked - ransomware risk check`r`n`r`n"

Write-Host "Please keep in mind that if this was a real ransomware, you would not see this until all of your files have been encryted.`r`r";

#$path = 'C:\Users\secul\Desktop\ransomtestfiles';
$path = 'C:\Users';
$files = Get-ChildItem -Path $path -Recurse | select -expand fullname;

$havemercy = 2000;

$extensions = @('doc', 'docm', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'pdf', 'txt', 'jpg', 'jpeg');
$counter = @{};
foreach ($extension in $extensions)
{
    $counter[$extension] = 0;
}

#Write-Host "lets go..."

foreach ($file in $files)
{
    #Write-Host $file;
    #$tmppath = $file.Path + '\' + $file.Name;
    #Write-Host "checking", $tmppath;
    
    # THIS CODE WOULD JUST PUT .xxx behind the current file extension (easily reversible)
    #$tmpnewname = $file.Name + '.xxx';
    #Rename-Item -Path $tmppath -NewName $tmpnewname;

    # CHECK IF FILE IS WRITEABLE --> COUNT TYPICAL FILETYPES OF INTEREST
    try {
        [System.IO.File]::OpenWrite($file).close();
        
        $writable = Get-Item $file | select FullName, Name, Length, Extension
        #[PSCustomObject] @{
        #    FullName = $writable.FullName
        #    Name = $writable.Name
        #    Size = $writable.Length
        #    Extension = $writable.Extension
        #}
        foreach ($extension in $extensions)
        {
            if ($file.EndsWith($extension))
            {
                $counter[$extension] = $counter[$extension] + 1
                Write-Host "I could have deleted ", $file;
                $havemercy = $havemercy - 1;
            }
        }
        if ($havemercy -eq 0)
        {
            break;
        }
    }
    catch {
        #Write-Host "error trying OpenWrite"
    }

    
}

$total = 0;
foreach ($extension in $extensions)
{
    $total = $total + $counter[$extension];
}

if ($total -gt 0)
{
    Write-Host "would you miss any of the files listed above? would you be able to restore it from a backup copy?`r`n"
}


Write-Host $total, " files could have been encrypted by now including:"
foreach ($extension in $extensions)
{
    Write-Host $counter[$extension], " ", $extension, " files";
}
Write-Host "please note that I stopped myself before collecting too many files`r`n";

Write-Host "`r`nBut wait... there is much more I could have done by now... perhaps take a look / lay my hand on some files on other disks, fileshares, ... lets see...`r`n"

#$disks = Get-Disk;
#foreach ($disk in $disks)
#{
#    Write-Host $disk.Number, " (", $disk.Model, ", ", $disk.Size, ", read-only: ", $disk.IsReadOnly, ")";
#}


#Get-Partition | Format-List
$partitions = Get-Partition;
Write-Host "`r`npartitions of interest:"
foreach ($partition in $partitions)
{
    if (($partition.DriveLetter -ge 'A' -and $partition.DriveLetter -le 'Z') -or ($partition.DriveLetter -ge 'a' -and $partition.DriveLetter -le 'z'))
    {
        Write-Host $partition.DriveLetter, ", size ", $partition.Size, ", type ", $partition.Type;
    }
}

#Get-Permissions("C:\tdm\log.txt")

Write-Host "`r`nshares of interest";
$shares = Get-FileShare;
foreach ($share in $shares)
{
    Write-Host $share.Name
}

#Get-Volume | Format-List

#Get-Disk | Format-List
#Get-ChildItem -Path $file -Recurse | ForEach-Object -Process {if (!$_.PSIsContainer) {$_.Name; $_.Length / 1024; " " }}