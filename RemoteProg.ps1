#Param(
#    [string]$target="DESKTOP-I0G1IV3",
#    [string]$localbin = {gci -Recurse -filter "*.bin" | sort LastWriteTime | select -last 1}
#)
$target = "DESKTOP-I0G1IV3"
$newestbin = gci C:\users\matth\Documents\Arduino -Recurse -Filter "*.bin" | sort LastWriteTime | select -Last 1
$localbin = $newestbin.FullName
$esptool = "C:\Users\Printer\Appdata\local\Arduino15\packages\esp8266\tools\esptool\0.4.13\esptool.exe -vv -cd nodemcu -cb 115200 -cp COM3 -ca 0x0 -cz 0x400000 -ca 0x00000 -cf "
$rfile2burn = "c:\users\printer\burnme.bin"
$cmdstring = $esptool + $rfile2burn
$mycreds = Get-Credential printer
New-PSDrive -name flasher -PSProvider FileSystem -Root \\$target\c$\users\printer -Credential $mycreds
Copy-Item -path $localbin -Destination flasher:\burnme.bin -force
Remove-PSDrive flasher
echo "Command to execute:"
echo $cmdstring
Invoke-Command -ComputerName $target -ScriptBlock { & cmd.exe /c $Using:cmdstring } -usessl -credential $mycreds