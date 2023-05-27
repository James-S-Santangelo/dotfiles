INSTALL_DIR="${HOME}/.local"
BIN_DIR="${HOME}/.local/bin"

all: ${BIN_DIR}/npm

mkdirs:
		mkdir -p ${INSTALL_DIR} ${BIN_DIR}

node-v16.16.0-linux-x64.tar.xz: mkdirs
		wget https://nodejs.org/dist/v16.16.0/node-v16.16.0-linux-x64.tar.xz

${INSTALL_DIR}/node-v16.16.0-linux-x64: node-v16.16.0-linux-x64.tar.xz
		tar -xvf node-v16.16.0-linux-x64.tar.xz -C ${INSTALL_DIR}

${BIN_DIR}/npm: ${INSTALL_DIR}/node-v16.16.0-linux-x64
		ln -s ${INSTALL_DIR}/node-v16.16.0-linux-x64/bin/npm ${BIN_DIR}/npm
		ln -s ${INSTALL_DIR}/node-v16.16.0-linux-x64/bin/corepack ${BIN_DIR}/corepack
		ln -s ${INSTALL_DIR}/node-v16.16.0-linux-x64/bin/node ${BIN_DIR}/node
		ln -s ${INSTALL_DIR}/node-v16.16.0-linux-x64/bin/npx ${BIN_DIR}/npx
