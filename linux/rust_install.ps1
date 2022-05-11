$url_installScript = https://sh.rustup.rs
$path_installScript = Join-Path $env:HOME "/Downloads/rustup.rs"

wget -O "$path_installScript" $url_installScript

"done"