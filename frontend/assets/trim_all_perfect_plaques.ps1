Add-Type -AssemblyName System.Drawing

function CleanBottomTabs($filePath) {
    $bytes = [System.IO.File]::ReadAllBytes($filePath)
    $ms = New-Object System.IO.MemoryStream($bytes, 0, $bytes.Length)
    $src = [System.Drawing.Image]::FromStream($ms)
    $bmp = New-Object System.Drawing.Bitmap($src)
    $ms.Dispose()

    $w = $bmp.Width
    $h = $bmp.Height

    # Scan bottom rows: anything below the main bottom gold molding (y >= 232) that is a tab or fringe
    for ($y = 232; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }

    # Tightly crop bounding box of visible content
    $minX = $w; $maxX = 0; $minY = $h; $maxY = 0
    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            if ($bmp.GetPixel($x, $y).A -gt 15) {
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }

    $cropRect = New-Object System.Drawing.Rectangle($minX, $minY, ($maxX - $minX + 1), ($maxY - $minY + 1))
    $cropped = $bmp.Clone($cropRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $bmp.Dispose()
    $src.Dispose()

    $cropped.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $cropped.Dispose()

    Write-Host "Cleaned and cropped ${filePath} ($($cropRect.Width) x $($cropRect.Height))"
}

CleanBottomTabs "d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png"
CleanBottomTabs "d:\Downloads\project01\frontend\assets\plaque_college_perfect.png"
CleanBottomTabs "d:\Downloads\project01\frontend\assets\plaque_technitix_perfect.png"
