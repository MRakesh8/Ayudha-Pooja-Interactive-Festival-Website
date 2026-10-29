Add-Type -AssemblyName System.Drawing

$src = (Resolve-Path ".\frontend\assets\ayudha_pooja_banner_raw.png").Path
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$w = $bmp.Width
$h = $bmp.Height

$dst = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Function to detect if a pixel is door wood background (above items)
function IsDoorWood([System.Drawing.Color]$c, [int]$x, [int]$y) {
    # If below y=240, it is definitely NOT door wood
    if ($y -gt 240) { return $false }

    # If it has green (leaf), yellow/orange (flower), gold border, or white robot arm/laptop highlight
    # Leaf test: G is prominent
    if ($c.G -gt $c.R -and $c.G -gt 45) { return $false }
    # Gold/Yellow/Orange flower or arch test:
    if ($c.R -gt 130 -and $c.G -gt 70) { return $false }
    # Bright highlights (white robot arm, metal, lamp flame):
    if ($c.R -gt 110 -and $c.G -gt 100 -and $c.B -gt 90) { return $false }
    # Red flower:
    if ($c.R -gt 130 -and $c.G -lt 50) { return $false }
    # Laptop screen edge / body:
    if ($x -gt 210 -and $x -lt 340 -and $y -gt 150) { return $false }

    # Door wood is brownish: R usually 30-90, G usually 15-45, B usually 0-25
    if ($c.R -lt 95 -and $c.G -lt 55 -and $c.B -lt 35) { return $true }

    return $false
}

# Flood fill from top-left (0,0) and top-right (w-1, 0) and top-center (w/2, 0)
$visited = New-Object "bool[,]" $w, $h
$q = New-Object System.Collections.Generic.Queue[System.Drawing.Point]

function EnqueueSeed($sx, $sy) {
    if (-not $visited[$sx, $sy]) {
        $visited[$sx, $sy] = $true
        $q.Enqueue((New-Object System.Drawing.Point($sx, $sy)))
    }
}

for ($x = 0; $x -lt $w; $x += 10) {
    $c = $bmp.GetPixel($x, 0)
    if (IsDoorWood $c $x 0) {
        EnqueueSeed $x 0
    }
}

while ($q.Count -gt 0) {
    $pt = $q.Dequeue()
    $px = $pt.X
    $py = $pt.Y

    $neighbors = @(
        [System.Drawing.Point]::new($px+1, $py),
        [System.Drawing.Point]::new($px-1, $py),
        [System.Drawing.Point]::new($px, $py+1),
        [System.Drawing.Point]::new($px, $py-1)
    )

    foreach ($n in $neighbors) {
        $nx = $n.X
        $ny = $n.Y
        if ($nx -ge 0 -and $nx -lt $w -and $ny -ge 0 -and $ny -lt 240) {
            if (-not $visited[$nx, $ny]) {
                $nc = $bmp.GetPixel($nx, $ny)
                if (IsDoorWood $nc $nx $ny) {
                    $visited[$nx, $ny] = $true
                    $q.Enqueue($n)
                }
            }
        }
    }
}

# Now write to dst: if visited -> transparent (alpha 0)
for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        if ($visited[$x, $y]) {
            $dst.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        } else {
            $c = $bmp.GetPixel($x, $y)
            $dst.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
        }
    }
}

$outPath = "d:\Downloads\project01\frontend\assets\ayudha_pooja_banner_cutout.png"
$dst.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$dst.Dispose()
Write-Output "Successfully saved cutout to $outPath"
