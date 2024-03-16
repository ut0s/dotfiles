.PHONY: init
init:
	bash -x etc/init.sh

.PHONY: install
install:
	bash -x etc/install.sh

.PHONY: deploy
deploy:
	bash -x etc/deploy.sh

.PHONY: lint
lint:
	bash -x etc/lint.sh
