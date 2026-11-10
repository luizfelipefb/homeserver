.DEFAULT_GOAL := help

# Don't print "Entering/Leaving directory" for sub-makes (used by `uap`)
MAKEFLAGS += --no-print-directory

# Every stack lives in stacks/<name>.yml and runs as its own compose project.
STACKS := home-automation media-server system-monitor system-utils applications

# Retention used by `make set-retention` (override with DUR=24h)
DUR ?= 168h

# $(call compose,<stack>) -> base docker compose command for that stack
compose = docker compose -p $(1) -f stacks/$(1).yml --env-file .env

# None of these targets are files
.PHONY: help all down uap uapf update prune set-retention $(STACKS)

# Lines starting with "## " directly above a target are shown by `make help`
## Show this help
help:
	@echo -e '\n Usage:'
	@echo 'make <target>'
	@echo
	@echo ' Targets:'
	@{ awk '/^## /{d=substr($$0,4); next} /^[a-zA-Z_-]+:/{if(d!=""){split($$0,a,":"); printf "%-30s %s\n", a[1], d} d=""; next} {d=""}' $(MAKEFILE_LIST); \
	   for s in $(STACKS); do printf "%-30s %s\n" "$$s" "Create $$s containers (FORCE=1 to recreate them all)"; done; } | sort

## Create all containers
all: $(STACKS)

# Create/update one stack. Containers are only recreated when their config or
# image changed; run `make <stack> FORCE=1` to recreate them regardless.
$(STACKS):
	@echo -e '\n==> Creating $(subst -, ,$@) containers\n'
	@$(call compose,$@) up -d --remove-orphans $(if $(FORCE),--force-recreate)

## Stop and remove all containers
down:
	@echo -e '\n==> Stopping all containers\n'
	@for s in $(STACKS); do $(call compose,$$s) down; done

## Update images and recreate only the containers that changed, then prune
uap:
	@$(MAKE) update && $(MAKE) all && $(MAKE) prune

## Update images, force-recreate all containers, then prune
uapf:
	@$(MAKE) update && $(MAKE) all FORCE=1 && $(MAKE) prune

## Update images
update:
	@echo -e '\n==> Updating images'
	@for s in $(STACKS); do $(call compose,$$s) pull; done

## Prune dangling images
prune:
	@echo -e '\n==> Pruning dangling images\n'
	@docker image prune -f

## Set the retention of the influxdb telegraf bucket (DUR=168h)
set-retention:
	@echo -e '\n==> Setting telegraf bucket retention to $(DUR)\n'
	@docker exec influxdb sh -c 'influx bucket update --org org --name telegraf --retention "$$1" --token "$$DOCKER_INFLUXDB_INIT_ADMIN_TOKEN"' _ $(DUR)
