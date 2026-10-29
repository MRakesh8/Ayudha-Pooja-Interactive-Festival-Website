Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\header_college_plaque.png").Path)

$trimRect = New-Object System.Drawing.Rectangle(32, 0, ($src.Width - 32), $src.Height)
$dst = $src.Clone($trimRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# The old circle is from x=16 to x=122
$g = [System.Drawing.Graphics]::FromImage($dst)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 205, 145))
$g.FillEllipse($brush, 14, 2, 108, 108)
$brush.Dispose()

$crest = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\srec_crest.png").Path)
$g.DrawImage($crest, 16, 2, 104, 104)
$crest.Dispose()
$g.Dispose()

$dst.Save("d:\Downloads\project01\frontend\assets\header_college_plaque_clean.png", [System.Drawing.Imaging.ImageFormat]::Png)
$src.Dispose()
$dst.Dispose()
Write-Output "Perfected seal alignment complete"
