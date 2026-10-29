Add-Type -AssemblyName System.Drawing

$src = (Resolve-Path ".\frontend\assets\ayudha_pooja_banner_raw.png").Path
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$w = $bmp.Width
$h = $bmp.Height

$dst = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Define precise control points for top contour [x, y]
$pts = @(
    @(0, 220),
    @(110, 210),
    @(170, 150),
    @(210, 155),
    @(235, 120),
    @(255, 105),
    @(290, 85),
    @(360, 80),
    @(420, 68),
    @(500, 66),
    @(580, 60),
    @(635, 46),   # Arch apex
    @(690, 60),
    @(770, 66),
    @(850, 68),
    @(910, 80),
    @(980, 85),
    @(1015, 105),
    @(1045, 118),  # Robot arm apex
    @(1095, 135),
    @(1140, 150),
    @(1190, 205),
    @(1271, 220)
)

# Interpolate top boundary y at given x
function GetTopY([double]$x) {
    if ($x -le $pts[0][0]) { return $pts[0][1] }
    if ($x -ge $pts[$pts.Count - 1][0]) { return $pts[$pts.Count - 1][1] }

    for ($i = 0; $i -lt $pts.Count - 1; $i++) {
        $p1 = $pts[$i]
        $p2 = $pts[$i + 1]
        if ($x -ge $p1[0] -and $x -le $p2[0]) {
            $t = ($x - $p1[0]) / ($p2[0] - $p1[0])
            # Smooth cubic hermite interpolation
            $smoothT = $t * $t * (3 - 2 * $t)
            return $p1[1] + ($p2[1] - $p1[1]) * $smoothT
        }
    }
    return 100
}

for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $topY = GetTopY $x
        $dist = $y - $topY

        if ($dist -lt 0) {
            # Fully transparent above contour
            $dst.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        } elseif ($dist -lt 4) {
            # Soft feathered edge
            $alpha = [int]($dist * 63.75)
            $c = $bmp.GetPixel($x, $y)
            $dst.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B))
        } else {
            # Fully opaque content below contour
            $c = $bmp.GetPixel($x, $y)
            $dst.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
        }
    }
}

$outPath = "d:\Downloads\project01\frontend\assets\ayudha_pooja_banner_clean.png"
$dst.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$dst.Dispose()
Write-Output "Pruned and perfected banner saved to $outPath"
