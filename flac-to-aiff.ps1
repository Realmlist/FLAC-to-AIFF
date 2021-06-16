#Directory with .FLACs to convert to .AIFF:
$dir = "D:\Music\Flac-Album"

# ---------------- DO NOT EDIT BELOW ---------------- #
Set-Location $dir
$newDir = $dir + "\aiff"

#Check if AIFF directory exists
if(!(Test-Path $newDir -PathType Container)) { 
    #Dir doesn't exist
    New-Item $newDir -ItemType directory
}

#Get all .flac files in $dir
$list = Get-ChildItem -Path $dir -Recurse | `
        Where-Object { $_.PSIsContainer -eq $false -and $_.Extension -eq '.flac' }


ForEach($n in $list){
    #Rename aiff output
    $aiffName = ($n.Name).Substring(0,$n.Name.Length-5) + ".aiff"
    #Declare new full path for aiff
    $newAIFF = $dir + "\aiff\" + $aiffName
    #Convert
    ffmpeg -i $n.Name -write_id3v2 1 -c:v copy $aiffName
    #Move to new folder
    Move-Item $aiffName $newAIFF
}
