INSTALL_DIR="${HOME}/.local"
BIN_DIR="${HOME}/.local/bin"

all: ${BIN_DIR}/nvim

mkdirs:
	mkdir -p ${INSTALL_DIR} ${BIN_DIR}

${BIN_DIR}/nvim: mkdirs 
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage
	mv nvim.appimage ${BIN_DIR}/nvim
