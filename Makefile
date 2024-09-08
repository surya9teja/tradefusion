ifneq (,$(wildcard ./.env))
	include .env
	export $(shell sed 's/=.*//' .env)
endif

# If the first argument is "run"...
ifeq (npm,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  NPM_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

SERVICE_NAME=tradefusion-app

# Docker compose commands
docker-build:
	docker compose build

docker-up:
	docker compose up -d

docker-down:
	docker compose down

docker-clean:
	docker compose down -v --rmi all --remove-orphans

docker-restart:
	docker compose down
	docker compose up -d

# npm commands
.PHONY: npm vite
npm:
	docker compose run --rm $(SERVICE_NAME) npm $(filter-out $@, $(MAKECMDGOALS))

vite:
	docker compose run --rm $(SERVICE_NAME) vite $(filter-out $@, $(MAKECMDGOALS))
%:
	@true