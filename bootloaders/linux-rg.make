INSTALL_DIR="${HOME}/.local"
BIN_DIR="${HOME}/.local/bin"

all: ${BIN_DIR}/rg

mkdirs:
	mkdir -p ${INSTALL_DIR} ${BIN_DIR}

ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz: 
	wget https://github.com/burntsushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz

${INSTALL_DIR}/ripgrep-13.0.0-x86_64-unknown-linux-musl: ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
	tar -xvzf ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz -C ${INSTALL_DIR}

${BIN_DIR}/rg: ${INSTALL_DIR}/ripgrep-13.0.0-x86_64-unknown-linux-musl
	ln -s ${INSTALL_DIR}/ripgrep-13.0.0-x86_64-unknown-linux-musl/rg ${BIN_DIR}/rg

clean:
	rm -f ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
