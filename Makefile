install:
	bash install.sh

backup-configs:
	cp ${HOME}/.config/zed/settings.json config-files/zed-settings.jsonc
