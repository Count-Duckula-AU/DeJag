#Patches 64x64 Pixel 24-bit .bmps into the jag BIOS.
#Place source .bmp file(s) in \BMP
#Modded BIOS will be saved to '\Patched BIOS' as boot-<BMP_NAME>.rom
#Required files (in same folder as script): '[BIOS] Atari Jaguar (World).j64', 'bmp_cry_nodither.exe', 'introorg.img', 'introptf.exe'


$WorkingPath = $PSScriptRoot
$Input_BMPs = Get-ChildItem "$WorkingPath\BMP\" -Filter *.bmp
$Input_Bios = "$WorkingPath\[BIOS] Atari Jaguar (World).j64"


try {$Bios = [System.IO.File]::ReadAllBytes($Input_Bios)}
Catch {Write-Host "Could not load stock BIOS: $Input_Bios" -ForegroundColor Red;Pause;exit}

if (!$Input_BMPs) {Write-Host "No source bmp image file(s) found in BMP folder." -ForegroundColor Red;Pause;exit}
if (!(Test-Path ".\Patched BIOS\")) {write-host "No output folder found, creating"-ForegroundColor Yellow; New-Item ".\Patched BIOS" -Type Directory | Out-Null}


foreach ($BMP in $Input_BMPs)
    {
    $BMPName = ".\BMP\"+$BMP.name
    $BMPBaseName = $BMP.basename

    Write-host "Converting .bmp to .cry"
    & '.\bmp_cry_nodither.exe' "$BMPName" "$BMPBaseName.cry"

    Write-host "Patching .cry into boot animation .img"
    & '.\introptf.exe' "$BMPBaseName.cry" | out-null
    

    try{$Img  = [System.IO.File]::ReadAllBytes("$WorkingPath\$BMPBaseName.img")}
    Catch {Write-Host "Could not load modded .img: $BMPBaseName.img" -ForegroundColor Red;Pause;exit}


    Write-host "Patching custom animation .img into stock BIOS"
    #idfk, but these seem to work
    $ImgOffset = 0x0000000A     #Where to start reading the custom .img
    $BiosOffset = 0x00000526    #Where to start overwriting in BIOS

    try{
        While ($ImgOffset -le 0x0001442B)   #.img always seems to end at 0x0001442B
            {
            $Bios[$BiosOffset] = $Img[$ImgOffset]
            $BiosOffset = $BiosOffset + 0x00000001
            $ImgOffset = $ImgOffset + 0x00000001
            }
        }
    catch{Write-Host"Error Patching BIOS" -ForegroundColor Red;Pause;exit}


    Try{[System.IO.File]::WriteAllBytes("$WorkingPath\Patched BIOS\boot-$BMPBaseName.rom", $Bios)}
    Catch{Write-host "Could not save modded BIOS" -ForegroundColor Red;Pause;exit}

    Write-host "Created Patched BIOS: $WorkingPath\Patched BIOS\boot-$BMPBaseName.rom" -ForegroundColor Green
    Write-host "Removing working files"
    Remove-Item $WorkingPath\$BMPBaseName.cry
    Remove-Item $WorkingPath\$BMPBaseName.img
    }

Write-Host "`nJob's Done." -ForegroundColor Green
Pause
