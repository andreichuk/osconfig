$url_helix_src = "https://github.com/helix-editor/helix"
$editor_src_folder = Join-Path $env:HOME "src" "helix-editor"

git clone $url_helix_src 

Git_CloneOrUpdateRepo $editor_src_folder $url_helix_src

Push-Location $editor_src_folder
& cargo uninstall helix-term
& cargo install --path helix-term
& hx --grammar fetch
& hx --grammar build
Pop-Location

"done"