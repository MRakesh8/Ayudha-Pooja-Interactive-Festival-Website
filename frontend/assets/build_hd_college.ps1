Add-Type -AssemblyName System.Drawing

# 1. Target dimensions matching the new dept plaque exactly: 1007 x 281
$targetW = 1007
$targetH = 281

$collegeBmp = New-Object System.Drawing.Bitmap($targetW, $targetH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($collegeBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# 2. Draw scaled background from plaque_college_perfect.png
$orig = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\plaque_college_perfect.png").Path)
$g.DrawImage($orig, 0, 0, $targetW, $targetH)
$orig.Dispose()

# 3. Super-sharpen the official SREC Crest at high-res in the circular seal
# In 1007x281, the seal is located at:
# x: 60 to 280 (width ~220), y: 15 to 265 (height ~240), center is at (170, 140)
$crest = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\srec_crest.png").Path)
# Draw crest precisely over the seal center
$g.DrawImage($crest, 62, 22, 224, 230)
$crest.Dispose()

$g.Dispose()

$collegeBmp.Save("d:\Downloads\project01\frontend\assets\plaque_college_hd_matched.png", [System.Drawing.Imaging.ImageFormat]::Png)
$collegeBmp.Dispose()

Write-Host "Created plaque_college_hd_matched.png (1007x281)"
