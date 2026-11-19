@echo off
chcp 65001 >nul
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$dir = if (Test-Path '.\assets') { '.\assets' } else { '.' }; ^
$files = Get-ChildItem -Path $dir -File; ^
$groups = @{}; ^
foreach ($f in $files) { ^
    $base = [System.IO.Path]::GetFileNameWithoutExtension($f.Name); ^
    $ext = $f.Extension.ToLower(); ^
    if ($ext -notin @('.jpg','.jpeg','.png','.webp','.mp3','.txt')) { continue }; ^
    if (-not $groups.ContainsKey($base)) { $groups[$base] = @() }; ^
    $groups[$base] += $ext; ^
}; ^
Write-Host '=== VERIFICATION DES FICHIERS DE L''EXPO ===' -ForegroundColor Cyan; ^
Write-Host ('Dossier analyse : ' + (Resolve-Path $dir))`n; ^
$errors = 0; ^
foreach ($key in ($groups.Keys | Sort-Object)) { ^
    $exts = $groups[$key]; ^
    $hasImg = ($exts | Where-Object { $_ -in @('.jpg','.jpeg','.png','.webp') }).Count -gt 0; ^
    $hasMp3 = '.mp3' -in $exts; ^
    $hasTxt = '.txt' -in $exts; ^
    if (-not ($hasImg -and $hasMp3 -and $hasTxt)) { ^
        $errors++; ^
        $missing = @(); ^
        if (-not $hasImg) { $missing += 'IMAGE (.jpg/.png)' }; ^
        if (-not $hasMp3) { $missing += 'AUDIO (.mp3)' }; ^
        if (-not $hasTxt) { $missing += 'TEXTE (.txt)' }; ^
        Write-Host ('[!] ' + $key + ' -> Manquant ou casse differente : ' + ($missing -join ', ')) -ForegroundColor Yellow; ^
    } ^
}; ^
if ($errors -eq 0) { ^
    Write-Host ('PARFAIT ! Les ' + $groups.Count + ' oeuvres sont completes et bien nommees.') -ForegroundColor Green; ^
} else { ^
    Write-Host (`n + $errors + ' anomalie(s) detectee(s) sur ' + $groups.Count + ' entrees.') -ForegroundColor Red; ^
}"
echo.
pause