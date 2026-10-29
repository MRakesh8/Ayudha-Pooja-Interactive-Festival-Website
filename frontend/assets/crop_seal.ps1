Add-Type -AssemblyName System.Drawing

$src = (Resolve-Path ".\frontend\assets\College_logo.png").Path
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$h = $bmp.Height # 219

# The circle center in College_logo.png is at (107, 110), radius = 98
$cx = 107
$cy = 110
$radius = 98

$dst = New-Object System.Drawing.Bitmap(200, 200, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($dy = 0; $dy -lt 200; $dy++) {
    for ($dx = 0; $dx -lt 200; $dx++) {
        $dist = [Math]::Sqrt(($dx - 100)*($dx - 100) + ($dy - 100)*($dy - 100))
        if ($dist -le $radius) {
            $sx = $cx + ($dx - 100)
            $sy = $cy + ($dy - 100)
            $c = $bmp.GetPixel($sx, $sy)
            if ($dist -gt ($radius - 1.5)) {
                $alpha = [int]((1.0 - ($dist - ($radius - 1.5)) / 1.5) * 255)
                $dst.SetPixel($dx, $dy, [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B))
            } else {
                $dst.SetPixel($dx, $dy, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
            }
        } else {
            $dst.SetPixel($dx, $dy, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$crestPath = "d:\Downloads\project01\frontend\assets\srec_crest.png"
$dst.Save($crestPath, [System.Drawing.Imaging.ImageFormat]::Png)

$bmp.Dispose()
$dst.Dispose()
Write-Output "Perfect circle seal saved to $crestPath"
