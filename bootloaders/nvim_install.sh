INSTALL_DIR="${HOME}/.local"
BIN_DIR="${HOME}/.local/bin"

mkdir -p ${BIN_DIR} &&
git clone https://github.com/neovim/neovim &&
cd neovim && 
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=${INSTALL_DIR}/nvim install &&
ln -s ${INSTALL_DIR}/nvim/bin/nvim ${BIN_DIR}/nvim &&
cd .. && rm -rf neovim

