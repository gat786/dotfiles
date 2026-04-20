#!/bin/zsh

OUTPUT_DIR=~/.dotfiles-downloads
if [[ -d $OUTPUT_DIR ]]; then
    echo "$OUTPUT_DIR directory exists already, cleaning it and recreating";
    rm -rf $OUTPUT_DIR && mkdir -p $OUTPUT_DIR;
else
    echo "Creating $OUTPUT_DIR";
    mkdir -p $OUTPUT_DIR;
fi;

# this check is zsh specific, won't work anywhere else,
# it checks whether brew is installed or not, if it is present
# it skips installation
if ! (( $+commands[brew] )); then
    echo "Brew is not installed installing it.";
    BREW_VERSION=5.1.7;
    curl -L https://github.com/Homebrew/brew/releases/download/$BREW_VERSION/Homebrew.pkg \
        --output $OUTPUT_DIR/Homebrew.pkg;

    sudo installer -verbose -pkg $OUTPUT_DIR/Homebrew.pkg -target ~
    echo "Brew installation done.";
else
    echo "Brew already present, no need to install.";
fi


brew bundle check
