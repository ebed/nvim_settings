#!/bin/bash
# Helper script to load environment variables from zsh/bash into Neovim

# Source user profile files to load all environment variables
if [ -f ~/.zshrc ]; then
  source ~/.zshrc
fi

if [ -f ~/.bash_profile ]; then
  source ~/.bash_profile
fi

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# Print all environment variables in a format Neovim can parse
env