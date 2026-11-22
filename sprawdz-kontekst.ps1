# Skrypt do podglądu zużycia kontekstu w Claude Desktop bez przerywania czatu
$log = Get-ChildItem "$env:USERPROFILE\.claude\projects\*\*.jsonl" -ErrorAction SilentlyContinue | 
       Sort-Object LastWriteTime -Descending | 
       Select-Object -First 1

if ($log) {
    $line = Get-Content $log.FullName -Tail 50 | 
            Select-String -Pattern '"cache_read_input_tokens":\s*(\d+)' | 
            Select-Object -Last 1

    if ($line -and $line.Matches[0].Groups[1].Value) {
        $tok = [int]$line.Matches[0].Groups[1].Value
        $max = 200000
        $pct = [math]::Round(($tok / $max) * 100, 1)
        $left = $max - $tok
        $pctLeft = [math]::Round(100 - $pct, 1)

        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host "   STAN KONTEKSTU W CLAUDE DESKTOP        " -ForegroundColor Cyan
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host "Projekt / Sesja : $($log.Directory.Name)" -ForegroundColor Gray
        Write-Host "Zużyto tokenów  : $($tok.ToString('N0')) / $($max.ToString('N0')) ($pct%)" -ForegroundColor White
        Write-Host "Zostało tokenów : $($left.ToString('N0')) ($pctLeft% wolnego miejsca)" -ForegroundColor Green

        if ($pct -ge 50) {
            Write-Host ""
            Write-Host "[UWAGA] Kontekst przekroczył 50%! Model może powoli gubić precyzję." -ForegroundColor Yellow
            Write-Host "        Zalecane: podsumuj etap i zresetuj (/clear)." -ForegroundColor Yellow
        }
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host ""
    }
} else {
    Write-Host "Nie znaleziono aktywnych plików sesji Claude Desktop w ~/.claude/projects/" -ForegroundColor Red
}
