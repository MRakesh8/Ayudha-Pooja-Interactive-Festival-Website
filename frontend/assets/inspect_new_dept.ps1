Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\rakes\.gemini\antigravity-ide\brain\48bb4a45-86be-4a0d-a0a4-0212f1a3375e\.user_uploaded\media_1792069637600.png"
$b = [System.Drawing.Bitmap]::FromFile($srcPath)
Write-Host "Width=$($b.Width) Height=$($b.Height)"

$c0 = $b.GetPixel(0, 0)
Write-Host "Pixel (0,0): A=$($c0.A) R=$($c0.R) G=$($c0.G) B=$($c0.B)"

$cMidTop = $b.GetPixel([int]($b.Width / 2), 0)
Write-Host "Pixel (w/2, 0): A=$($cMidTop.A) R=$($cMidTop.R) G=$($cMidTop.G) B=$($cMidTop.B)"

$b.Dispose()
