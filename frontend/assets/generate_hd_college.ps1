Add-Type -AssemblyName System.Drawing

# Template base is the clean dept plaque (1007 x 281)
$dept = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\plaque_dept_it_aids_perfect.png").Path)
$w = $dept.Width
$h = $dept.Height

$college = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($college)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw base frame
$g.DrawImage($dept, 0, 0, $w, $h)

# 1. Fill the text area with identical radial/linear gold gradient as the dept plaque body
# Dept plaque text area is from x=290 to x=940, y=30 to y=250
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddRectangle((New-Object System.Drawing.Rectangle(295, 30, 650, 222)))
$pgrad = New-Object System.Drawing.Drawing2D.PathGradientBrush($path)
$pgrad.CenterPoint = New-Object System.Drawing.PointF(620, 130)
$pgrad.CenterColor = [System.Drawing.Color]::FromArgb(255, 255, 245, 215)
$pgrad.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 240, 185, 95))
$g.FillPath($pgrad, $path)
$pgrad.Dispose()
$path.Dispose()

# 2. Cover the AI chip inside the roundel with deep velvet maroon
# Roundel center is at x=178, y=140.
$darkMaroon = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 115, 6, 18))
$g.FillEllipse($darkMaroon, 108, 68, 142, 142)
$darkMaroon.Dispose()

# Inner gold circular ring
$goldPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 215, 0), 2.5)
$g.DrawEllipse($goldPen, 107, 67, 144, 144)
$goldPen.Dispose()

# 3. Draw the official crisp SREC crest
$crest = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\srec_crest.png").Path)
$g.DrawImage($crest, 110, 70, 138, 138)
$crest.Dispose()

# 4. Render BOLD, MAJESTIC, CRIMSON TYPOGRAPHY matching DEPT OF IT & AI&DS:
# Fonts
$fontTop = New-Object System.Drawing.Font("Arial Black", 44, [System.Drawing.FontStyle]::Bold)
$fontMid = New-Object System.Drawing.Font("Arial Black", 28, [System.Drawing.FontStyle]::Bold)
$fontSub = New-Object System.Drawing.Font("Arial Black", 14, [System.Drawing.FontStyle]::Bold)

# Text Brushes
$goldGlowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(190, 255, 230, 120), 4)
$goldGlowPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

$crimsonBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 35)),
    (New-Object System.Drawing.Point(300, 160)),
    [System.Drawing.Color]::FromArgb(255, 185, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 95, 3, 12)
)
$crimsonMidBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 120)),
    (New-Object System.Drawing.Point(300, 190)),
    [System.Drawing.Color]::FromArgb(255, 175, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 90, 3, 12)
)
$darkSubBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 5, 10))

# Center X of text section = 620
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

# SREE SAKTHI path for bevel & stroke
$path1 = New-Object System.Drawing.Drawing2D.GraphicsPath
$path1.AddString("SREE SAKTHI", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 48, (New-Object System.Drawing.Point(620, 35)), $sf)

# Gold outer glow / bevel
$g.DrawPath($goldGlowPen, $path1)
# Rich crimson fill
$g.FillPath($crimsonBrush, $path1)
$path1.Dispose()

# ENGINEERING COLLEGE path
$path2 = New-Object System.Drawing.Drawing2D.GraphicsPath
$path2.AddString("ENGINEERING COLLEGE", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 30, (New-Object System.Drawing.Point(620, 118)), $sf)

$goldGlowPen2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 255, 230, 120), 3)
$goldGlowPen2.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$g.DrawPath($goldGlowPen2, $path2)
$g.FillPath($crimsonMidBrush, $path2)
$path2.Dispose()
$goldGlowPen2.Dispose()

# AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI
$g.DrawString("AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI", $fontSub, $darkSubBrush, 620, 186, $sf)

$g.Dispose()
$dept.Dispose()

$college.Save("d:\Downloads\project01\frontend\assets\plaque_college_hd_perfect.png", [System.Drawing.Imaging.ImageFormat]::Png)
$college.Dispose()

Write-Host "Created plaque_college_hd_perfect.png successfully!"
