Add-Type -AssemblyName System.Drawing

# Load the perfect dept plaque as template base
$dept = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\plaque_dept_it_aids_perfect.png").Path)
$w = $dept.Width
$h = $dept.Height

$college = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($college)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw the dept plaque frame & background
$g.DrawImage($dept, 0, 0, $w, $h)

# Clear the text area on right (from x=310 to x=940, y=40 to y=240)
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(310, 40)),
    (New-Object System.Drawing.Point(310, 240)),
    [System.Drawing.Color]::FromArgb(255, 255, 238, 195),
    [System.Drawing.Color]::FromArgb(255, 248, 204, 130)
)
$g.FillRectangle($brush, 310, 40, 630, 200)
$brush.Dispose()

# Also clear the center of the emblem roundel to place SREC crest
$darkMaroon = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 115, 6, 18))
$g.FillEllipse($darkMaroon, 105, 65, 146, 146)
$darkMaroon.Dispose()

# Stamp the crisp official SREC Crest
$crest = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\srec_crest.png").Path)
# Draw crest centered inside maroon roundel: center at 178, 138, diameter 140
$g.DrawImage($crest, 108, 68, 140, 140)
$crest.Dispose()

# Render the exact required text:
$fontBig = New-Object System.Drawing.Font("Arial Black", 44, [System.Drawing.FontStyle]::Bold)
$fontMid = New-Object System.Drawing.Font("Arial Black", 30, [System.Drawing.FontStyle]::Bold)
$fontSub = New-Object System.Drawing.Font("Arial Black", 14, [System.Drawing.FontStyle]::Bold)

$shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 255, 235, 160))
$crimsonBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(320, 40)),
    (New-Object System.Drawing.Point(320, 140)),
    [System.Drawing.Color]::FromArgb(255, 185, 15, 30),
    [System.Drawing.Color]::FromArgb(255, 100, 5, 15)
)
$darkBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 5, 10))

# Format center-aligned in the text area (center X = 635)
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

# SREE SAKTHI
$g.DrawString("SREE SAKTHI", $fontBig, $shadowBrush, 637, 43, $sf)
$g.DrawString("SREE SAKTHI", $fontBig, $crimsonBrush, 635, 41, $sf)

# ENGINEERING COLLEGE
$g.DrawString("ENGINEERING COLLEGE", $fontMid, $shadowBrush, 637, 127, $sf)
$g.DrawString("ENGINEERING COLLEGE", $fontMid, $crimsonBrush, 635, 125, $sf)

# AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI
$g.DrawString("AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI", $fontSub, $darkBrush, 635, 185, $sf)

$g.Dispose()
$dept.Dispose()

$college.Save("d:\Downloads\project01\frontend\assets\plaque_college_matched.png", [System.Drawing.Imaging.ImageFormat]::Png)
$college.Dispose()

Write-Host "Created matching college plaque at plaque_college_matched.png"
