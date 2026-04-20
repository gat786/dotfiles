#!/bin/zsh

OUTPUT_DIR=~/.dotfiles-downloads
if [[ -d $OUTPUT_DIR ]]; then
    echo "$OUTPUT_DIR directory exists already, cleaning it and recreating";
    rm -rf $OUTPUT_DIR && mkdir -p $OUTPUT_DIR;
else
    echo "Creating $OUTPUT_DIR";
    mkdir -p $OUTPUT_DIR;
fi;

BREW_VERSION=5.1.7;
curl -L https://github.com/Homebrew/brew/releases/download/$BREW_VERSION/Homebrew.pkg \
    --output $OUTPUT_DIR/Homebrew.pkg

sudo installer -verbose -pkg $OUTPUT_DIR/Homebrew.pkg -target ~

brew bundle install
