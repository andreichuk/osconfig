$url_helix_src = "https://github.com/helix-editor/helix"
$editor_src_folder = Join-Path $env:TEMP "helix_editor_src"

function l_DeleteFolderIfExists {
    param ( $path )

    if((Test-Path $path) -eq $false) {
        return;
    }

    Remove-Item –Path $path -Recurse -Force
}

l_DeleteFolderIfExists $editor_src_folder
git clone $url_helix_src $editor_src_folder
Push-Location $editor_src_folder
& cargo uninstall helix-term
& cargo install --path helix-term
& hx --grammar fetch
& hx --grammar build
Pop-Location
l_DeleteFolderIfExists $editor_src_folder
"done"