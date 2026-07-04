#!/bin/zsh

OUTPUT_DIR=~/.dotfiles-downloads
if [[ -d $OUTPUT_DIR ]]; then
    echo "$OUTPUT_DIR directory exists already, cleaning it and recreating";
    rm -rf $OUTPUT_DIR && mkdir -p $OUTPUT_DIR;
else
    echo "Creating $OUTPUT_DIR";
    mkdir -p $OUTPUT_DIR;
fi;

brew -v
EXISTS=$?

if [[ $EXISTS -ne 0 ]]; then
	echo "Brew is not installed installing it.";
	ORG=Homebrew
	REPO=brew

	echo "Getting latest version of brew";
	BREW_VERSION=$(curl -sSL https://api.github.com/repos/$ORG/$REPO/releases/latest | jq -r ".tag_name")
	echo "Latest version of Homebrew:$BREW_VERSION, installing now..."

	curl -sL https://github.com/Homebrew/brew/releases/download/$BREW_VERSION/Homebrew.pkg \
		--output $OUTPUT_DIR/Homebrew.pkg;

    sudo installer -verbose -p $OUTPUT_DIR/Homebrew.pkg -target ~
    echo "Brew installation done.";
else
    echo "Brew already present, no need to install.";
fi

echo "Installing personal brew bundle";
brew bundle install
echo "personal brew bundle installation completed";

echo "Downloading nvim config and linking it to current environment";

NVIM_CONFIG_DIR=$HOME/.config/nvim

echo "Checking nvim config setup";
if [[ ! -d "$NVIM_CONFIG_DIR" ]]; then
  git clone https://github.com/gat786/nvim-config nvim-config
  (cd nvim-config && make link)
fi
echo "Nvim config already exists, will leave it be";

echo "Done";

OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [[ ! -d "$OHMYZSH_DIR" ]]; then
  echo "Installing oh-my-zsh";
  curl -fsSL \
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
    -o "$OUTPUT_DIR/oh-my-zsh-install.sh"
  (cd "$OUTPUT_DIR" && sh oh-my-zsh-install.sh)
else
  echo "oh-my-zsh installation already exists";
fi

echo "Setting nvim theme";
sed -i "" 's/ZSH_THEME.*/ZSH_THEME="fino-time"/g' ~/.zshrc

GITCONFIG=$HOME/.gitconfig

if [[ ! -d $GITCONFIG ]]; then

echo "Gitconfig not found, setting the default config that uses 1Password";
# cannot indent heredoc, it causes issues
# writing it on the same line
cat << EOF >> $GITCONFIG
[user]
  name = Ganesh Tiwari
  email = ganesht049@gmail.com
  signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMz4bneIpEiwJmBQdoXpFR/gRhSUH+NZVPsVFJjt71F

[gpg]
  format = ssh

[gpg "ssh"]
  program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"

[commit]
  gpgsign = true
EOF
fi
