.DEFAULT_GOAL := help
SHELL := /bin/bash
SCRIPT_FILE := sync-authorized-keys.sh
PREFIX := /opt

.PHONY: install
install: ## register to crontab
	@crontab -l | grep $(SCRIPT_FILE) || (crontab -l; echo "0 */12 * * * $(PWD)/$(SCRIPT_FILE) -x") | crontab

.PHONY: uninstall
uninstall: ## remove from crontab
	@crontab -l | grep -v $(SCRIPT_FILE) | crontab



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
