DOCKER_COMPOSE?=docker-compose -f docker-compose.yaml
ROOT_DIR=$(shell pwd)
NPM?=docker run --rm -v $(shell pwd):/app -w /app node:carbon-alpine npm
ARGS = $(filter-out $@,$(MAKECMDGOALS))

.PHONY: build start up stop build-no-cache restart compile validate concat publish ci-dredd-publish dredd mock mock-logs

start: publish

up:
	$(DOCKER_COMPOSE) up -d --remove-orphans
	@echo ''
	@echo 'Docker-ui: http://localhost:8084'
	@echo 'Mock-server: http://localhost:4010'

stop:                                                                                                  ## Remove docker containers
	$(DOCKER_COMPOSE) kill

build:
	$(DOCKER_COMPOSE) build --force-rm

build-no-cache:
	$(DOCKER_COMPOSE) build --force-rm --no-cache

restart: stop up

npm:
	$(NPM) ${ARGS}

vendor:
	$(NPM) install

compile:                                                                                                  ## Remove docker containers
	$(NPM) run compile

validate:                                                                                                  ## Remove docker containers
	$(NPM) run validate

concat:                                                                                                  ## Remove docker containers
	$(NPM) run concat

publish: concat compile validate dredd restart

build-ci-minimal: vendor publish

ci-dredd-publish: concat compile validate dredd

dredd:                                                                                                  ## Remove docker containers
	$(NPM) run dredd

# for no docker usage
mock:                                                                                                  ## Remove docker containers
	prism mock build/openapi.yaml

mock-logs:
	$(DOCKER_COMPOSE) logs -f prism
