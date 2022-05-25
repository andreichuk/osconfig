. "$PSScriptRoot/../git_util.ps1"
. "$PSScriptRoot/../io_util.ps1"

$url_zig_tools_src = "https://github.com/zigtools/zls"

$folder_source = Join-Path $env:HOME "src" 
$folder_zig_languageServer_source = Join-Path $folder_source "zls"
$folder_languageServer = Join-Path $env:HOME "zig_stuff" "language_server"
$path_zls = Join-Path $folder_zig_languageServer_source "zig-out/bin/zls"

Git_CloneOrUpdateRepo $folder_zig_languageServer_source $url_zig_tools_src

Push-Location $folder_zig_languageServer_source
& zig build -Drelease-safe
Pop-Location

if ($LASTEXITCODE -ne 0) {
    "zls compilation failed. Exit code ${LASTEXITCODE}"
    Exit(1)
}

"lang server: copy binary"
Copy-Item -Path $path_zls -Destination $folder_languageServer

"done"