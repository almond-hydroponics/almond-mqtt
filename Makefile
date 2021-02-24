.PHONY: help
.DEFAULT_GOAL := help

# Project variables
PROJECT_NAME ?= almond-mqtt
TARGET_MAX_CHAR_NUM=10
# File names
DOCKER_DEV_COMPOSE_FILE := docker-compose.yml

#@-- command to start the application container --@#
start:
	${INFO} "Starting docker process"
	${INFO} "Building required docker images"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) build mosquitto
	${INFO} "Build Completed successfully"
	@ echo " "
	${INFO} "Starting local development server"
	@ docker-compose up -d

#@-- command to stop the application container --@#
stop:
	${INFO} "Stop development server containers"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) down -v
	${INFO} "All containers stopped successfully"

#@-- command to clean the docker system --@#
clean:
	${INFO} "Cleaning your local environment"
	${INFO} "Note all ephemeral volumes will be destroyed"
	@ docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) down -v
	@ docker images -q -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
	${INFO} "Removing dangling images"
	@ docker images -q -f dangling=true -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
	@ docker system prune
	${INFO} "Clean complete"

#@-- command to help you out coz you don't know this thing --@
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
MAGENTA  := $(shell tput -Txterm setaf 5)
NC := "\e[0m"
RESET  := $(shell tput -Txterm sgr0)

# Shell Functions
INFO := @bash -c 'printf $(YELLOW); echo "===> $$1"; printf $(NC)' SOME_VALUE
EXTRA := @bash -c 'printf "\n"; printf $(MAGENTA); echo "===> $$1"; printf "\n"; printf $(NC)' SOME_VALUE
SUCCESS := @bash -c 'printf $(GREEN); echo "===> $$1"; printf $(NC)' SOME_VALUE
