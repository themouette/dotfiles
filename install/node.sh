#!/bin/bash
# Some variables
VERSION=${1:-'0.12.2'}
PLATFORM="linux-x64"
NODE_PATH="${HOME}/nodejs"

# create directory
mkdir -p "$NODE_PATH" ; cd "$NODE_PATH"

if [[ ! -d "${NODE_PATH}/node-v${VERSION}-${PLATFORM}" ]]; then
    # get archive
    wget "http://nodejs.org/dist/v${VERSION}/node-v${VERSION}-${PLATFORM}.tar.gz" -O /tmp/node.tar.gz
    # extract binaries
    tar xvzf /tmp/node.tar.gz
fi

# install binaries globally
sudo ln -fs "${NODE_PATH}/node-v${VERSION}-${PLATFORM}/bin/npm" /usr/bin/npm
sudo ln -fs "${NODE_PATH}/node-v${VERSION}-${PLATFORM}/bin/node" /usr/bin/node

# Do not require sudo for npm global backages
npm config set prefix '${HOME}/.npm-packages'

npm install -g npm@latest
sudo ln -fs "${HOME}/.npm-packages/bin/npm" /usr/bin/npm

npm install -g eslint babel-eslint
