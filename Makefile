.DEFAULT_GOAL := help
SHELL := /bin/bash
PACKAGE_NAME := sync-authorized-keys
PREFIX := /opt

.PHONY: build
build: ## create install files
	envsubst < ./etc/cron.d/sync-authorized-keys.dist > ./etc/cron.d/sync-authorized-keys

.PHONY: clean
clean: ## delete build files
	rm ./etc/cron.d/sync-authorized-keys

.PHONY: install
install: ## create install files
	sudo mv ./etc/cron.d/sync-authorized-keys /etc/cron.d/

.PHONY: uninstall
uninstall: ## delete installed files
	sudo rm -f /etc/cron.d/sync-authorized-keys


.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
