.DEFAULT_GOAL := help
_SCRIPT_FILE := sync-authorized-keys.sh

.PHONY: install
install: ## register to crontab
	@crontab -l | grep $(_SCRIPT_FILE) || (crontab -l; echo "5 * * * * $(PWD)/$(_SCRIPT_FILE)") | crontab

.PHONY: uninstall
uninstall: ## remove from crontab
	@crontab -l | grep -v $(_SCRIPT_FILE) | crontab



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
