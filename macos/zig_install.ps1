$url_zig_downloads = "https://ziglang.org/download/"
$folder_src = "~/tmp/zig"
$path_archive = Join-Path $folder_src "zig_archive_file"
$folder_zig = "~/zig"
$folder_zig_languageServer_src = Join-Path $folder_src "zls_src"

$zig = $folder_zig
$path_zls = Join-Path $folder_zig_languageServer_src "zig-out/bin/zls"

function l_DeleteFolderIfExists {
    param (
        $path
    )
    
    if((Test-Path $path) -eq $true) {
        return;
    }
    
    "deleting ${path}"
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue -ErrorVariable RemoveItemError
    if($RemoveItemError) {
        "can't delete: " + $RemoveItemError
    }
}

function l_CreateFolder {
    param (
        $path
    )
    
    if((Test-Path $path) -eq $true) {
        return;
    }

    "creating ${path}"
    New-Item -Path $path -ItemType Directory -Force
}

l_DeleteFolderIfExists $folder_src
l_DeleteFolderIfExists $folder_zig

"preparation: creating '${folder_src}'"
l_CreateFolder $folder_src

"compiler: creating '${folder_zig}'"
l_CreateFolder $folder_zig

$webResponse = Invoke-WebRequest -Uri $url_zig_downloads
$url_zig_archive =  $webResponse.Links |
    Select-Object href |
    Out-String -Stream |
    Select-String -Pattern ".*\/zig-macos-aarch64-.+-dev\..+\.tar\.xz" -Raw |
    Select-Object -First 1

"archive url: ${url_zig_archive}"
Invoke-WebRequest -Uri $url_zig_archive -OutFile $path_archive

"compiler: extracting '${path_archive}' in '${folder_zig}'"
tar -xf $path_archive -C $folder_zig --strip-components 1

"lang server: cloning"
git clone --recurse-submodules "https://github.com/zigtools/zls" $folder_zig_languageServer_src
Push-Location $folder_zig_languageServer_src
Get-Location 
& zig build -Drelease-safe
Pop-Location

if ($LASTEXITCODE -ne 0) {
    "zls compilation failed. Exit code ${LASTEXITCODE}"
    Exit(1)
}

"lang server: copy binary"
Copy-Item -Path $path_zls -Destination $folder_zig

"lang server: delete sources"
l_DeleteFolderIfExists $folder_src

"done"