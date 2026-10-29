Add-Type -AssemblyName System.Drawing

# 1. Refine College Plaque
$leftSrc = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\header_college_plaque.png").Path)
# Trim off any pillar artifact on extreme left (first 22 px)
$leftTrimRect = New-Object System.Drawing.Rectangle(22, 0, ($leftSrc.Width - 22), $leftSrc.Height)
$leftTrimmed = $leftSrc.Clone($leftTrimRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Overlay sharp circular seal onto the circle at (x=60, y=7, w=94, h=94)
$crest = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\srec_crest.png").Path)
$g = [System.Drawing.Graphics]::FromImage($leftTrimmed)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
# Draw sharp crest over existing seal: center is at x=78, y=54, diameter=94
$g.DrawImage($crest, 31, 7, 94, 94)
$g.Dispose()
$crest.Dispose()

$leftTrimmed.Save("d:\Downloads\project01\frontend\assets\header_college_plaque_clean.png", [System.Drawing.Imaging.ImageFormat]::Png)
$leftSrc.Dispose()
$leftTrimmed.Dispose()

# 2. Refine Dept Plaque
$rightSrc = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\header_dept_plaque.png").Path)
# Trim off any pillar artifact on extreme right (last 24 px)
$rightTrimRect = New-Object System.Drawing.Rectangle(0, 0, ($rightSrc.Width - 24), $rightSrc.Height)
$rightTrimmed = $rightSrc.Clone($rightTrimRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

$rightTrimmed.Save("d:\Downloads\project01\frontend\assets\header_dept_plaque_clean.png", [System.Drawing.Imaging.ImageFormat]::Png)
$rightSrc.Dispose()
$rightTrimmed.Dispose()

Write-Output "Perfected header plaques saved successfully"
