DOWNLOAD_DIR="${HOME}/download"
INSTALL_DIR="${HOME}/.local/ripgrep"
BIN_DIR="${HOME}/.local/bin"

mkdir -p $DOWNLOAD_DIR $INSTALL_DIR $BIN_DIR

URL="https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz"

cd $DOWNLOAD_DIR
curl -LO $URL
tar -xvzf ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz \
    -C $INSTALL_DIR
ln -sf $INSTALL_DIR/ripgrep-13.0.0-x86_64-unknown-linux-musl/rg $BIN_DIR/rg

