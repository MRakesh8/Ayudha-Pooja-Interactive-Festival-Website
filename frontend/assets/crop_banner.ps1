Add-Type -AssemblyName System.Drawing

$src = (Resolve-Path ".\frontend\assets\technitix_ayudha_puja_gateway_ref.png").Path
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$w = $bmp.Width
$h = $bmp.Height

# Measure bottom banner:
# x ranges roughly from 280 to 1400 (centered around 836)
# y ranges roughly from 600 to 920

$cropX = [int]($w * 0.12)
$cropY = [int]($h * 0.62)
$cropW = [int]($w * 0.76)
$cropH = [int]($h * 0.36)

$rect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
$cropped = $bmp.Clone($rect, $bmp.PixelFormat)

$dst = "d:\Downloads\project01\frontend\assets\ayudha_pooja_banner_raw.png"
$cropped.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)

$bmp.Dispose()
$cropped.Dispose()
Write-Output "Cropped bottom banner to $dst ($cropW x $cropH)"
