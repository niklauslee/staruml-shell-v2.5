#!/bin/bash

echo "Brackets Contributor Setup"
echo ""
echo "Contributors should fork the brackets and brackets-shell"
echo "repositories to their own GitHub account. Skip this step"
echo "to use the main repositories."
echo ""

# prompt for GitHub user name
echo -n "(Optional) Enter your GitHub user name and press [ENTER]: "
read username

brackets_shell_adobe_url="https://github.com/adobe/brackets-shell.git"
brackets_adobe_url="https://github.com/adobe/brackets.git"

# default to adobe repositories
if [ -z "$username" ]; then
  brackets_shell_url="$brackets_shell_adobe_url"
  brackets_url="$brackets_adobe_url"
else
  brackets_shell_url="https://github.com/${username}/brackets-shell.git"
  brackets_url="https://github.com/${username}/brackets.git"
fi

# test repository URLs
wget -q $brackets_shell_url
if [ $? -ne 0 ]; then
  echo "brackets-shell repository not found:" $brackets_shell_url
  echo "Fork the repository at https://github.com/adobe/brackets-shell/fork"
  exit 1
fi

wget -q $brackets_url
if [ $? -ne 0 ]; then
  echo "brackets repository not found:" $brackets_shell_url
  echo "Fork the repository at https://github.com/adobe/brackets/fork"
  exit 1
fi

# install git and dev dependencies
sudo apt-get install --assume-yes git libnss3-1d libnspr4-0d gyp gtk+-2.0

# install node and grunt
sudo apt-get install --assume-yes python-software-properties python g++ make
sudo add-apt-repository ppa:chris-lea/node.js -y
sudo apt-get update --assume-yes
sudo apt-get install --assume-yes nodejs
sudo npm install -g grunt-cli

# clone brackets
git clone $brackets_url
pushd brackets

# add upstream
git remote add upstream $brackets_adobe_url
git fetch upstream

# update submodules
git checkout upstream/master
git submodule update --init --recursive
popd

# clone brackets-shell
git clone $brackets_shell_url
pushd brackets-shell

# add upstream
git remote add upstream $brackets_shell_adobe_url
git fetch upstream
git checkout upstream/master

# npm install for node dependencies
# postinstall grunt (setup and build)
sudo npm install
popd

echo "brackets-shell compiled successfully to ./out/Release/Brackets"