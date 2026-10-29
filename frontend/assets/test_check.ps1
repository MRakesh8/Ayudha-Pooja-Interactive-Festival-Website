Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile('d:\Downloads\project01\frontend\assets\plaque_technitix_perfect.png')
Write-Host "Technitix dimensions: $($b.Width) x $($b.Height)"
$c = $b.GetPixel(503, 162)
Write-Host "Color at y=162, x=503: R=$($c.R) G=$($c.G) B=$($c.B) A=$($c.A)"
$b.Dispose()

$d = [System.Drawing.Bitmap]::FromFile('d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png')
Write-Host "Dept dimensions: $($d.Width) x $($d.Height)"
$d.Dispose()
