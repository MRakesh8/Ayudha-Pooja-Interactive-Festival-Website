Add-Type -AssemblyName System.Drawing
$a = [System.Drawing.Image]::FromFile("d:\Downloads\project01\frontend\assets\plaque_college_perfect.png")
Write-Host "College Plaque: $($a.Width) x $($a.Height) (ratio: $($a.Width / $a.Height))"
$a.Dispose()

$b = [System.Drawing.Image]::FromFile("d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png")
Write-Host "Dept Plaque: $($b.Width) x $($b.Height) (ratio: $($b.Width / $b.Height))"
$b.Dispose()
