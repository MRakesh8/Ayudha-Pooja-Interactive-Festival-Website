Add-Type -AssemblyName System.Drawing

# 1. GENERATE HD TECHNITIX CENTER PLAQUE
$base = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\plaque_dept_it_aids_perfect.png").Path)
$w = $base.Width
$h = $base.Height

$tech = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($tech)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw base frame
$g.DrawImage($base, 0, 0, $w, $h)

# Clear entire interior plaque face (from x=70 to x=935, y=26 to y=220) with smooth radial gold gradient
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddRectangle((New-Object System.Drawing.Rectangle(70, 26, 866, 194)))
$pgrad = New-Object System.Drawing.Drawing2D.PathGradientBrush($path)
$pgrad.CenterPoint = New-Object System.Drawing.PointF(503, 120)
$pgrad.CenterColor = [System.Drawing.Color]::FromArgb(255, 255, 245, 215)
$pgrad.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 240, 185, 95))
$g.FillPath($pgrad, $path)
$pgrad.Dispose()
$path.Dispose()

# Draw Crown at top center
# Crown base width: 140, height: 50. Center at X=503, Y=30
# Royal Velvet Arch
$velvetBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 140, 20, 30))
$g.FillPie($velvetBrush, 453, 10, 100, 50, 180, 180)
$velvetBrush.Dispose()

# Crown Gold Band
$goldBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(440, 30)),
    (New-Object System.Drawing.Point(565, 30)),
    [System.Drawing.Color]::FromArgb(255, 220, 150, 30),
    [System.Drawing.Color]::FromArgb(255, 255, 230, 140)
)
$g.FillRectangle($goldBrush, 448, 30, 110, 9)

# Crown 5 Gold Spikes with Jewels
$spikePoints = @(
    (New-Object System.Drawing.Point(448, 30)),
    (New-Object System.Drawing.Point(448, 12)),
    (New-Object System.Drawing.Point(462, 24)),
    (New-Object System.Drawing.Point(478, 6)),
    (New-Object System.Drawing.Point(492, 22)),
    (New-Object System.Drawing.Point(503, 2)),
    (New-Object System.Drawing.Point(514, 22)),
    (New-Object System.Drawing.Point(528, 6)),
    (New-Object System.Drawing.Point(544, 24)),
    (New-Object System.Drawing.Point(558, 12)),
    (New-Object System.Drawing.Point(558, 30))
)
$g.FillPolygon($goldBrush, $spikePoints)

# Jewel tips (Emerald, Ruby, Diamond, Ruby, Emerald)
$jewelRed = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 20, 30))
$jewelCyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 215))
$jewelGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 240))
$g.FillEllipse($jewelCyan, 445, 9, 6, 6)
$g.FillEllipse($jewelRed, 475, 3, 6, 6)
$g.FillEllipse($jewelGold, 500, -1, 7, 7)
$g.FillEllipse($jewelRed, 525, 3, 6, 6)
$g.FillEllipse($jewelCyan, 555, 9, 6, 6)

# Gems on crown headband
for ($gx = 456; $gx -le 548; $gx += 15) {
    $g.FillEllipse($jewelRed, $gx, 32, 5, 5)
}
$jewelRed.Dispose(); $jewelCyan.Dispose(); $jewelGold.Dispose(); $goldBrush.Dispose()

# Render TECHNITIX Typography
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

# TECHNITIX Title (Big bold serif with gold bevel and crimson body)
$pathTech = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathTech.AddString("TECHNITIX", (New-Object System.Drawing.FontFamily("Georgia")), [int][System.Drawing.FontStyle]::Bold, 72, (New-Object System.Drawing.Point(503, 50)), $sf)

# Gold bevel stroke
$goldBevelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 255, 230, 110), 6)
$goldBevelPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$g.DrawPath($goldBevelPen, $pathTech)

# Crimson gradient fill
$crimsonFill = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(503, 50)),
    (New-Object System.Drawing.Point(503, 140)),
    [System.Drawing.Color]::FromArgb(255, 180, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 80, 2, 10)
)
$g.FillPath($crimsonFill, $pathTech)
$goldBevelPen.Dispose(); $crimsonFill.Dispose(); $pathTech.Dispose()

# NATIONAL LEVEL TECHNICAL SYMPOSIUM Subtitle
$subFont = New-Object System.Drawing.Font("Arial Black", 16, [System.Drawing.FontStyle]::Bold)
$subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 50, 10, 15))
$g.DrawString("NATIONAL LEVEL TECHNICAL SYMPOSIUM", $subFont, $subBrush, 503, 160, $sf)
$subFont.Dispose(); $subBrush.Dispose()

$g.Dispose()
$base.Dispose()

$tech.Save("d:\Downloads\project01\frontend\assets\plaque_technitix_hd_perfect.png", [System.Drawing.Imaging.ImageFormat]::Png)
$tech.Dispose()

Write-Host "Created HD Technitix plaque successfully!"
