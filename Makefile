RAILS_ENV ?= test
PROJECT_NAME := sc-billing
RUN := run --rm

ifeq ($(USE_NFSMOUNT), true)
	DOCKER_COMPOSE_FILES := -f docker-compose.yml -f docker-compose.nfsmount.yml
else
	DOCKER_COMPOSE_FILES := -f docker-compose.yml
endif
DOCKER_COMPOSE := docker-compose $(DOCKER_COMPOSE_FILES) --project-name $(PROJECT_NAME)
DOCKER_COMPOSE_RUN := $(DOCKER_COMPOSE) $(RUN)
WEB_CONCURRENCY := 0

provision: bundle db-migrate

db-migrate:
	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=${RAILS_ENV}" app bundle exec rake db:migrate

bash:
	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=${RAILS_ENV}" app bash

compose:
	${DOCKER_COMPOSE} ${CMD}

down:
	${DOCKER_COMPOSE} down

down-v:
	${DOCKER_COMPOSE} down -v

bundle:
	${DOCKER_COMPOSE_RUN} app bundle ${CMD}

rspec:
	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=test" app bundle exec rspec ${T}

psql:
	${DOCKER_COMPOSE_RUN} app psql postgresql://postgres@db/sc_${RAILS_ENV}

build:
	${DOCKER_COMPOSE} build

rebuild:
	${DOCKER_COMPOSE} build --force-rm

rubocop:
	${DOCKER_COMPOSE_RUN} app rubocop
