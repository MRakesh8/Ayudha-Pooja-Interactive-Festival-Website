Add-Type -AssemblyName System.Drawing

Get-ChildItem "d:\Downloads\project01\frontend\assets\*.png" | ForEach-Object {
    $img = [System.Drawing.Bitmap]::FromFile($_.FullName)
    Write-Host "$($_.Name): Width=$($img.Width), Height=$($img.Height)"
    $img.Dispose()
}
