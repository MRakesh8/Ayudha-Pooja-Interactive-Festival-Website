Add-Type -AssemblyName System.Drawing

$src = (Resolve-Path ".\frontend\assets\technitix_ayudha_puja_gateway_ref.png").Path
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$w = $bmp.Width   # 1672
$h = $bmp.Height  # 941

# Left plaque: in reference, it is roughly x: 120 to 660, y: 15 to 135
# Right plaque: roughly x: 1010 to 1550, y: 15 to 135

$leftPlaqueRect = New-Object System.Drawing.Rectangle(150, 18, 520, 115)
$leftPlaque = $bmp.Clone($leftPlaqueRect, $bmp.PixelFormat)
$leftPlaque.Save("d:\Downloads\project01\frontend\assets\ref_left_plaque.png", [System.Drawing.Imaging.ImageFormat]::Png)
$leftPlaque.Dispose()

$rightPlaqueRect = New-Object System.Drawing.Rectangle(1005, 18, 520, 115)
$rightPlaque = $bmp.Clone($rightPlaqueRect, $bmp.PixelFormat)
$rightPlaque.Save("d:\Downloads\project01\frontend\assets\ref_right_plaque.png", [System.Drawing.Imaging.ImageFormat]::Png)
$rightPlaque.Dispose()

$bmp.Dispose()
Write-Output "Plaques cropped for inspection"
