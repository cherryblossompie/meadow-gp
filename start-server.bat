@echo off
title Mario Kart Clone - Server
echo.
echo   Starting Mario Kart server at http://localhost:8000
echo   Press Ctrl+C to stop.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$listener = New-Object System.Net.HttpListener; $listener.Prefixes.Add('http://localhost:8000/'); $listener.Start(); Write-Host 'Serving on http://localhost:8000/  (Ctrl+C to stop)'; while ($listener.IsListening) { $ctx = $listener.GetContext(); $req = $ctx.Request; $res = $ctx.Response; $path = [Uri]::UnescapeDataString($req.Url.AbsolutePath); if ($path -eq '/') { $path = '/index.html' }; $file = Join-Path $PSScriptRoot ($path.TrimStart('/')); if (Test-Path -LiteralPath $file -PathType Leaf) { $bytes = [System.IO.File]::ReadAllBytes($file); $ext = [System.IO.Path]::GetExtension($file); $map = @{'.html'='text/html';'.js'='application/javascript';'.css'='text/css';'.png'='image/png';'.jpg'='image/jpeg';'.svg'='image/svg+xml';'.glb'='model/gltf-binary';'.json'='application/json'}; $contentType = if ($map.ContainsKey($ext)) { $map[$ext] } else { 'application/octet-stream' }; $res.ContentType = $contentType; $res.ContentLength64 = $bytes.Length; $res.OutputStream.Write($bytes, 0, $bytes.Length) } else { $res.StatusCode = 404 } ; $res.Close() }"