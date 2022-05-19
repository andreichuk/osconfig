. "$PSScriptRoot/../io_util.ps1"

$url_zig_downloads = "https://ziglang.org/download/index.json"

$folder_source = Join-Path $env:USERPROFILE "Downloads"
$path_archive = Join-Path $folder_source "zig_compiler.zip"
$folder_zig = "C:/zig/compiler"

Io_DeleteFolderIfExists $folder_zig
Io_DeleteFileIfExists $path_archive

Io_CreateFolderIfNotExists $folder_zig
Io_CreateFolderIfNotExists $folder_source

$webResponse = Invoke-WebRequest -Uri $url_zig_downloads
$json = ConvertFrom-Json $webResponse.Content
$url_zig_archive = $json.master."x86_64-windows".tarball

Invoke-WebRequest -Uri $url_zig_archive -OutFile $path_archive

"archive url: ${url_zig_archive}"

Invoke-WebRequest -Uri $url_zig_archive -OutFile $path_archive

"compiler: extracting '${path_archive}' in '${folder_zig}'"
tar -xf $path_archive -C $folder_zig --strip-components 1

"done"