Add-Type -AssemblyName System.Drawing

$base = [System.Drawing.Bitmap]::FromFile("d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png")
$w = $base.Width
$h = $base.Height

$tech = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($tech)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw base frame
$g.DrawImage($base, 0, 0, $w, $h)

# Clear entire interior plaque face (from x=70 to x=935, y=26 to y=230) with smooth radial gold gradient
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddRectangle((New-Object System.Drawing.Rectangle(70, 26, 866, 204)))
$pgrad = New-Object System.Drawing.Drawing2D.PathGradientBrush($path)
$pgrad.CenterPoint = New-Object System.Drawing.PointF(503, 125)
$pgrad.CenterColor = [System.Drawing.Color]::FromArgb(255, 255, 245, 215)
$pgrad.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 240, 185, 95))
$g.FillPath($pgrad, $path)
$pgrad.Dispose()
$path.Dispose()

# Draw Crown at top apex
# Royal Velvet Arch
$velvetBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(450, 10)),
    (New-Object System.Drawing.Point(450, 40)),
    [System.Drawing.Color]::FromArgb(255, 175, 15, 25),
    [System.Drawing.Color]::FromArgb(255, 85, 4, 12)
)
$g.FillPie($velvetBrush, 453, 12, 100, 48, 180, 180)
$velvetBrush.Dispose()

# Crown Gold Band
$goldBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(440, 32)),
    (New-Object System.Drawing.Point(565, 32)),
    [System.Drawing.Color]::FromArgb(255, 220, 150, 30),
    [System.Drawing.Color]::FromArgb(255, 255, 230, 140)
)
$g.FillRectangle($goldBrush, 448, 32, 110, 9)

# Crown 5 Gold Spikes with Jewels
$spikePoints = @(
    (New-Object System.Drawing.Point(448, 32)),
    (New-Object System.Drawing.Point(448, 16)),
    (New-Object System.Drawing.Point(462, 26)),
    (New-Object System.Drawing.Point(478, 10)),
    (New-Object System.Drawing.Point(492, 24)),
    (New-Object System.Drawing.Point(503, 5)),
    (New-Object System.Drawing.Point(514, 24)),
    (New-Object System.Drawing.Point(528, 10)),
    (New-Object System.Drawing.Point(544, 26)),
    (New-Object System.Drawing.Point(558, 16)),
    (New-Object System.Drawing.Point(558, 32))
)
$g.FillPolygon($goldBrush, $spikePoints)

# Jewel tips (Cyan, Ruby, Diamond/Gold, Ruby, Cyan)
$jewelRed = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 20, 30))
$jewelCyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 215))
$jewelGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 240))
$g.FillEllipse($jewelCyan, 445, 13, 6, 6)
$g.FillEllipse($jewelRed, 475, 7, 6, 6)
$g.FillEllipse($jewelGold, 500, 2, 7, 7)
$g.FillEllipse($jewelRed, 525, 7, 6, 6)
$g.FillEllipse($jewelCyan, 555, 13, 6, 6)

# Gems on crown headband
for ($gx = 456; $gx -le 548; $gx += 15) {
    $g.FillEllipse($jewelRed, $gx, 34, 5, 5)
}
$jewelRed.Dispose(); $jewelCyan.Dispose(); $jewelGold.Dispose(); $goldBrush.Dispose()

# Render TECHNITIX Typography (ONLY TECHNITIX - NO SUBTITLE, PERFECTLY CENTERED)
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

# TECHNITIX Title (Bold Georgia serif with gold bevel and rich crimson gradient)
$pathTech = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathTech.AddString("TECHNITIX", (New-Object System.Drawing.FontFamily("Georgia")), [int][System.Drawing.FontStyle]::Bold, 86, (New-Object System.Drawing.Point(503, 66)), $sf)

# Gold bevel stroke
$goldBevelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 255, 230, 110), 6.5)
$goldBevelPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$g.DrawPath($goldBevelPen, $pathTech)

# Deep crimson gradient fill
$crimsonFill = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(503, 65)),
    (New-Object System.Drawing.Point(503, 185)),
    [System.Drawing.Color]::FromArgb(255, 185, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 75, 2, 10)
)
$g.FillPath($crimsonFill, $pathTech)
$goldBevelPen.Dispose(); $crimsonFill.Dispose(); $pathTech.Dispose()

$g.Dispose()
$base.Dispose()

# Save to both target locations
$tech.Save("d:\Downloads\project01\frontend\assets\plaque_technitix_perfect.png", [System.Drawing.Imaging.ImageFormat]::Png)
$tech.Save("d:\Downloads\project01\frontend\assets\plaque_technitix_hd_perfect.png", [System.Drawing.Imaging.ImageFormat]::Png)
$tech.Dispose()

Write-Host "Created clean TECHNITIX plaque (with Crown, without subtitle) successfully!"
